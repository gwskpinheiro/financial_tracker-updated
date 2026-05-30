import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:financial_tracker/common/theme/app_theme.dart';
import '../../common/utils/formatter.dart';

class SummaryChart extends StatefulWidget {
  final double totalIncome;
  final double totalExpense;

  const SummaryChart({super.key, required this.totalIncome, required this.totalExpense});

  @override
  State<SummaryChart> createState() => _SummaryChartState();
}

class _SummaryChartState extends State<SummaryChart> {
  int _touched = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.totalIncome + widget.totalExpense;
    final isEmpty = total == 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pie_chart_outline_rounded,
                      size: 36, color: AppColors.textHint),
                  SizedBox(height: 8),
                  Text('Sem dados ainda',
                      style: TextStyle(color: AppColors.textHint, fontSize: 12)),
                ],
              ),
            )
          : Row(
              children: [
                Expanded(
                  flex: 3,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 26,
                      pieTouchData: PieTouchData(
                        touchCallback: (_, r) => setState(() {
                          _touched = r?.touchedSection?.touchedSectionIndex ?? -1;
                        }),
                      ),
                      sections: [
                        PieChartSectionData(
                          value: widget.totalIncome,
                          color: AppColors.income,
                          radius: _touched == 0 ? 55 : 48,
                          title: '',
                        ),
                        PieChartSectionData(
                          value: widget.totalExpense,
                          color: AppColors.expense,
                          radius: _touched == 1 ? 55 : 48,
                          title: '',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _legend('Receitas', AppColors.income, widget.totalIncome, total),
                      const SizedBox(height: 14),
                      _legend('Despesas', AppColors.expense, widget.totalExpense, total),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _legend(String label, Color color, double amount, double total) {
    final pct = total > 0 ? (amount / total * 100).toStringAsFixed(0) : '0';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                width: 10, height: 10,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(3))),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            const Spacer(),
            Text('$pct%',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(Formatter.formatCurrency(amount),
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ),
      ],
    );
  }
}
