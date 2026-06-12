import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/constants/app_text_styles.dart';
import '../core/utils/currency_formatter.dart';
import '../models/transaction_model.dart';
import '../providers/spend_provider.dart';

class CategoryScrollSection extends StatelessWidget {
  const CategoryScrollSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SpendProvider>();
    final categories = provider.categorySpends;
    final selected = provider.selectedCategory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Categories', style: AppTextStyles.headlineMedium),
              if (selected != null)
                GestureDetector(
                  onTap: () => provider.clearFilter(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusCircle),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.close_rounded,
                            color: AppColors.primary, size: 12),
                        const SizedBox(width: 4),
                        Text('Clear',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 115,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(
                left: AppSizes.md, right: AppSizes.sm),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = selected == cat.category;
              return _CategoryCard(
                catSpend: cat,
                isSelected: isSelected,
                onTap: () =>
                    provider.selectCategory(cat.category),
              )
                  .animate(delay: Duration(milliseconds: 60 * index))
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: 0.3);
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final dynamic catSpend;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.catSpend,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cat = catSpend.category as CategoryType;
    final color = cat.color;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 92,
        margin: const EdgeInsets.only(right: AppSizes.sm, bottom: 4, top: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.2)
              : AppColors.cardBg,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: isSelected
                ? color.withOpacity(0.8)
                : AppColors.surfaceVariant,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: AppSizes.sm, horizontal: AppSizes.xs),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withOpacity(0.3)
                      : color.withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Icon(cat.icon, color: color, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                cat.label,
                style: AppTextStyles.caption.copyWith(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                CurrencyFormatter.formatCompact(
                    catSpend.totalAmount as double),
                style: AppTextStyles.caption.copyWith(
                  color: isSelected ? color : AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
