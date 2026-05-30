import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../common/theme/app_theme.dart';
import 'summary_card.dart';
import 'summary_chart.dart';

class SummaryCarousel extends StatefulWidget {
  final double totalIncome;
  final double totalExpense;

  const SummaryCarousel({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  State<SummaryCarousel> createState() => _SummaryCarouselState();
}

class _SummaryCarouselState extends State<SummaryCarousel> {
  final PageController _ctrl = PageController();
  int _page = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ScrollConfiguration garante que o mouse também arrasta no web
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: SizedBox(
            height: 186,
            child: PageView(
              controller: _ctrl,
              onPageChanged: (i) => setState(() => _page = i),
              children: [
                SummaryCard(
                  totalIncome: widget.totalIncome,
                  totalExpense: widget.totalExpense,
                  balance: widget.totalIncome - widget.totalExpense,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SummaryChart(
                    totalIncome: widget.totalIncome,
                    totalExpense: widget.totalExpense,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Pontos indicadores clicáveis
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (i) {
            final active = _page == i;
            return GestureDetector(
              onTap: () => _ctrl.animateToPage(
                i,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 6,
                width: active ? 18 : 6,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : AppColors.textHint,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          _page == 0 ? 'Arraste para ver o gráfico →' : '← Arraste para voltar',
          style: const TextStyle(fontSize: 10, color: AppColors.textHint),
        ),
      ],
    );
  }
}
