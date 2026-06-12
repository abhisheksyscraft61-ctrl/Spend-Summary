import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/constants/app_text_styles.dart';
import '../models/transaction_model.dart';
import '../providers/spend_provider.dart';
import 'transaction_tile.dart';

class TransactionListSection extends StatelessWidget {
  const TransactionListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SpendProvider>();
    final transactions = provider.filteredTransactions;
    final selected = provider.selectedCategory;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selected != null
                              ? '${selected.label} Transactions'
                              : 'Recent Transactions',
                          style: AppTextStyles.headlineMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${transactions.length} transactions',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  // ── WORKING FILTER BUTTON ──
                  GestureDetector(
                    onTap: () => _showFilterSheet(context, provider),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: provider.hasActiveFilter
                            ? AppColors.primary.withOpacity(0.15)
                            : AppColors.surfaceVariant,
                        borderRadius:
                        BorderRadius.circular(AppSizes.radiusSm),
                        border: provider.hasActiveFilter
                            ? Border.all(
                            color: AppColors.primary.withOpacity(0.4))
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            provider.hasActiveFilter
                                ? Icons.filter_list_rounded
                                : Icons.filter_list_rounded,
                            color: provider.hasActiveFilter
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            provider.hasActiveFilter ? 'Filtered' : 'Filter',
                            style: AppTextStyles.caption.copyWith(
                              color: provider.hasActiveFilter
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontWeight: provider.hasActiveFilter
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          if (provider.hasActiveFilter) ...[
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => provider.clearFilter(),
                              child: Icon(Icons.close_rounded,
                                  size: 12, color: AppColors.primary),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (transactions.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(AppSizes.xxl),
              child: Column(
                children: [
                  Icon(Icons.receipt_long_outlined,
                      color: AppColors.textMuted, size: 48),
                  const SizedBox(height: AppSizes.md),
                  Text('No transactions found',
                      style: AppTextStyles.bodyMedium),
                ],
              ),
            );
          }

          final txIndex = index - 1;
          if (txIndex >= transactions.length) return null;

          return TransactionTile(
            transaction: transactions[txIndex],
            index: txIndex,
          );
        },
        childCount: transactions.isEmpty ? 2 : transactions.length + 1,
      ),
    );
  }

  // ── Filter Bottom Sheet ──────────────────────────────────────────────────
  void _showFilterSheet(BuildContext context, SpendProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(provider: provider),
    );
  }
}

// ── Filter Sheet Widget ────────────────────────────────────────────────────
class _FilterSheet extends StatefulWidget {
  final SpendProvider provider;
  const _FilterSheet({required this.provider});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String _selectedSort;
  late String _selectedType;
  DateTimeRange? _selectedRange;

  final List<_SortOption> _sortOptions = const [
    _SortOption('Latest First', 'latest'),
    _SortOption('Oldest First', 'oldest'),
    _SortOption('Highest Amount', 'highest'),
    _SortOption('Lowest Amount', 'lowest'),
  ];

  final List<_SortOption> _typeOptions = const [
    _SortOption('All', 'all'),
    _SortOption('Expense', 'expense'),
    _SortOption('Income', 'income'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.provider.activeSort;
    _selectedType = widget.provider.activeType;
    _selectedRange = widget.provider.activeDateRange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          AppSizes.lg,
          AppSizes.md,
          AppSizes.lg,
          MediaQuery.of(context).viewInsets.bottom + AppSizes.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.md),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filter Transactions',
                  style: AppTextStyles.headlineMedium),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedSort = 'latest';
                    _selectedType = 'all';
                    _selectedRange = null;
                  });
                },
                child: Text('Reset',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.expense)),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          // Sort by
          Text('Sort By', style: AppTextStyles.titleMedium),
          const SizedBox(height: AppSizes.sm),
          Wrap(
            spacing: AppSizes.sm,
            children: _sortOptions.map((opt) {
              final isSelected = _selectedSort == opt.value;
              return ChoiceChip(
                label: Text(opt.label),
                selected: isSelected,
                onSelected: (_) =>
                    setState(() => _selectedSort = opt.value),
                selectedColor: AppColors.primary.withOpacity(0.15),
                labelStyle: AppTextStyles.caption.copyWith(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(AppSizes.radiusSm),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.4)
                        : AppColors.surfaceVariant,
                  ),
                ),
                backgroundColor: AppColors.cardBg,
                showCheckmark: false,
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.md),

          // Type
          Text('Type', style: AppTextStyles.titleMedium),
          const SizedBox(height: AppSizes.sm),
          Wrap(
            spacing: AppSizes.sm,
            children: _typeOptions.map((opt) {
              final isSelected = _selectedType == opt.value;
              return ChoiceChip(
                label: Text(opt.label),
                selected: isSelected,
                onSelected: (_) =>
                    setState(() => _selectedType = opt.value),
                selectedColor: AppColors.primary.withOpacity(0.15),
                labelStyle: AppTextStyles.caption.copyWith(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(AppSizes.radiusSm),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.4)
                        : AppColors.surfaceVariant,
                  ),
                ),
                backgroundColor: AppColors.cardBg,
                showCheckmark: false,
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.md),

          // Date range
          Text('Date Range', style: AppTextStyles.titleMedium),
          const SizedBox(height: AppSizes.sm),
          GestureDetector(
            onTap: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: _selectedRange,
                saveText: 'DONE',
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primary,
                      onPrimary: Colors.white,
                      onSurface: Colors.black87,        // date text visible
                      surface: Colors.white,            // background white
                      secondaryContainer: AppColors.primary.withOpacity(0.15),
                      onSecondaryContainer: AppColors.primary,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary, // CANCEL & DONE visible
                      ),
                    ),
                    dialogTheme: const DialogThemeData(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (range != null) setState(() => _selectedRange = range);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md, vertical: AppSizes.sm + 2),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(
                  color: _selectedRange != null
                      ? AppColors.primary.withOpacity(0.4)
                      : AppColors.surfaceVariant,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.date_range_rounded,
                      color: _selectedRange != null
                          ? AppColors.primary
                          : AppColors.textMuted,
                      size: 18),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      _selectedRange != null
                          ? '${_fmt(_selectedRange!.start)}  →  ${_fmt(_selectedRange!.end)}'
                          : 'Select date range',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _selectedRange != null
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                  if (_selectedRange != null)
                    GestureDetector(
                      onTap: () => setState(() => _selectedRange = null),
                      child: Icon(Icons.close_rounded,
                          size: 16, color: AppColors.textMuted),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.lg),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.provider.applyFilter(
                  sort: _selectedSort,
                  type: _selectedType,
                  dateRange: _selectedRange,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(vertical: AppSizes.md),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(AppSizes.radiusMd),
                ),
                elevation: 0,
              ),
              child: Text('Apply Filter',
                  style: AppTextStyles.labelLarge
                      .copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  static const _months = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'
  ];
}

class _SortOption {
  final String label;
  final String value;
  const _SortOption(this.label, this.value);
}