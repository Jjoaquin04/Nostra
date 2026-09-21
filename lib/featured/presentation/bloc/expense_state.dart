import 'package:equatable/equatable.dart';
import 'package:nostra/featured/domain/entity/expense.dart';

/// Clase base para todos los estados de gastos
abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class ExpenseInitial extends ExpenseState {
  const ExpenseInitial();
}

/// Estado: Cargando
class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();
}

/// Estado: Gastos cargados exitosamente
class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;
  final double? totalAmount;

  const ExpenseLoaded({required this.expenses, this.totalAmount});

  @override
  List<Object?> get props => [expenses, totalAmount];

  /// Crear una copia con valores actualizados
  ExpenseLoaded copyWith({List<Expense>? expenses, double? totalAmount}) {
    return ExpenseLoaded(
      expenses: expenses ?? this.expenses,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}

/// Estado: Gasto agregado exitosamente
class ExpenseAdded extends ExpenseState {
  final Expense expense;

  const ExpenseAdded({required this.expense});

  @override
  List<Object?> get props => [expense];
}

/// Estado: Gasto actualizado exitosamente
class ExpenseUpdated extends ExpenseState {
  final Expense expense;

  const ExpenseUpdated({required this.expense});

  @override
  List<Object?> get props => [expense];
}

/// Estado: Gasto eliminado exitosamente
class ExpenseDeleted extends ExpenseState {
  const ExpenseDeleted();
}

/// Estado: Error
class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Estado: Total calculado
class ExpenseTotalCalculated extends ExpenseState {
  final double total;

  const ExpenseTotalCalculated({required this.total});

  @override
  List<Object?> get props => [total];
}

/// Estado: Modo de selección múltiple activado
class ExpenseSelectionMode extends ExpenseState {
  final List<Expense> expenses;
  final Set<String> selectedIds;
  final double? totalAmount;

  const ExpenseSelectionMode({
    required this.expenses,
    required this.selectedIds,
    this.totalAmount,
  });

  @override
  List<Object?> get props => [expenses, selectedIds, totalAmount];

  /// Crear una copia con valores actualizados
  ExpenseSelectionMode copyWith({
    List<Expense>? expenses,
    Set<String>? selectedIds,
    double? totalAmount,
  }) {
    return ExpenseSelectionMode(
      expenses: expenses ?? this.expenses,
      selectedIds: selectedIds ?? this.selectedIds,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
