import 'package:financial_tracker/common/config/dependencies.dart';
import 'package:financial_tracker/common/theme/app_theme.dart';
import 'package:financial_tracker/common/types/date_filter_type.dart';
import 'package:financial_tracker/domain/entity/transaction_entity.dart';
import 'package:financial_tracker/ui/controller/home_page_controller.dart';
import 'package:financial_tracker/ui/widget/date_filter_transactions.dart';
import 'package:financial_tracker/ui/widget/summary_carousel.dart';
import 'package:financial_tracker/ui/widget/transaction_sheet.dart';
import 'package:financial_tracker/ui/widget/transaction_sheets_card.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomePageController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = injector.get<HomePageController>();
    ctrl.load.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Controle Financeiro'),
        actions: [
          Watch((context) {
            final running = ctrl.load.runningSignal.value;
            return IconButton(
              tooltip: 'Recarregar',
              onPressed: running ? null : () => ctrl.load.execute(),
              icon: running
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(AppColors.textPrimary),
                      ),
                    )
                  : const Icon(Icons.refresh_rounded),
            );
          }),
          Watch((context) {
            final visible = ctrl.isFilterVisible.value;
            return IconButton(
              tooltip: 'Filtrar por data',
              onPressed: ctrl.toggleFilterVisibility,
              icon: Icon(visible
                  ? Icons.filter_list_off_rounded
                  : Icons.filter_list_rounded),
            );
          }),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Carousel (saldo + gráfico)
          Watch((context) => SummaryCarousel(
                totalIncome: ctrl.totalIncome.value,
                totalExpense: ctrl.totalExpense.value,
              )),

          const SizedBox(height: 16),

          // Filtro de data colapsável
          Watch((context) {
            if (!ctrl.isFilterVisible.value) return const SizedBox.shrink();
            return AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: DateFilterTransactions(
                filtro: (
                  type: ctrl.filterType,
                  startDate: ctrl.startDate,
                  endDate: ctrl.endDate,
                ),
                onFilterChanged: (s, e) =>
                    ctrl.searchTransactionsByDate.execute(s!, e!),
                onUpdateFilter: ctrl.setFiltersParams,
                onAllTransactionsFiltered: () => ctrl.load.execute(),
                onTapHideFilter: ctrl.toggleFilterVisibility,
              ),
            );
          }),

          // Botões
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              children: [
                Expanded(
                  child: _addButton('Receita', Icons.add_rounded,
                      AppColors.income, () => _openSheet(TransactionType.income)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _addButton('Despesa', Icons.remove_rounded,
                      AppColors.expense, () => _openSheet(TransactionType.expense)),
                ),
              ],
            ),
          ),

          // Header da seção
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
            child: Row(
              children: [
                const Text('Transações',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const Spacer(),
                Watch((context) {
                  final n = ctrl.incomes.value.length + ctrl.expenses.value.length;
                  return Text('$n registros',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary));
                }),
              ],
            ),
          ),

          // Lista
          Expanded(
            child: Watch((context) => TransactionCardSheets(
                  incomeTransactions: ctrl.incomes.value,
                  expenseTransactions: ctrl.expenses.value,
                  onDelete: (id) => ctrl.deleteTransaction.execute(id),
                  undoDelete: ctrl.undoDelectedTransaction,
                  onEdit: ctrl.editTransaction,
                  scaffoldContext: context,
                )),
          ),
        ],
      ),
    );
  }

  Widget _addButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 15, color: Colors.white),
      label: Text('Adicionar $label',
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
    );
  }

  void _openSheet(TransactionType type) {
    TransactionSheet.show(
      context: context,
      type: type,
      submitCommand: ctrl.saveTransaction,
    );
  }
}
