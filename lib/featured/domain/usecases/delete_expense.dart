import 'package:dartz/dartz.dart';
import 'package:nostra/core/errors/failure.dart';
import 'package:nostra/core/usecases/usecase.dart';
import 'package:nostra/featured/domain/entity/expense.dart';
import 'package:nostra/featured/domain/repository/expense_repository.dart';

class DeleteExpense extends Usecase<void, Expense> {
  final ExpenseRepository repository;

  DeleteExpense(this.repository);

  @override
  Future<Either<Failure, void>> call(Expense expense) {
    return repository.deleteExpense(expense);
  }
}
