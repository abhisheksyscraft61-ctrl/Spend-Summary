import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/spend_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/add_expense_sheet.dart';
import '../../widgets/category_scroll_section.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/spend_header_card.dart';
import '../../widgets/transaction_list_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpendProvider>().loadData();
      context.read<UserProvider>().loadUser();
    });
  }

  void _openAddExpense() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddExpenseSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<SpendProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      floatingActionButton: _buildFAB(),
      body: isLoading
          ? const SafeArea(child: LoadingWidget())
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top padding for AppBar
                const SliverToBoxAdapter(
                  child: SizedBox(height: 90),
                ),

                // Header spend card
                const SliverToBoxAdapter(
                  child: SpendHeaderCard(),
                ),

                // Spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSizes.md),
                ),

                // Spend sparkline row
                SliverToBoxAdapter(
                  child: _SpendStatsRow()
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSizes.sm),
                ),

                // Category scroll
                const SliverToBoxAdapter(
                  child: CategoryScrollSection(),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSizes.sm),
                ),

                // Transactions
                const TransactionListSection(),

                // Bottom padding for FAB
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background.withOpacity(0.85),
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: const ColorFilter.mode(Colors.transparent, BlendMode.srcOver),
          child: Container(color: Colors.transparent),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.account_balance_wallet_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: AppSizes.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SpendTrack',
                  style: AppTextStyles.titleLarge.copyWith(fontSize: 16)),
              Text('June 2025',
                  style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined,
              color: AppColors.textSecondary),
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppSizes.sm),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: const Icon(Icons.person_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: _openAddExpense,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 8,
      icon: const Icon(Icons.add_rounded),
      label: Text('Add Expense',
          style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusCircle),
      ),
    )
        .animate()
        .fadeIn(delay: 600.ms, duration: 400.ms)
        .slideY(begin: 0.5);
  }
}

class _SpendStatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Avg Daily',
              value: '₹2,082',
              icon: Icons.today_rounded,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: _StatCard(
              label: 'Largest',
              value: '₹18,000',
              icon: Icons.arrow_upward_rounded,
              color: AppColors.expense,
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: _StatCard(
              label: 'Transactions',
              value: '57',
              icon: Icons.receipt_rounded,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.sm, vertical: AppSizes.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    )),
                Text(label, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
