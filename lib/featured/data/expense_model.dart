import 'package:hive/hive.dart';
import 'package:nostra/core/constant/hive_constants.dart';
import 'package:nostra/featured/domain/entity/expense.dart';
import 'package:nostra/featured/data/expense_change_history.dart';
part 'expense_model.g.dart';

@HiveType(typeId: HiveConstants.expenseTypeId)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  late String expenseOwner;

  @HiveField(1)
  late String expenseName;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late String category;

  @HiveField(4)
  late DateTime date;

  @HiveField(5)
  late int type; // 0 = expense, 1 = income

  @HiveField(6)
  late int fixedExpense; // 0 = no gasto fijo 1 = gasto fijo

  @HiveField(7)
  late List<ExpenseChangeHistory>? changeHistory; // Historial de cambios para gastos fijos

  ExpenseModel({
    required this.expenseOwner,
    required this.expenseName,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    required this.fixedExpense,
    this.changeHistory,
  });

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      expenseOwner: expense.ownerExpense,
      expenseName: expense.nameExpense,
      amount: expense.amount,
      category: expense.category,
      date: expense.date,
      type: expense.type == TransactionType.expense ? 0 : 1,
      fixedExpense: expense.fixedExpense,
      changeHistory: expense.changeHistory,
    );
  }

  Expense toEntity({String? id}) {
    return Expense(
      id: id,
      ownerExpense: expenseOwner,
      nameExpense: expenseName,
      amount: amount,
      category: category,
      date: date,
      type: type == 0 ? TransactionType.expense : TransactionType.income,
      fixedExpense: fixedExpense,
      changeHistory: changeHistory,
    );
  }

  /// Obtiene el estado del gasto en una fecha específica
  /// Retorna null si el gasto estaba eliminado en esa fecha
  ExpenseModel? getStateAtDate(DateTime queryDate) {
    // Si no es gasto fijo, retornar tal cual si la fecha coincide
    if (fixedExpense != 1) {
      return date.year == queryDate.year && date.month == queryDate.month
          ? this
          : null;
    }

    // Para gastos fijos, verificar el historial
    if (changeHistory == null || changeHistory!.isEmpty) {
      // Si no hay historial y el gasto fue creado antes o durante el mes consultado
      return date.isBefore(DateTime(queryDate.year, queryDate.month + 1))
          ? this
          : null;
    }

    // Verificar si el gasto existía en la fecha consultada
    final endOfQueryMonth = DateTime(
      queryDate.year,
      queryDate.month + 1,
      0,
      23,
      59,
      59,
    );
    bool wasDeleted = false;
    Map<String, dynamic> currentState = {
      'expenseOwner': expenseOwner,
      'expenseName': expenseName,
      'amount': amount,
      'category': category,
      'type': type,
    };

    // Aplicar cambios hasta la fecha consultada
    for (var change in changeHistory!) {
      if (change.changeDate.isAfter(endOfQueryMonth)) {
        break; // No aplicar cambios futuros al mes consultado
      }

      switch (change.type) {
        case ChangeType.deleted:
          wasDeleted = true;
          break;
        case ChangeType.restored:
          wasDeleted = false;
          break;
        case ChangeType.edited:
          if (change.newValues != null) {
            currentState.addAll(change.newValues!);
          }
          break;
        default:
          break;
      }
    }

    // Si fue eliminado antes o durante el mes consultado, no mostrar
    if (wasDeleted) {
      return null;
    }

    // Si el gasto fue creado después del mes consultado, no mostrar
    if (date.isAfter(endOfQueryMonth)) {
      return null;
    }

    // Crear una copia con el estado reconstruido
    return ExpenseModel(
      expenseOwner: currentState['expenseOwner'] as String,
      expenseName: currentState['expenseName'] as String,
      amount: currentState['amount'] as double,
      category: currentState['category'] as String,
      date: date, // Mantener fecha original
      type: currentState['type'] as int,
      fixedExpense: fixedExpense,
      changeHistory: changeHistory,
    );
  }
}
