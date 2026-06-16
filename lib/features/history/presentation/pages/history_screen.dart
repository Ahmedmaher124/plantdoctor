import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plantdoctor/l10n/app_localizations.dart';

import '../../../../core/dependency_injection/injection_container.dart' as di;
import '../../../../core/routes/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/scan_history_model.dart';
import '../cubit/history_cubit.dart';
import '../widgets/scan_history_card.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _sortNewest = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    // Simulated pull to refresh for local database
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          l10n.historyTitle,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          ValueListenableBuilder<Box<ScanHistoryModel>>(
            valueListenable: di.sl<Box<ScanHistoryModel>>().listenable(),
            builder: (context, box, _) {
              if (box.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_rounded),
                tooltip: l10n.historyDeleteAllConfirmTitle,
                onPressed: () => _showDeleteAllConfirmation(context, l10n),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search and Sort Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              color: AppColors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.indicatorInactive.withOpacity(0.4),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: l10n.historySearchPlaceholder,
                          hintStyle: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: AppColors.textGrey,
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textGrey),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 20),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Sort button
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _sortNewest
                            ? Icons.trending_down_rounded
                            : Icons.trending_up_rounded,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _sortNewest = !_sortNewest;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // History list
            Expanded(
              child: ValueListenableBuilder<Box<ScanHistoryModel>>(
                valueListenable: di.sl<Box<ScanHistoryModel>>().listenable(),
                builder: (context, box, _) {
                  final scans = box.values.toList();

                  // Apply search filtering
                  final filteredScans = scans.where((scan) {
                    final query = _searchQuery.toLowerCase().trim();
                    if (query.isEmpty) return true;
                    return scan.plantName.toLowerCase().contains(query) ||
                        scan.diseaseName.toLowerCase().contains(query);
                  }).toList();

                  if (filteredScans.isEmpty) {
                    return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history_rounded,
                              size: 72,
                              color: AppColors.textGrey.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? l10n.homeNoPlantsFound
                                  : l10n.historyEmptyState,
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textGrey,
                              ),
                            ),
                            if (_searchQuery.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                l10n.homeTryAnotherSearch,
                                style: const TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 14,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }

                  // Apply sorting
                  if (_sortNewest) {
                    filteredScans.sort((a, b) => b.scanDate.compareTo(a.scanDate));
                  } else {
                    filteredScans.sort((a, b) => a.scanDate.compareTo(b.scanDate));
                  }

                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: _handleRefresh,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredScans.length,
                      itemBuilder: (context, index) {
                        final scan = filteredScans[index];
                        return ScanHistoryCard(
                          scan: scan,
                          onTap: () {
                            context.push(
                              RouteConstants.scanHistoryDetails,
                              extra: scan,
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAllConfirmation(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            l10n.historyDeleteAllConfirmTitle,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            l10n.historyDeleteAllConfirmMessage,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.cancel,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: AppColors.textGrey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<HistoryCubit>().clearAllHistory();
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.allScansDeleted,
                      style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                l10n.delete,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
