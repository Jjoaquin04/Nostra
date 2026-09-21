import 'package:dartz/dartz.dart';
import 'package:nostra/core/errors/failure.dart';
import 'package:nostra/featured/domain/entity/expense.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, List<Expense>>> getExpenses();
  Future<Either<Failure, Expense>> addExpense(
    String expenseOwner,
    String expenseName,
    double amount,
    String category,
    DateTime date,
    TransactionType type,
    int fixedExpense,
  );
  Future<Either<Failure, List<Expense>>> getExpensesByMonth(DateTime date);
  Future<Either<Failure, void>> deleteExpense(Expense expense);
  Future<Either<Failure, void>> updateExpense(Expense expense);
}
