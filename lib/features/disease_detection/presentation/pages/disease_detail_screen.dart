import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/disease_model.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final DiseaseModel disease;

  const DiseaseDetailScreen({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.primaryDark;
    final subColor = isDark ? const Color(0xFF94A3B8) : AppColors.textGrey;
    final dividerColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // ── Hero Image App Bar ───────────────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.primary,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.35),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'disease_image_${disease.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (disease.firstImageUrl != null)
                      CachedNetworkImage(
                        imageUrl: disease.firstImageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: AppColors.gradientStart,
                          child: const Center(
                            child: CircularProgressIndicator(
                                color: Colors.white),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.gradientStart,
                          child: const Icon(Icons.local_florist_rounded,
                              color: Colors.white, size: 80),
                        ),
                      )
                    else
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.gradientStart,
                              AppColors.gradientEnd,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.local_florist_rounded,
                              color: Colors.white, size: 80),
                        ),
                      ),
                    // Gradient overlay for readability
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Content ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Names
                  Text(
                    disease.commonName,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    disease.scientificName,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Other names
                  if (disease.otherNames.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: disease.otherNames
                          .map((n) => _SmallChip(label: n, isDark: isDark))
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 24),
                  Divider(color: dividerColor),
                  const SizedBox(height: 16),

                  // ── Descriptions ──────────────────────────────────
                  if (disease.descriptions.isNotEmpty) ...[
                    _SectionTitle(
                        icon: Icons.info_outline_rounded,
                        label: 'About',
                        isDark: isDark),
                    const SizedBox(height: 12),
                    ...disease.descriptions.map((desc) => _DescriptionBlock(
                          subtitle: desc.subtitle,
                          body: desc.description,
                          cardColor: cardColor,
                          textColor: textColor,
                          subColor: subColor,
                        )),
                    const SizedBox(height: 24),
                  ],

                  // ── Solutions ─────────────────────────────────────
                  if (disease.solutions.isNotEmpty) ...[
                    _SectionTitle(
                        icon: Icons.medical_services_rounded,
                        label: 'Treatments & Solutions',
                        isDark: isDark),
                    const SizedBox(height: 12),
                    ...disease.solutions.asMap().entries.map((entry) =>
                        _SolutionBlock(
                          index: entry.key + 1,
                          subtitle: entry.value.subtitle,
                          body: entry.value.description,
                          cardColor: cardColor,
                          textColor: textColor,
                          subColor: subColor,
                        )),
                    const SizedBox(height: 24),
                  ],

                  // ── Host Plants ───────────────────────────────────
                  if (disease.hosts.isNotEmpty) ...[
                    _SectionTitle(
                        icon: Icons.grass_rounded,
                        label: 'Affected Plants',
                        isDark: isDark),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: disease.hosts
                          .map((h) => _HostChip(label: h, isDark: isDark))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── Image Gallery ─────────────────────────────────
                  if (disease.images.length > 1) ...[
                    _SectionTitle(
                        icon: Icons.photo_library_rounded,
                        label: 'Gallery',
                        isDark: isDark),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 160,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: disease.images.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final img = disease.images[index];
                          return GestureDetector(
                            onTap: () => _openFullImage(context, img.bestUrl),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: img.bestUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: img.bestUrl!,
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => Container(
                                        width: 160,
                                        color: AppColors.surfaceLeaf,
                                      ),
                                      errorWidget: (_, __, ___) => Container(
                                        width: 160,
                                        color: AppColors.surfaceLeaf,
                                        child: const Icon(
                                            Icons.broken_image_outlined,
                                            color: AppColors.primary),
                                      ),
                                    )
                                  : Container(
                                      width: 160,
                                      color: AppColors.surfaceLeaf,
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFullImage(BuildContext context, String? url) {
    if (url == null) return;
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        barrierDismissible: true,
        pageBuilder: (_, __, ___) => GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.contain,
              placeholder: (_, __) => const CircularProgressIndicator(
                  color: Colors.white),
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.broken_image_outlined, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable sub-widgets ──────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _SectionTitle(
      {required this.icon, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}

class _DescriptionBlock extends StatelessWidget {
  final String? subtitle;
  final String? body;
  final Color cardColor;
  final Color textColor;
  final Color subColor;

  const _DescriptionBlock({
    this.subtitle,
    this.body,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subtitle != null && subtitle!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                subtitle!,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
          if (body != null && body!.isNotEmpty)
            Text(
              body!,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 13,
                color: subColor,
                height: 1.6,
              ),
            ),
        ],
      ),
    );
  }
}

class _SolutionBlock extends StatelessWidget {
  final int index;
  final String? subtitle;
  final String? body;
  final Color cardColor;
  final Color textColor;
  final Color subColor;

  const _SolutionBlock({
    required this.index,
    this.subtitle,
    this.body,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step badge
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: AppTextStyles.fontFamily,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtitle != null && subtitle!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      subtitle!,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                if (body != null && body!.isNotEmpty)
                  Text(
                    body!,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 13,
                      color: subColor,
                      height: 1.6,
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

class _HostChip extends StatelessWidget {
  final String label;
  final bool isDark;
  const _HostChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.surfaceLeaf,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.eco_outlined, size: 13, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SmallChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 11,
          color: isDark ? Colors.white70 : AppColors.textGrey,
        ),
      ),
    );
  }
}
