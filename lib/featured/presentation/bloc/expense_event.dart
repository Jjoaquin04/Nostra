import 'package:equatable/equatable.dart';
import 'package:nostra/featured/domain/entity/expense.dart';

/// Clase base para todos los eventos de gastos
abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

/// Evento: Cargar todos los gastos
class LoadExpensesEvent extends ExpenseEvent {
  const LoadExpensesEvent();
}

/// Evento: Agregar un nuevo gasto
class AddExpenseEvent extends ExpenseEvent {
  final String expenseOwner;
  final String expenseName;
  final double amount;
  final String category;
  final DateTime date;
  final TransactionType type;
  final int fixedExpense;

  const AddExpenseEvent({
    required this.expenseOwner,
    required this.expenseName,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    required this.fixedExpense,
  });

  @override
  List<Object?> get props => [
    expenseOwner,
    expenseName,
    amount,
    category,
    date,
    type,
    fixedExpense,
  ];
}

/// Evento: Actualizar un gasto existente
class UpdateExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const UpdateExpenseEvent({required this.expense});

  @override
  List<Object?> get props => [expense];
}

/// Evento: Eliminar un gasto
class DeleteExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const DeleteExpenseEvent({required this.expense});

  @override
  List<Object?> get props => [expense];
}

/// Evento: Filtrar gastos por categoría
class FilterExpensesByCategoryEvent extends ExpenseEvent {
  final String category;

  const FilterExpensesByCategoryEvent({required this.category});

  @override
  List<Object?> get props => [category];
}

/// Evento: Obtener el total de gastos
class GetTotalExpensesEvent extends ExpenseEvent {
  const GetTotalExpensesEvent();
}

class GetExpensesByMonthEvent extends ExpenseEvent {
  final DateTime time;

  const GetExpensesByMonthEvent({required this.time});

  @override
  List<Object?> get props => [time];
}

/// Evento: Activar modo de selección múltiple
class EnableSelectionModeEvent extends ExpenseEvent {
  const EnableSelectionModeEvent();
}

/// Evento: Desactivar modo de selección múltiple
class DisableSelectionModeEvent extends ExpenseEvent {
  const DisableSelectionModeEvent();
}

/// Evento: Seleccionar/deseleccionar un gasto
class ToggleExpenseSelectionEvent extends ExpenseEvent {
  final String expenseId;

  const ToggleExpenseSelectionEvent({required this.expenseId});

  @override
  List<Object?> get props => [expenseId];
}

/// Evento: Seleccionar todos los gastos
class SelectAllExpensesEvent extends ExpenseEvent {
  const SelectAllExpensesEvent();
}

/// Evento: Deseleccionar todos los gastos
class DeselectAllExpensesEvent extends ExpenseEvent {
  const DeselectAllExpensesEvent();
}

/// Evento: Eliminar gastos seleccionados
class DeleteSelectedExpensesEvent extends ExpenseEvent {
  const DeleteSelectedExpensesEvent();
}
