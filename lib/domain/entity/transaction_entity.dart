import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum TransactionType { income, expense }

extension TransactionTypeExtension on TransactionType {
  String get nameSingular {
    switch (this) {
      case TransactionType.income:
        return 'Receita';
      case TransactionType.expense:
        return 'Despesa';
    }
  }

  String get namePlural {
    switch (this) {
      case TransactionType.income:
        return 'Receitas';
      case TransactionType.expense:
        return 'Despesas';
    }
  }
}

enum TransactionCategory {
  salary,
  food,
  transport,
  health,
  education,
  entertainment,
  shopping,
  utilities,
  investment,
  other,
}

extension TransactionCategoryExtension on TransactionCategory {
  String get label {
    switch (this) {
      case TransactionCategory.salary:
        return 'Salário';
      case TransactionCategory.food:
        return 'Alimentação';
      case TransactionCategory.transport:
        return 'Transporte';
      case TransactionCategory.health:
        return 'Saúde';
      case TransactionCategory.education:
        return 'Educação';
      case TransactionCategory.entertainment:
        return 'Lazer';
      case TransactionCategory.shopping:
        return 'Compras';
      case TransactionCategory.utilities:
        return 'Contas';
      case TransactionCategory.investment:
        return 'Investimento';
      case TransactionCategory.other:
        return 'Outros';
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionCategory.salary:
        return Icons.work_rounded;
      case TransactionCategory.food:
        return Icons.restaurant_rounded;
      case TransactionCategory.transport:
        return Icons.directions_car_rounded;
      case TransactionCategory.health:
        return Icons.favorite_rounded;
      case TransactionCategory.education:
        return Icons.school_rounded;
      case TransactionCategory.entertainment:
        return Icons.movie_rounded;
      case TransactionCategory.shopping:
        return Icons.shopping_bag_rounded;
      case TransactionCategory.utilities:
        return Icons.receipt_long_rounded;
      case TransactionCategory.investment:
        return Icons.trending_up_rounded;
      case TransactionCategory.other:
        return Icons.category_rounded;
    }
  }

  Color get color {
    switch (this) {
      case TransactionCategory.salary:
        return const Color(0xFF1E88E5);
      case TransactionCategory.food:
        return const Color(0xFFFF7043);
      case TransactionCategory.transport:
        return const Color(0xFF7E57C2);
      case TransactionCategory.health:
        return const Color(0xFFE53935);
      case TransactionCategory.education:
        return const Color(0xFF43A047);
      case TransactionCategory.entertainment:
        return const Color(0xFFFB8C00);
      case TransactionCategory.shopping:
        return const Color(0xFFEC407A);
      case TransactionCategory.utilities:
        return const Color(0xFF26A69A);
      case TransactionCategory.investment:
        return const Color(0xFF00ACC1);
      case TransactionCategory.other:
        return const Color(0xFF78909C);
    }
  }
}

class TransactionEntity {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final TransactionCategory category;

  static final Uuid _uuid = Uuid();

  TransactionEntity({
    String? id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.category = TransactionCategory.other,
  }) : id = id ?? _uuid.v4();

  TransactionEntity copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    TransactionType? type,
    TransactionCategory? category,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toUtc().toIso8601String(),
      'type': type.name,
      'category': category.name,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory TransactionEntity.fromMap(Map<String, dynamic> map) {
    return TransactionEntity(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']).toLocal(),
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.expense,
      ),
      category: TransactionCategory.values.firstWhere(
        (e) => e.name == (map['category'] ?? 'other'),
        orElse: () => TransactionCategory.other,
      ),
    );
  }

  factory TransactionEntity.sampleExpense() {
    return TransactionEntity(
      title: 'Almoço',
      amount: 30.0,
      date: DateTime.now(),
      type: TransactionType.expense,
      category: TransactionCategory.food,
    );
  }

  factory TransactionEntity.sampleIncome() {
    return TransactionEntity(
      title: 'Salário',
      amount: 2500.0,
      date: DateTime.now(),
      type: TransactionType.income,
      category: TransactionCategory.salary,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionEntity &&
        other.id == id &&
        other.title == title &&
        other.amount == amount &&
        other.date == date &&
        other.type == type &&
        other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        amount.hashCode ^
        date.hashCode ^
        type.hashCode ^
        category.hashCode;
  }
}
