import 'dart:math';
import 'package:faker_dart/faker_dart.dart';
import '../domain/entity/transaction_entity.dart';

abstract class TransactionFakeFactory {
  static final _random = Random();

  static TransactionEntity factory() {
    final faker = Faker.instance;
    faker.setLocale(FakerLocaleType.pt_PT);

    final type = (faker.datatype.boolean())
        ? TransactionType.income
        : TransactionType.expense;

    final incomeCategories = [
      TransactionCategory.salary,
      TransactionCategory.investment,
      TransactionCategory.other,
    ];

    final expenseCategories = [
      TransactionCategory.food,
      TransactionCategory.transport,
      TransactionCategory.health,
      TransactionCategory.education,
      TransactionCategory.entertainment,
      TransactionCategory.shopping,
      TransactionCategory.utilities,
      TransactionCategory.other,
    ];

    final category = type == TransactionType.income
        ? incomeCategories[_random.nextInt(incomeCategories.length)]
        : expenseCategories[_random.nextInt(expenseCategories.length)];

    return TransactionEntity(
      title: faker.commerce.productName(),
      type: type,
      date: faker.date.between(
        DateTime.now().subtract(Duration(days: 30)),
        DateTime.now(),
      ),
      amount: faker.datatype.float(
        min: 50.0,
        max: 2000.0,
        precision: 2,
      ),
      category: category,
    );
  }
}
