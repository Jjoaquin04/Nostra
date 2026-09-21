// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseModelAdapter extends TypeAdapter<ExpenseModel> {
  @override
  final int typeId = 0;

  @override
  ExpenseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseModel(
      expenseOwner: fields[0] as String,
      expenseName: fields[1] as String,
      amount: fields[2] as double,
      category: fields[3] as String,
      date: fields[4] as DateTime,
      type: fields[5] as int,
      fixedExpense: fields[6] as int,
      changeHistory: (fields[7] as List?)?.cast<ExpenseChangeHistory>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.expenseOwner)
      ..writeByte(1)
      ..write(obj.expenseName)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.fixedExpense)
      ..writeByte(7)
      ..write(obj.changeHistory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
