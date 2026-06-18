import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pocketledger/core/models/transaction.dart';
import 'package:pocketledger/core/models/category.dart';
import 'package:pocketledger/features/dashboard/dashboard_provider.dart';
import 'package:pocketledger/core/theme/app_colors.dart';
import 'package:pocketledger/core/theme/glass_card.dart';
import 'package:pocketledger/core/theme/premium_shimmer.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardDataProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Overview',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.cardGlass,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardGlassBorder, width: 0.5),
                ),
                child: const Icon(Icons.tune_rounded, size: 18),
              ),
              onPressed: () {},
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.cardGlass,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardGlassBorder, width: 0.5),
                ),
                child: const Icon(Icons.settings, size: 18),
              ),
              onPressed: () => context.push('/settings'),
            ),
          ),
        ],
      ),
      body: data.when(
        loading: () => const _DashboardShimmer(),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: AppColors.textSecondary)),
        ),
        data: (dashboard) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(dashboardDataProvider.future),
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 80, 16, 100),
              children: [
                _BalanceHeader(
                  income: dashboard.totalIncome,
                  expenses: dashboard.totalExpenses,
                  savings: dashboard.savings,
                  savingsRate: dashboard.savingsRate,
                ).animate().fadeIn(duration: 400.ms, curve: Curves.easeOutCubic).slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                _IncomeExpenseRow(
                  income: dashboard.totalIncome,
                  expenses: dashboard.totalExpenses,
                ).animate().fadeIn(duration: 400.ms, delay: 80.ms, curve: Curves.easeOutCubic).slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 80.ms, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                _MonthlyChartCard(data: dashboard.monthlyData).animate().fadeIn(duration: 400.ms, delay: 160.ms, curve: Curves.easeOutCubic).slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 160.ms, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                _CategoryCard(
                  data: dashboard.categoryTotals,
                  categories: dashboard.categories,
                ).animate().fadeIn(duration: 400.ms, delay: 240.ms, curve: Curves.easeOutCubic).slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 240.ms, curve: Curves.easeOutCubic),
                const SizedBox(height: 12),
                _QuickActionsGrid(context: context).animate().fadeIn(duration: 400.ms, delay: 320.ms, curve: Curves.easeOutCubic).slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 320.ms, curve: Curves.easeOutCubic),
                if (dashboard.needsReviewCount > 0) ...[
                  const SizedBox(height: 12),
                  _ReviewBadge(count: dashboard.needsReviewCount, onTap: () => context.push('/review')).animate().fadeIn(duration: 400.ms, delay: 400.ms, curve: Curves.easeOutCubic),
                ],
                if (dashboard.insights.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _SectionHeader(title: 'Insights'),
                  const SizedBox(height: 8),
                  ...dashboard.insights.map((i) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _InsightCard(insight: i).animate().fadeIn(duration: 300.ms, curve: Curves.easeOutCubic).slideY(begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOutCubic),
                  )),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/import'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _DashboardShimmer extends StatelessWidget {
  const _DashboardShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 80, 16, 100),
      children: const [
        ShimmerCard(),
        SizedBox(height: 12),
        ShimmerCard(),
        SizedBox(height: 12),
        ShimmerCard(),
        SizedBox(height: 12),
        ShimmerCard(),
      ],
    );
  }
}

class _BalanceHeader extends StatelessWidget {
  final double income;
  final double expenses;
  final double savings;
  final double savingsRate;

  const _BalanceHeader({
    required this.income,
    required this.expenses,
    required this.savings,
    required this.savingsRate,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard.premium(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Total Balance',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${_formatAmount(savings)}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: savings >= 0
                      ? AppColors.income.withOpacity(0.15)
                      : AppColors.expense.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      savings >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                      size: 14,
                      color: savings >= 0 ? AppColors.income : AppColors.expense,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${savingsRate.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: savings >= 0 ? AppColors.income : AppColors.expense,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${savings >= 0 ? 'Saved' : 'Overspent'} ₹${_formatAmount(savings.abs())} this month',
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) return '${(amount / 10000000).toStringAsFixed(1)}Cr';
    if (amount >= 100000) return '${(amount / 100000).toStringAsFixed(1)}L';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }
}

class _IncomeExpenseRow extends StatelessWidget {
  final double income;
  final double expenses;

  const _IncomeExpenseRow({required this.income, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GlassCard.premium(
            padding: const EdgeInsets.all(16),
            borderRadius: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.income.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.trending_down_rounded, size: 18, color: AppColors.income),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.income.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_upward_rounded, size: 10, color: AppColors.income),
                          SizedBox(width: 2),
                          Text('12%', style: TextStyle(fontSize: 10, color: AppColors.income, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '₹${_formatAmount(income)}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Income',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GlassCard.premium(
            padding: const EdgeInsets.all(16),
            borderRadius: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.expense.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.trending_up_rounded, size: 18, color: AppColors.expense),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.expense.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_downward_rounded, size: 10, color: AppColors.expense),
                          SizedBox(width: 2),
                          Text('8%', style: TextStyle(fontSize: 10, color: AppColors.expense, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '₹${_formatAmount(expenses)}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Expenses',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) return '${(amount / 10000000).toStringAsFixed(1)}Cr';
    if (amount >= 100000) return '${(amount / 100000).toStringAsFixed(1)}L';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }
}

class _MonthlyChartCard extends StatelessWidget {
  final List<({int month, double income, double expense})> data;

  const _MonthlyChartCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return GlassCard.premium(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Monthly Spend',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              _ChartLegend(color: AppColors.income, label: 'Income'),
              const SizedBox(width: 12),
              _ChartLegend(color: AppColors.expense, label: 'Expenses'),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: data.isEmpty
                ? const Center(child: Text('No data', style: TextStyle(color: AppColors.textTertiary)))
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _maxValue * 1.3,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '₹${rod.toY.toStringAsFixed(0)}',
                              const TextStyle(color: Colors.white, fontSize: 12),
                            );
                          },
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: _maxValue / 4,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.white.withOpacity(0.03),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= data.length) return const SizedBox();
                              final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                              return Text(
                                months[data[idx].month - 1].substring(0, 3),
                                style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(data.length, (i) {
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: data[i].income,
                              color: AppColors.income,
                              width: 8,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                            BarChartRodData(
                              toY: data[i].expense,
                              color: AppColors.expense,
                              width: 8,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  double get _maxValue {
    double max = 0;
    for (final d in data) {
      if (d.income > max) max = d.income;
      if (d.expense > max) max = d.expense;
    }
    return max > 0 ? max : 1000;
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final List<({String categoryId, double amount})> data;
  final List<Category> categories;

  const _CategoryCard({required this.data, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GlassCard.premium(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Top Categories',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              Text(
                '${data.length} categories',
                style: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (data.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('No spending data', style: TextStyle(color: AppColors.textTertiary)),
              ),
            )
          else
            ...data.take(5).map((d) {
              final cat = categories.where((c) => c.id == d.categoryId).firstOrNull;
              final color = Color(cat?.colorValue ?? 0xFF9E9E9E);
              final total = data.fold<double>(0, (s, i) => s + i.amount);
              final pct = total > 0 ? (d.amount / total) * 100 : 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _categoryIcon(cat?.name ?? ''),
                        size: 18,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat?.name ?? 'Unknown',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: pct / 100,
                              backgroundColor: Colors.white.withOpacity(0.06),
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                              minHeight: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${d.amount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${pct.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  IconData _categoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'food & dining':
      case 'food':
        return Icons.restaurant_rounded;
      case 'transportation':
      case 'transport':
        return Icons.directions_car_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'entertainment':
        return Icons.movie_rounded;
      case 'bills & utilities':
      case 'utilities':
        return Icons.electrical_services_rounded;
      case 'healthcare':
      case 'health':
        return Icons.health_and_safety_rounded;
      case 'education':
        return Icons.school_rounded;
      case 'salary':
      case 'income':
        return Icons.account_balance_rounded;
      default:
        return Icons.circle_rounded;
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _ReviewBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _ReviewBadge({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      border: Border.all(color: AppColors.warning.withOpacity(0.2), width: 0.5),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.rate_review_rounded, size: 18, color: AppColors.warning),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$count transaction${count == 1 ? '' : 's'} need review',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final ({String icon, String title, String description}) insight;

  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;
    switch (insight.icon) {
      case 'warning':
        iconData = Icons.warning_amber_rounded;
        iconColor = AppColors.warning;
      case 'trending_up':
        iconData = Icons.trending_up_rounded;
        iconColor = AppColors.primary;
      case 'receipt':
        iconData = Icons.receipt_rounded;
        iconColor = AppColors.info;
      case 'info':
      default:
        iconData = Icons.lightbulb_outline_rounded;
        iconColor = AppColors.info;
    }

    return GlassCard.premium(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconData, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final BuildContext context;

  const _QuickActionsGrid({required this.context});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(Icons.list_alt_rounded, 'Transactions', AppColors.primary, () => context.push('/transactions')),
      _QuickAction(Icons.search_rounded, 'Search', AppColors.primary, () => context.push('/search')),
      _QuickAction(Icons.account_balance_rounded, 'Accounts', AppColors.accent, () => context.push('/accounts')),
      _QuickAction(Icons.label_rounded, 'Labels', AppColors.info, () => context.push('/labels')),
      _QuickAction(Icons.pie_chart_rounded, 'Analytics', AppColors.accent, () => context.push('/charts')),
      _QuickAction(Icons.account_balance_wallet_rounded, 'Budgets', AppColors.warning, () => context.push('/budgets')),
      _QuickAction(Icons.repeat_rounded, 'Recurring', AppColors.info, () => context.push('/recurring')),
      _QuickAction(Icons.history_rounded, 'History', AppColors.income, () => context.push('/import-history')),
      _QuickAction(Icons.rate_review_rounded, 'Review', AppColors.expense, () => context.push('/review')),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return GlassCardSmall(
              accentColor: action.color,
              onTap: action.onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: action.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(action.icon, size: 20, color: action.color),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action.label,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _QuickAction(this.icon, this.label, this.color, this.onTap);
}
