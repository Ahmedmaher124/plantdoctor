import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/disease_model.dart';

class DiseaseCard extends StatelessWidget {
  final DiseaseModel disease;
  final VoidCallback onTap;

  const DiseaseCard({
    super.key,
    required this.disease,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.primaryDark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Thumbnail ──────────────────────────────────────────────
            Hero(
              tag: 'disease_image_${disease.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: disease.thumbnailUrl != null
                    ? CachedNetworkImage(
                        imageUrl: disease.thumbnailUrl!,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          width: 110,
                          height: 110,
                          color: AppColors.surfaceLeaf,
                          child: const Icon(
                            Icons.local_florist_rounded,
                            color: AppColors.primary,
                            size: 36,
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          width: 110,
                          height: 110,
                          color: AppColors.surfaceLeaf,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.primary,
                            size: 36,
                          ),
                        ),
                      )
                    : Container(
                        width: 110,
                        height: 110,
                        color: AppColors.surfaceLeaf,
                        child: const Icon(
                          Icons.local_florist_rounded,
                          color: AppColors.primary,
                          size: 36,
                        ),
                      ),
              ),
            ),

            // ── Text Content ───────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Common name
                    Text(
                      disease.commonName,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Scientific name (italic)
                    Text(
                      disease.scientificName,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // Host count tag
                    if (disease.hosts.isNotEmpty) ...[
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _InfoChip(
                            icon: Icons.grass_rounded,
                            label:
                                '${disease.hosts.length} host${disease.hosts.length > 1 ? 's' : ''}',
                            isDark: isDark,
                          ),
                          if (disease.solutions.isNotEmpty)
                            _InfoChip(
                              icon: Icons.medical_services_outlined,
                              label:
                                  '${disease.solutions.length} solution${disease.solutions.length > 1 ? 's' : ''}',
                              isDark: isDark,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── Arrow ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.surfaceLeaf,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 10,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
