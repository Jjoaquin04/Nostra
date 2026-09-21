import 'package:hive/hive.dart';
import 'package:nostra/core/constant/hive_constants.dart';
import 'package:nostra/core/errors/exception.dart';
import 'package:nostra/featured/data/datasources/expense_local_datasource.dart';
import 'package:nostra/featured/data/expense_model.dart';

class ExpenseLocalDatasourceImpl implements ExpenseLocalDataSource {
  Box<ExpenseModel> _getBox() {
    try {
      return Hive.box<ExpenseModel>(HiveConstants.expenseBox);
    } catch (e) {
      throw CacheException('No se ha podido acceder a la db: $e');
    }
  }

  @override
  Future<String> addExpense(ExpenseModel expense) async {
    try {
      final box = _getBox();
      final key = await box.add(expense);
      return key.toString();
    } catch (e) {
      throw CacheException('Error al guardar el gasto');
    }
  }

  @override
  Future<void> deleteExpense(String key) async {
    try {
      final box = _getBox();
      final keyInt = int.tryParse(key);
      if (keyInt == null) {
        throw CacheException('Key inválida para eliminar gasto');
      }
      await box.delete(keyInt);
    } catch (e) {
      throw CacheException('Error al eliminar el gasto');
    }
  }

  @override
  Map<String, ExpenseModel> getAllExpenses() {
    try {
      final box = _getBox();
      return box.toMap().map((key, value) => MapEntry(key.toString(), value));
    } catch (e) {
      throw CacheException('Error al obtener todos los gastos');
    }
  }

  @override
  double getTotalExpenses() {
    try {
      final box = _getBox();
      return box.values.fold(0.0, (sum, expense) => sum + expense.amount);
    } catch (e) {
      throw CacheException('Error al calcular el total: $e');
    }
  }

  @override
  Future<void> updateExpense(String key, ExpenseModel expense) async {
    try {
      final box = _getBox();
      final keyInt = int.tryParse(key);
      if (keyInt == null) {
        throw CacheException('Key inválida para actualizar gasto');
      }
      await box.put(keyInt, expense);
    } catch (e) {
      throw CacheException('Error al actualizar el gasto: $e');
    }
  }

  @override
  Map<String, ExpenseModel> getExpensesByMonth(DateTime time) {
    try {
      final box = _getBox();
      final Map<String, ExpenseModel> result = {};

      for (var entry in box.toMap().entries) {
        final key = entry.key.toString();
        final expense = entry.value;

        // Obtener el estado del gasto en la fecha consultada
        final stateAtDate = expense.getStateAtDate(time);

        // Si el gasto existía en ese mes, agregarlo
        if (stateAtDate != null) {
          result[key] = stateAtDate;
        }
      }

      return result;
    } catch (e) {
      throw CacheException("Error al obtener los gastos de este mes: $e");
    }
  }
}
