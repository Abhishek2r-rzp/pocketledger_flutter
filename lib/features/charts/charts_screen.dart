import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pocketledger/features/charts/charts_provider.dart';
import 'package:pocketledger/core/data_repository.dart';

class ChartsScreen extends ConsumerWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(chartsDataProvider);
    final segment = ref.watch(chartsSegmentProvider);
    final categories = ref.watch(dataRepositoryProvider).categories;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (charts) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'overview', label: Text('Overview')),
                  ButtonSegment(value: 'categories', label: Text('Categories')),
                  ButtonSegment(value: 'trends', label: Text('Trends')),
                ],
                selected: {segment},
                onSelectionChanged: (s) => ref.read(chartsSegmentProvider.notifier).state = s.first,
              ),
              const SizedBox(height: 16),
              if (segment == 'overview' || segment == 'all') ...[
                _ChartCard(
                  title: 'Monthly Income vs Expenses',
                  theme: theme,
                  child: SizedBox(
                    height: 220,
                    child: _buildIncomeExpenseChart(charts.monthlyIncomeExpense, theme),
                  ),
                ),
                const SizedBox(height: 12),
                _ChartCard(
                  title: 'Savings Rate Trend',
                  theme: theme,
                  child: SizedBox(
                    height: 220,
                    child: _buildSavingsRateChart(charts.savingsRateTrend, theme),
                  ),
                ),
              ],
              if (segment == 'categories' || segment == 'all') ...[
                _ChartCard(
                  title: 'Category Spend',
                  theme: theme,
                  child: SizedBox(
                    height: 260,
                    child: _buildCategoryPieChart(charts.categorySpend, categories, theme),
                  ),
                ),
                const SizedBox(height: 12),
                _ChartCard(
                  title: 'Top Merchants',
                  theme: theme,
                  child: SizedBox(
                    height: 220,
                    child: _buildMerchantBarChart(charts.topMerchants, theme),
                  ),
                ),
              ],
              if (segment == 'trends' || segment == 'all') ...[
                _ChartCard(
                  title: 'Daily Spending (Last 30 days)',
                  theme: theme,
                  child: SizedBox(
                    height: 220,
                    child: _buildDailySpendingChart(charts.dailySpending, theme),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIncomeExpenseChart(List<({int month, double income, double expense})> data, ThemeData theme) {
    if (data.isEmpty) return Center(child: Text('No data', style: theme.textTheme.bodyMedium));

    final maxVal = data.fold<double>(0, (m, d) => [m, d.income, d.expense].reduce((a, b) => a > b ? a : b)) * 1.2;
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxVal,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final idx = value.toInt();
                if (idx < 0 || idx >= data.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(months[data[idx].month - 1], style: const TextStyle(fontSize: 9)),
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
              BarChartRodData(toY: data[i].income, color: const Color(0xFF4CAF50), width: 8, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
              BarChartRodData(toY: data[i].expense, color: const Color(0xFFF44336), width: 8, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCategoryPieChart(List<({String categoryId, double amount})> data, List<dynamic> categories, ThemeData theme) {
    if (data.isEmpty) return Center(child: Text('No data', style: theme.textTheme.bodyMedium));

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: data.map((d) {
                final cat = categories.where((c) => c.id == d.categoryId).firstOrNull;
                final color = Color(cat?.colorValue ?? 0xFF9E9E9E);
                return PieChartSectionData(
                  value: d.amount,
                  color: color,
                  radius: 50,
                  titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.take(6).map((d) {
              final cat = categories.where((c) => c.id == d.categoryId).firstOrNull;
              final color = Color(cat?.colorValue ?? 0xFF9E9E9E);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Expanded(child: Text(cat?.name ?? 'Unknown', style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDailySpendingChart(List<({DateTime date, double amount})> data, ThemeData theme) {
    if (data.isEmpty) return Center(child: Text('No data', style: theme.textTheme.bodyMedium));

    final maxVal = data.fold<double>(0, (m, d) => d.amount > m ? d.amount : m) * 1.2;

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxVal,
        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: maxVal / 4),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5,
              getTitlesWidget: (value, _) {
                final idx = value.toInt();
                if (idx < 0 || idx >= data.length) return const SizedBox();
                return Text('${data[idx].date.day}', style: const TextStyle(fontSize: 9));
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i].amount)),
            isCurved: true,
            color: theme.colorScheme.primary,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: theme.colorScheme.primary.withOpacity(0.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantBarChart(List<({String name, double amount})> data, ThemeData theme) {
    if (data.isEmpty) return Center(child: Text('No data', style: theme.textTheme.bodyMedium));

    final maxVal = data.fold<double>(0, (m, d) => d.amount > m ? d.amount : m) * 1.2;
    final displayData = data.take(6).toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxVal,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final idx = value.toInt();
                if (idx < 0 || idx >= displayData.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    displayData[idx].name.length > 6
                        ? '${displayData[idx].name.substring(0, 6)}...'
                        : displayData[idx].name,
                    style: const TextStyle(fontSize: 9),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(displayData.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(toY: displayData[i].amount, color: theme.colorScheme.secondary, width: 12, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSavingsRateChart(List<({int month, double rate})> data, ThemeData theme) {
    if (data.isEmpty) return Center(child: Text('No data', style: theme.textTheme.bodyMedium));

    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return LineChart(
      LineChartData(
        minY: -20,
        maxY: 100,
        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 20),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final idx = value.toInt();
                if (idx < 0 || idx >= data.length) return const SizedBox();
                return Text(months[data[idx].month - 1], style: const TextStyle(fontSize: 9));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, _) => Text('${value.toInt()}%', style: const TextStyle(fontSize: 9)),
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i].rate)),
            isCurved: true,
            color: const Color(0xFF9C27B0),
            barWidth: 2.5,
            dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 3,
                color: const Color(0xFF9C27B0),
                strokeWidth: 0,
              );
            }),
            belowBarData: BarAreaData(show: true, color: const Color(0xFF9C27B0).withOpacity(0.1)),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  final ThemeData theme;

  const _ChartCard({required this.title, required this.child, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
