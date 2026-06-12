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
            // Section header
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius:
                      BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list_rounded,
                            color: AppColors.textSecondary, size: 14),
                        const SizedBox(width: 4),
                        Text('Filter',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            )),
                      ],
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
}