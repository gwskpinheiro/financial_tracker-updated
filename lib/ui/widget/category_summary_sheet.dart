import 'package:financial_tracker/common/theme/app_theme.dart';
import 'package:financial_tracker/common/utils/formatter.dart';
import 'package:financial_tracker/domain/entity/transaction_entity.dart';
import 'package:flutter/material.dart';

/// Tela de resumo de gastos por categoria
class CategorySummarySheet extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const CategorySummarySheet({super.key, required this.transactions});

  static Future<void> show({
    required BuildContext context,
    required List<TransactionEntity> transactions,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => CategorySummarySheet(transactions: transactions),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Separa despesas e receitas
    final expenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .toList();
    final incomes = transactions
        .where((t) => t.type == TransactionType.income)
        .toList();

    // Agrupa despesas por categoria e soma os valores
    final Map<TransactionCategory, double> expenseByCategory = {};
    for (final t in expenses) {
      expenseByCategory[t.category] =
          (expenseByCategory[t.category] ?? 0) + t.amount;
    }

    // Agrupa receitas por categoria e soma os valores
    final Map<TransactionCategory, double> incomeByCategory = {};
    for (final t in incomes) {
      incomeByCategory[t.category] =
          (incomeByCategory[t.category] ?? 0) + t.amount;
    }

    // Ordena do maior para o menor valor
    final sortedExpenses = expenseByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final sortedIncomes = incomeByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final totalExpense =
        expenses.fold(0.0, (sum, t) => sum + t.amount);
    final totalIncome =
        incomes.fold(0.0, (sum, t) => sum + t.amount);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Título
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.pie_chart_rounded,
                      color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Resumo por Categoria',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.divider),

          // Conteúdo com scroll
          Expanded(
            child: transactions.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined,
                            size: 48, color: AppColors.textHint),
                        SizedBox(height: 12),
                        Text('Nenhuma transação ainda',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14)),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // ── Seção Despesas ──────────────────────────
                      if (sortedExpenses.isNotEmpty) ...[
                        _sectionHeader(
                            'Despesas por Categoria', AppColors.expense),
                        const SizedBox(height: 10),
                        ...sortedExpenses.map((entry) => _categoryTile(
                              category: entry.key,
                              amount: entry.value,
                              total: totalExpense,
                              isExpense: true,
                            )),
                        const SizedBox(height: 20),
                      ],

                      // ── Seção Receitas ──────────────────────────
                      if (sortedIncomes.isNotEmpty) ...[
                        _sectionHeader(
                            'Receitas por Categoria', AppColors.income),
                        const SizedBox(height: 10),
                        ...sortedIncomes.map((entry) => _categoryTile(
                              category: entry.key,
                              amount: entry.value,
                              total: totalIncome,
                              isExpense: false,
                            )),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _categoryTile({
    required TransactionCategory category,
    required double amount,
    required double total,
    required bool isExpense,
  }) {
    // Percentual que essa categoria representa do total
    final percent = total > 0 ? amount / total : 0.0;
    final color = isExpense ? AppColors.expense : AppColors.income;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Ícone da categoria
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(9),
                ),
                child:
                    Icon(category.icon, color: category.color, size: 17),
              ),
              const SizedBox(width: 10),

              // Nome da categoria
              Expanded(
                child: Text(
                  category.label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Percentual
              Text(
                '${(percent * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),

              // Valor
              Text(
                Formatter.formatCurrency(amount),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Barra de progresso
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 5,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(
                  category.color.withValues(alpha: 0.7)),
            ),
          ),
        ],
      ),
    );
  }
}
