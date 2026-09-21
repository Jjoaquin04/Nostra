import 'package:hive/hive.dart';

part 'expense_change_history.g.dart';

/// Tipo de cambio realizado en un gasto fijo
@HiveType(typeId: 3)
enum ChangeType {
  @HiveField(0)
  created, // Gasto creado

  @HiveField(1)
  edited, // Gasto editado (nombre, monto, categoría)

  @HiveField(2)
  deleted, // Gasto eliminado

  @HiveField(3)
  restored, // Gasto restaurado después de ser eliminado
}

@HiveType(typeId: 2)
class ExpenseChangeHistory {
  @HiveField(0)
  final ChangeType type;

  @HiveField(1)
  final DateTime changeDate;

  @HiveField(2)
  final Map<String, dynamic>? oldValues; // Valores anteriores (para ediciones)

  @HiveField(3)
  final Map<String, dynamic>? newValues; // Nuevos valores (para ediciones)

  ExpenseChangeHistory({
    required this.type,
    required this.changeDate,
    this.oldValues,
    this.newValues,
  });

  /// Crea un registro de creación
  factory ExpenseChangeHistory.created(DateTime date) {
    return ExpenseChangeHistory(type: ChangeType.created, changeDate: date);
  }

  /// Crea un registro de eliminación
  factory ExpenseChangeHistory.deleted(DateTime date) {
    return ExpenseChangeHistory(type: ChangeType.deleted, changeDate: date);
  }

  /// Crea un registro de edición
  factory ExpenseChangeHistory.edited(
    DateTime date,
    Map<String, dynamic> oldValues,
    Map<String, dynamic> newValues,
  ) {
    return ExpenseChangeHistory(
      type: ChangeType.edited,
      changeDate: date,
      oldValues: oldValues,
      newValues: newValues,
    );
  }
}
