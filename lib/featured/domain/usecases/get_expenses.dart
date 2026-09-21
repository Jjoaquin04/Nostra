import 'package:dartz/dartz.dart';
import 'package:nostra/core/errors/failure.dart';
import 'package:nostra/core/usecases/usecase.dart';
import 'package:nostra/featured/domain/entity/expense.dart';
import 'package:nostra/featured/domain/repository/expense_repository.dart';

class GetExpenses extends Usecase<List<Expense>, NoParams> {
  final ExpenseRepository repository;

  GetExpenses(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(NoParams params) {
    return repository.getExpenses();
  }
}
