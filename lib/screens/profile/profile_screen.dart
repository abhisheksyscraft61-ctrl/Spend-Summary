import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/spend_provider.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final spend = context.watch<SpendProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Profile', style: AppTextStyles.headlineMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            // Avatar & name
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: AppSizes.md),
                  Text(user?.name ?? '', style: AppTextStyles.headlineLarge),
                  Text(user?.email ?? '', style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xl),

            // Stats
            Row(
              children: [
                _ProfileStatCard(
                  label: 'This Month',
                  value: CurrencyFormatter.formatCompact(
                      spend.currentMonthSpend),
                  icon: Icons.calendar_month_rounded,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSizes.sm),
                _ProfileStatCard(
                  label: 'Budget',
                  value: CurrencyFormatter.formatCompact(
                      user?.monthlyBudget ?? 0),
                  icon: Icons.savings_rounded,
                  color: AppColors.income,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),

            // Settings list
            _SettingsTile(
              icon: Icons.notifications_rounded,
              label: 'Notifications',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.security_rounded,
              label: 'Privacy & Security',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.help_outline_rounded,
              label: 'Help & Support',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.logout_rounded,
              label: 'Logout',
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ProfileStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.surfaceVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppSizes.sm),
            Text(value, style: AppTextStyles.amountSmall),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.expense : AppColors.textSecondary;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label,
            style: AppTextStyles.titleMedium.copyWith(
              color: isDestructive ? AppColors.expense : AppColors.textPrimary,
            )),
        trailing: Icon(Icons.chevron_right_rounded,
            color: AppColors.textMuted),
        onTap: onTap,
      ),
    );
  }
}
