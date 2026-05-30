import 'dart:convert';
import 'dart:math';

import 'package:financial_tracker/common/errors/errors_classes.dart';
import 'package:financial_tracker/common/errors/errors_messagens.dart';

import '../domain/entity/transaction_entity.dart';

class TransactionFakeRepository {
  final List<TransactionEntity> transactions = [];

  Future<String> getData() async {
    // Retorna lista vazia em JSON sem lançar erro
    return jsonEncode(transactions.map((e) => e.toMap()).toList());
  }

  Future<void> deleteData(String id) async {
    final index = transactions.indexWhere((e) => e.id == id);
    if (index == -1) throw RecordNotFound(MessagesError.recordNotFound);
    transactions.removeAt(index);
  }

  Future<void> addData(String transactionJson) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (transactionJson.isEmpty) throw InvalidData(MessagesError.recordInvalidFormat);
    transactions.add(TransactionEntity.fromMap(jsonDecode(transactionJson)));
  }

  Future<void> updateData(String transactionJson) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (transactionJson.isEmpty) throw InvalidData(MessagesError.recordInvalidFormat);
    final updated = TransactionEntity.fromMap(jsonDecode(transactionJson));
    final index = transactions.indexWhere((e) => e.id == updated.id);
    if (index == -1) throw RecordNotFound(MessagesError.recordNotFound);
    transactions[index] = updated;
  }

  Future<String> getDataByDateRange(DateTime startDate, DateTime endDate) async {
    final filtered = transactions.where((t) =>
        !t.date.isBefore(startDate) && !t.date.isAfter(endDate)).toList();
    return jsonEncode(filtered.map((e) => e.toMap()).toList());
  }
}
