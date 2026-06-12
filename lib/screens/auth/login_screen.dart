import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.account_balance_wallet_rounded,
                    color: Colors.white, size: 32),
              ).animate().scale(duration: 500.ms),
              const SizedBox(height: AppSizes.lg),
              Text('Welcome to\nSpendTrack',
                  style: AppTextStyles.displayMedium)
                  .animate()
                  .fadeIn(delay: 200.ms),
              const SizedBox(height: AppSizes.sm),
              Text('Track your finances smarter.',
                  style: AppTextStyles.bodyMedium)
                  .animate()
                  .fadeIn(delay: 300.ms),
              const Spacer(),
              CustomButton(
                label: 'Continue',
                onTap: () => Navigator.pushReplacementNamed(context, '/'),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
              const SizedBox(height: AppSizes.md),
            ],
          ),
        ),
      ),
    );
  }
}
