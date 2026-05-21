import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantdoctor/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final isDark = state.isDarkMode;
        final isArabic = state.isArabic;

        final bgColor =
            isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
        final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final textColor = isDark ? Colors.white : AppColors.primaryDark;
        final subtitleColor =
            isDark ? const Color(0xFF94A3B8) : AppColors.textGrey;
        final dividerColor =
            isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

        return Scaffold(
          backgroundColor: bgColor,
          body: CustomScrollView(
            slivers: [
              // ── App Bar ────────────────────────────────────────────
              SliverAppBar(
                backgroundColor: AppColors.primary,
                expandedHeight: 120,
                pinned: true,
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    l10n.settingsTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: AppTextStyles.fontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  centerTitle: false,
                  titlePadding:
                      const EdgeInsetsDirectional.only(start: 56, bottom: 16),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // ── Appearance ─────────────────────────────────
                      _SectionHeader(
                        label: l10n.settingsAppearance,
                        icon: Icons.palette_outlined,
                      ),
                      const SizedBox(height: 12),

                      _SettingsCard(
                        cardColor: cardColor,
                        dividerColor: dividerColor,
                        children: [
                          _SwitchTile(
                            icon: isDark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            iconColor: isDark
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFFF97316),
                            iconBg: isDark
                                ? const Color(0x26F59E0B)
                                : const Color(0xFFFFF7ED),
                            title: l10n.settingsDarkMode,
                            subtitle: isDark
                                ? l10n.settingsDarkModeOn
                                : l10n.settingsDarkModeOff,
                            value: isDark,
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                            onChanged: (val) =>
                                context.read<SettingsCubit>().toggleDarkMode(val),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Language ───────────────────────────────────
                      _SectionHeader(
                        label: l10n.settingsLanguage,
                        icon: Icons.language_rounded,
                      ),
                      const SizedBox(height: 12),

                      _SettingsCard(
                        cardColor: cardColor,
                        dividerColor: dividerColor,
                        children: [
                          _LanguageTile(
                            flagEmoji: '🇸🇦',
                            nativeName: 'العربية',
                            localName: l10n.settingsLangArabic,
                            isSelected: isArabic,
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                            isDark: isDark,
                            onTap: () =>
                                context.read<SettingsCubit>().setLanguage('ar'),
                          ),
                          Divider(height: 1, color: dividerColor, indent: 72),
                          _LanguageTile(
                            flagEmoji: '🇺🇸',
                            nativeName: 'English',
                            localName: l10n.settingsLangEnglish,
                            isSelected: !isArabic,
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                            isDark: isDark,
                            onTap: () =>
                                context.read<SettingsCubit>().setLanguage('en'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── About ──────────────────────────────────────
                      _SectionHeader(
                        label: l10n.settingsAbout,
                        icon: Icons.info_outline_rounded,
                      ),
                      const SizedBox(height: 12),

                      _SettingsCard(
                        cardColor: cardColor,
                        dividerColor: dividerColor,
                        children: [
                          _InfoTile(
                            icon: Icons.eco_rounded,
                            iconColor: AppColors.primary,
                            iconBg: const Color(0x1F009966),
                            title: l10n.settingsAppName,
                            subtitle: l10n.settingsVersion,
                            textColor: textColor,
                            subtitleColor: subtitleColor,
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // ── Footer ─────────────────────────────────────
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0x1A009966),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.eco_rounded,
                                      color: AppColors.primary, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Plant Doctor',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.settingsTagline,
                              style: TextStyle(
                                color: subtitleColor,
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Reusable Widgets ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SectionHeader({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.primary,
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.w700,
            fontSize: 11,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Color cardColor;
  final Color dividerColor;
  final List<Widget> children;

  const _SettingsCard({
    required this.cardColor,
    required this.dividerColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool value;
  final Color textColor;
  final Color subtitleColor;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.textColor,
    required this.subtitleColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: subtitleColor,
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String flagEmoji;
  final String nativeName;
  final String localName;
  final bool isSelected;
  final Color textColor;
  final Color subtitleColor;
  final bool isDark;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.flagEmoji,
    required this.nativeName,
    required this.localName,
    required this.isSelected,
    required this.textColor,
    required this.subtitleColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0x1F009966)
                    : (isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(flagEmoji,
                    style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nativeName,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : textColor,
                      fontFamily: AppTextStyles.fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    localName,
                    style: TextStyle(
                      color: subtitleColor,
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : AppColors.textGrey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final Color textColor;
  final Color subtitleColor;

  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontFamily: AppTextStyles.fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: subtitleColor,
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
