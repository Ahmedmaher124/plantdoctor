import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantdoctor/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/chat_message.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

class ChatScreen extends StatefulWidget {
  final String? initialPrompt;
  const ChatScreen({super.key, this.initialPrompt});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialPrompt != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ChatCubit>().sendMessage(widget.initialPrompt!);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    context.read<ChatCubit>().sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final inputBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final dividerColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.eco_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.chatTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: AppTextStyles.fontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    l10n.chatSubtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              final hasMessages = (state is ChatLoaded && state.messages.isNotEmpty) ||
                  state is ChatError;
              if (!hasMessages) return const SizedBox.shrink();
              return IconButton(
                tooltip: l10n.chatClearConversation,
                onPressed: () => context.read<ChatCubit>().clearChat(),
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Message List ─────────────────────────────────────────────────
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) => _scrollToBottom(),
              builder: (context, state) {
                if (state is ChatInitial) {
                  return _WelcomeView(l10n: l10n, isDark: isDark);
                }

                List<ChatMessage> messages = [];
                bool isLoading = false;
                String? errorText;

                if (state is ChatLoaded) {
                  messages = state.messages;
                  isLoading = state.isLoading;
                } else if (state is ChatError) {
                  messages = state.previousMessages;
                  errorText = state.message;
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: messages.length +
                      (isLoading ? 1 : 0) +
                      (errorText != null ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Error tile
                    if (index == messages.length + (isLoading ? 1 : 0) && errorText != null) {
                      return _ErrorTile(
                        message: errorText,
                        l10n: l10n,
                        onRetry: () => context.read<ChatCubit>().dismissError(),
                      );
                    }
                    // Typing indicator
                    if (isLoading && index == messages.length) {
                      return _TypingIndicator(l10n: l10n);
                    }
                    // Regular message bubble
                    return _MessageBubble(
                      message: messages[index],
                      isDark: isDark,
                    );
                  },
                );
              },
            ),
          ),

          Divider(height: 1, color: dividerColor),

          // ── Input Bar ────────────────────────────────────────────────────
          Container(
            color: inputBg,
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      maxLines: 5,
                      minLines: 1,
                      textInputAction: TextInputAction.newline,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 14,
                        color: isDark ? Colors.white : AppColors.primaryDark,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.chatInputHint,
                        hintStyle: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                          color: AppColors.textGrey,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    final isLoading = state is ChatLoaded && state.isLoading;
                    return _SendButton(
                      onSend: isLoading ? null : _send,
                      isLoading: isLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Welcome Screen ─────────────────────────────────────────────────────────────

class _WelcomeView extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isDark;

  const _WelcomeView({required this.l10n, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      l10n.chatSuggestion1,
      l10n.chatSuggestion2,
      l10n.chatSuggestion3,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Bot avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.eco_rounded, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 20),

          // Welcome bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Text(
              l10n.chatWelcome,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14,
                color: isDark ? Colors.white : AppColors.primaryDark,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),

          // Suggestion chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: suggestions
                .map((s) => _SuggestionChip(text: s, isDark: isDark))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String text;
  final bool isDark;

  const _SuggestionChip({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<ChatCubit>().sendMessage(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lightbulb_outline_rounded,
                size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 12,
                color: isDark ? Colors.white : AppColors.primaryDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Message Bubble ──────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;

  const _MessageBubble({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            _BotAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: message.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied to clipboard'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: BoxDecoration(
                  color: isUser
                      ? AppColors.primary
                      : (isDark
                          ? const Color(0xFF1E293B)
                          : Colors.white),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isUser ? 18 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    height: 1.6,
                    color: isUser
                        ? Colors.white
                        : (isDark ? Colors.white : AppColors.primaryDark),
                  ),
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _BotAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.eco_rounded, color: Colors.white, size: 16),
    );
  }
}

// ── Typing Indicator ────────────────────────────────────────────────────────

class _TypingIndicator extends StatefulWidget {
  final AppLocalizations l10n;

  const _TypingIndicator({required this.l10n});

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          _BotAvatar(),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (_, __) => Row(
                    children: List.generate(3, (i) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(
                              alpha: (i == 0
                                  ? _animation.value
                                  : i == 1
                                      ? (1 - _animation.value) * 0.5 + 0.4
                                      : _animation.value * 0.6 + 0.2)),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.l10n.chatTyping,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error Tile ──────────────────────────────────────────────────────────────

class _ErrorTile extends StatelessWidget {
  final String message;
  final AppLocalizations l10n;
  final VoidCallback onRetry;

  const _ErrorTile({
    required this.message,
    required this.l10n,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.statusRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.statusRed.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.statusRed, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 13,
                color: AppColors.statusRed,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              l10n.chatErrorRetry,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.w600,
                color: AppColors.statusRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Send Button ──────────────────────────────────────────────────────────────

class _SendButton extends StatelessWidget {
  final VoidCallback? onSend;
  final bool isLoading;

  const _SendButton({this.onSend, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSend,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: onSend == null ? AppColors.textGrey : AppColors.primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: onSend == null
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
      ),
    );
  }
}
