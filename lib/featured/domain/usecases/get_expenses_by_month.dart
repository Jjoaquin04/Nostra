import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nostra/core/errors/failure.dart';
import 'package:nostra/core/usecases/usecase.dart';
import 'package:nostra/featured/domain/entity/expense.dart';
import 'package:nostra/featured/domain/repository/expense_repository.dart';

class GetExpensesByMonth
    implements Usecase<List<Expense>, ExpensesByMonthParams> {
  final ExpenseRepository expenseRepository;

  GetExpensesByMonth(this.expenseRepository);
  @override
  Future<Either<Failure, List<Expense>>> call(ExpensesByMonthParams params) {
    return expenseRepository.getExpensesByMonth(params.time);
  }
}

class ExpensesByMonthParams extends Equatable {
  final DateTime time;

  const ExpensesByMonthParams({required this.time});

  @override
  List<Object?> get props => [time];
}
