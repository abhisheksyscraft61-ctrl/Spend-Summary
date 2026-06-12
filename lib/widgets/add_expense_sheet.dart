import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/constants/app_text_styles.dart';
import '../models/transaction_model.dart';

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  CategoryType _selectedCat = CategoryType.food;

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1928),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: AppSizes.lg,
        right: AppSizes.lg,
        top: AppSizes.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Text('Add Expense', style: AppTextStyles.headlineLarge),
            const SizedBox(height: AppSizes.lg),
        
            // Amount field
            _buildLabel('Amount (₹)'),
            const SizedBox(height: AppSizes.xs),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTextStyles.displayMedium.copyWith(fontSize: 28),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: AppTextStyles.displayMedium.copyWith(
                    fontSize: 28, color: AppColors.textMuted),
                prefixText: '₹ ',
                prefixStyle: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.primary),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
        
            const SizedBox(height: AppSizes.md),
        
            // Title field
            _buildLabel('Title'),
            const SizedBox(height: AppSizes.xs),
            TextField(
              controller: _titleController,
              style: AppTextStyles.bodyLarge,
              decoration: InputDecoration(
                hintText: 'e.g. Swiggy Order',
                hintStyle: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
        
            const SizedBox(height: AppSizes.md),
        
            // Category
            _buildLabel('Category'),
            const SizedBox(height: AppSizes.sm),
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: CategoryType.values.map((cat) {
                  final isSelected = _selectedCat == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCat = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: AppSizes.sm),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm + 4, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cat.color.withOpacity(0.2)
                            : AppColors.surfaceVariant,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusCircle),
                        border: Border.all(
                          color: isSelected
                              ? cat.color
                              : AppColors.surfaceVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(cat.icon,
                              color: isSelected
                                  ? cat.color
                                  : AppColors.textMuted,
                              size: 14),
                          const SizedBox(width: 4),
                          Text(
                            cat.label,
                            style: AppTextStyles.caption.copyWith(
                              color: isSelected
                                  ? cat.color
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        
            const SizedBox(height: AppSizes.xl),
        
            // Save button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Expense added! (mock)',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: Colors.white),
                      ),
                      backgroundColor: AppColors.income,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusMd),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
                child: Text('Save Expense',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                      fontSize: 15,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style:
          AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
    );
  }
}
