import 'dart:convert';

import 'package:financial_tracker/helper/transaction_fake_repository.dart';

import '../../common/errors/errors_classes.dart';
import '../../common/patterns/result.dart';
import '../../domain/entity/transaction_entity.dart';
import 'transaction_storage_contract.dart';

class TransactionFakeServiceImpl implements TransactionStorageContract {
  final TransactionFakeRepository _api = TransactionFakeRepository();

  @override
  Future<Result<List<TransactionEntity>, Failure>> fetchAllTransacions() async {
    try {
      final result = await _api.getData();
      final List<dynamic> jsonList = jsonDecode(result);
      return Success(jsonList
          .map((e) => TransactionEntity.fromMap(e as Map<String, dynamic>))
          .toList());
    } on Exception catch (e) {
      return Error(DefaultError('Erro ao buscar: ${e.toString()}'));
    }
  }

  @override
  Future<Result<TransactionEntity, Failure>> fetchTransacion(String id) =>
      throw UnimplementedError();

  @override
  Future<Result<List<TransactionEntity>, Failure>> fetchTransacionsByTipe(
      TransactionType type) =>
      throw UnimplementedError();

  @override
  Future<Result<void, Failure>> removeTransacion(String id) async {
    try {
      await _api.deleteData(id);
      return Success(null);
    } on RecordNotFound catch (e) {
      return Error(RecordNotFound(e.toString()));
    } on Exception catch (e) {
      return Error(DefaultError(e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> storeTransacion(TransactionEntity t) async {
    try {
      await _api.addData(t.toJson());
      return Success(null);
    } on InvalidData catch (e) {
      return Error(InvalidData(e.toString()));
    } on Exception catch (e) {
      return Error(DefaultError(e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> updateTransacion(TransactionEntity t) async {
    try {
      await _api.updateData(t.toJson());
      return Success(null);
    } on RecordNotFound catch (e) {
      return Error(RecordNotFound(e.toString()));
    } on Exception catch (e) {
      return Error(DefaultError(e.toString()));
    }
  }

  @override
  Future<Result<List<TransactionEntity>, Failure>> fetchTransacionsByDate(
      DateTime startDate, DateTime endDate) async {
    try {
      final result = await _api.getDataByDateRange(startDate, endDate);
      final List<dynamic> jsonList = jsonDecode(result);
      return Success(jsonList
          .map((e) => TransactionEntity.fromMap(e as Map<String, dynamic>))
          .toList());
    } on Exception catch (e) {
      return Error(DefaultError(e.toString()));
    }
  }
}
