import 'package:financial_tracker/common/errors/errors_classes.dart';
import 'package:financial_tracker/common/patterns/command.dart';
import 'package:financial_tracker/common/theme/app_theme.dart';
import 'package:financial_tracker/common/utils/formatter.dart';
import 'package:financial_tracker/domain/entity/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'transaction_sheet.dart';

class TransactionCardSheets extends StatefulWidget {
  final List<TransactionEntity> incomeTransactions;
  final List<TransactionEntity> expenseTransactions;
  final Function(String id) onDelete;
  final Command1<void, Failure, TransactionEntity> undoDelete;
  final Command1<void, Failure, TransactionEntity> onEdit;
  final BuildContext scaffoldContext;

  const TransactionCardSheets({
    super.key,
    required this.incomeTransactions,
    required this.expenseTransactions,
    required this.onDelete,
    required this.undoDelete,
    required this.onEdit,
    required this.scaffoldContext,
  });

  @override
  State<TransactionCardSheets> createState() => _State();
}

class _State extends State<TransactionCardSheets>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _tab.addListener(() { if (mounted) setState(() {}); });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: _tab,
            tabs: [
              _tabLabel('Receitas', Icons.arrow_upward_rounded, 0,
                  AppColors.income, widget.incomeTransactions.length),
              _tabLabel('Despesas', Icons.arrow_downward_rounded, 1,
                  AppColors.expense, widget.expenseTransactions.length),
            ],
            indicatorColor: _tab.index == 0 ? AppColors.income : AppColors.expense,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: AppColors.divider,
            labelPadding: EdgeInsets.zero,
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _list(widget.incomeTransactions, AppColors.income, TransactionType.income),
                _list(widget.expenseTransactions, AppColors.expense, TransactionType.expense),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabLabel(String title, IconData icon, int idx, Color color, int count) {
    final sel = _tab.index == idx;
    final c = sel ? color : AppColors.textSecondary;
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: c),
          const SizedBox(width: 5),
          Text(title,
              style: TextStyle(
                  color: c, fontSize: 13,
                  fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: sel ? color.withValues(alpha: 0.15) : AppColors.divider,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('$count',
                style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w700,
                    color: sel ? color : AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _list(List<TransactionEntity> items, Color color, TransactionType type) {
    if (items.isEmpty) return _empty(type, color);
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (ctx, i) {
        final t = items[i];
        return Dismissible(
          key: ValueKey(t.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 18),
            decoration: BoxDecoration(
              color: AppColors.expense.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
          ),
          onDismissed: (_) {
            final copy = t.copyWith();
            widget.onDelete(t.id);
            ScaffoldMessenger.of(widget.scaffoldContext)
              ..clearSnackBars()
              ..showSnackBar(SnackBar(
                content: Text('"${t.title}" removida'),
                backgroundColor: AppColors.surfaceElevated,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                action: SnackBarAction(
                  label: 'DESFAZER',
                  textColor: Colors.amber,
                  onPressed: () => widget.undoDelete.execute(copy),
                ),
              ));
          },
          child: _tile(ctx, t, color, type),
        );
      },
    );
  }

  Widget _tile(BuildContext ctx, TransactionEntity t, Color color, TransactionType type) {
    final cat = t.category;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: cat.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(cat.icon, color: cat.color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(Formatter.formatCompactDate(t.date),
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: cat.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(cat.label,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600, color: cat.color)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(Formatter.formatCurrency(t.amount),
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => TransactionSheet.show(
              context: ctx,
              type: type,
              submitCommand: widget.onEdit,
              existingTransaction: t,
            ),
            child: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _empty(TransactionType type, Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            type == TransactionType.income
                ? Icons.savings_outlined : Icons.receipt_long_outlined,
            size: 40, color: color.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 10),
          Text('Nenhuma ${type.nameSingular.toLowerCase()}',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          const Text('Use os botões acima para adicionar',
              style: TextStyle(color: AppColors.textHint, fontSize: 11)),
        ],
      ),
    );
  }
}
