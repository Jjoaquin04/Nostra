import 'package:hive/hive.dart';
import 'package:nostra/core/constant/hive_constants.dart';
import 'package:nostra/featured/data/expense_change_history.dart';
import 'package:nostra/featured/data/expense_model.dart';

/// Utilidades para gestionar el historial de cambios de gastos fijos
class ExpenseChangeHistoryHelper {
  /// Marcar un gasto fijo como eliminado (soft delete)
  static Future<void> markAsDeleted(String expenseKey) async {
    final box = await Hive.openBox<ExpenseModel>(HiveConstants.expenseBox);
    final keyInt = int.tryParse(expenseKey);

    if (keyInt == null) return;

    final expense = box.get(keyInt);
    if (expense == null || expense.fixedExpense != 1) return;

    // Agregar registro de eliminación
    final changeHistory = expense.changeHistory ?? [];
    changeHistory.add(ExpenseChangeHistory.deleted(DateTime.now()));
    expense.changeHistory = changeHistory;

    await expense.save();
  }

  /// Registrar una edición en un gasto fijo
  static Future<void> recordEdit(
    String expenseKey,
    ExpenseModel oldExpense,
    ExpenseModel newExpense,
  ) async {
    if (oldExpense.fixedExpense != 1) return;

    final box = await Hive.openBox<ExpenseModel>(HiveConstants.expenseBox);
    final keyInt = int.tryParse(expenseKey);

    if (keyInt == null) return;

    // Crear mapa de cambios
    Map<String, dynamic> oldValues = {};
    Map<String, dynamic> newValues = {};

    if (oldExpense.expenseName != newExpense.expenseName) {
      oldValues['expenseName'] = oldExpense.expenseName;
      newValues['expenseName'] = newExpense.expenseName;
    }

    if (oldExpense.amount != newExpense.amount) {
      oldValues['amount'] = oldExpense.amount;
      newValues['amount'] = newExpense.amount;
    }

    if (oldExpense.category != newExpense.category) {
      oldValues['category'] = oldExpense.category;
      newValues['category'] = newExpense.category;
    }

    if (oldExpense.fixedExpense != newExpense.fixedExpense) {
      oldValues['fixedExpense'] = oldExpense.fixedExpense;
      newValues['fixedExpense'] = newExpense.fixedExpense;
    }

    // Solo registrar si hubo cambios significativos
    if (oldValues.isNotEmpty) {
      final changeHistory = newExpense.changeHistory ?? [];
      changeHistory.add(
        ExpenseChangeHistory.edited(DateTime.now(), oldValues, newValues),
      );
      newExpense.changeHistory = changeHistory;

      await box.put(keyInt, newExpense);
    }
  }
}
