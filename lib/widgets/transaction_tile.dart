import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/constants/app_text_styles.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/date_formatter.dart';
import '../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final int index;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final cat = transaction.category;
    final isExpense = transaction.isExpense;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          onTap: () => _showTransactionDetail(context),
          splashColor: cat.color.withOpacity(0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm + 4,
            ),
            child: Row(
              children: [
                // Category icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: cat.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Icon(cat.icon, color: cat.color, size: 20),
                ),
                const SizedBox(width: AppSizes.md),

                // Title & subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        style: AppTextStyles.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        transaction.subtitle,
                        style: AppTextStyles.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Amount & date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isExpense ? '-' : '+'}${CurrencyFormatter.format(transaction.amount)}',
                      style: AppTextStyles.amountSmall.copyWith(
                        color: isExpense
                            ? AppColors.expense
                            : AppColors.income,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormatter.formatRelative(transaction.date),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 30 * (index % 20)))
        .fadeIn(duration: 350.ms)
        .slideX(begin: 0.05);
  }

  void _showTransactionDetail(BuildContext context) {
    final cat = transaction.category;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,

      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1E1D30),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: cat.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(cat.icon, color: cat.color, size: 32),
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(transaction.title,
                        style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 4),
                    Text(transaction.subtitle,
                        style: AppTextStyles.bodyMedium),
                    const SizedBox(height: AppSizes.lg),
                    Text(
                      '-${CurrencyFormatter.format(transaction.amount, showDecimal: true)}',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: AppColors.expense,
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    _DetailRow(
                        label: 'Category', value: cat.label),
                    _DetailRow(
                        label: 'Date',
                        value: DateFormatter.formatDate(transaction.date)),
                    _DetailRow(
                        label: 'Time',
                        value: DateFormatter.formatTime(transaction.date)),
                    const SizedBox(height: AppSizes.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textMuted)),
          Text(value, style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }
}
