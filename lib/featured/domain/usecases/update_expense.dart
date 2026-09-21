import 'package:dartz/dartz.dart';
import 'package:nostra/core/errors/failure.dart';
import 'package:nostra/core/usecases/usecase.dart';
import 'package:nostra/featured/domain/entity/expense.dart';
import 'package:nostra/featured/domain/repository/expense_repository.dart';

class UpdateExpense extends Usecase<void, Expense> {
  final ExpenseRepository repository;

  UpdateExpense(this.repository);

  @override
  Future<Either<Failure, void>> call(Expense expense) {
    return repository.updateExpense(expense);
  }
}
