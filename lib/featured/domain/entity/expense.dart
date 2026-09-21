import 'package:equatable/equatable.dart';
import 'package:nostra/featured/data/expense_change_history.dart';

// Enum para diferenciar entre gasto e ingreso
enum TransactionType {
  expense, // Gasto
  income, // Ingreso
}

class Expense extends Equatable {
  final String? id;
  final String ownerExpense;
  final String nameExpense;
  final double amount;
  final String category;
  final DateTime date;
  final TransactionType type;
  final int fixedExpense;
  final List<ExpenseChangeHistory>? changeHistory;

  const Expense({
    this.id,
    required this.ownerExpense,
    required this.nameExpense,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    required this.fixedExpense,
    this.changeHistory,
  });

  @override
  List<Object?> get props => [
    id,
    ownerExpense,
    nameExpense,
    amount,
    category,
    date,
    type,
    fixedExpense,
    changeHistory,
  ];
}
