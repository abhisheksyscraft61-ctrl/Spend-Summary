import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/constants/app_text_styles.dart';
import '../core/utils/currency_formatter.dart';
import '../providers/spend_provider.dart';
import '../providers/user_provider.dart';

class SpendHeaderCard extends StatelessWidget {
  const SpendHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final spendProvider = context.watch<SpendProvider>();
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    final percent = spendProvider.percentChange;
    final isUp = spendProvider.isIncreased;

    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSizes.md, AppSizes.md, AppSizes.md, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        gradient: const LinearGradient(
          colors: [Color(0xFF3D2C8D), Color(0xFF6C5CE7), Color(0xFF00B4D8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${user?.firstName ?? 'User'} 👋',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'June 2025',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    _BudgetBadge(
                      spent: spendProvider.currentMonthSpend,
                      budget: user?.monthlyBudget ?? 80000,
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.lg),

                // Main amount
                Text(
                  'Total Spent',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white54,
                    letterSpacing: 1.2,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(spendProvider.currentMonthSpend),
                  style: AppTextStyles.amount.copyWith(
                    color: Colors.white,
                    fontSize: 38,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

                const SizedBox(height: AppSizes.md),

                // Bottom row
                Row(
                  children: [
                    _ChangeChip(percent: percent, isUp: isUp),
                    const SizedBox(width: AppSizes.sm),
                    Text(
                      'vs last month (${CurrencyFormatter.formatCompact(spendProvider.lastMonthSpend)})',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1);
  }
}

class _ChangeChip extends StatelessWidget {
  final double percent;
  final bool isUp;

  const _ChangeChip({required this.percent, required this.isUp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isUp
            ? AppColors.expense.withOpacity(0.2)
            : AppColors.income.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusCircle),
        border: Border.all(
          color: isUp
              ? AppColors.expense.withOpacity(0.4)
              : AppColors.income.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            color: isUp ? AppColors.expense : AppColors.income,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '${percent.abs().toStringAsFixed(1)}%',
            style: AppTextStyles.caption.copyWith(
              color: isUp ? AppColors.expense : AppColors.income,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetBadge extends StatelessWidget {
  final double spent;
  final double budget;

  const _BudgetBadge({required this.spent, required this.budget});

  @override
  Widget build(BuildContext context) {
    final progress = (spent / budget).clamp(0.0, 1.0);
    final isOverBudget = spent > budget;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Budget',
          style: AppTextStyles.caption.copyWith(color: Colors.white54),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget ? AppColors.expense : AppColors.income,
              ),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(progress * 100).toInt()}% used',
          style: AppTextStyles.caption.copyWith(
            color: isOverBudget ? AppColors.expense : Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
