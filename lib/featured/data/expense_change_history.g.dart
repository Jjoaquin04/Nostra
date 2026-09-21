// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_change_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseChangeHistoryAdapter extends TypeAdapter<ExpenseChangeHistory> {
  @override
  final int typeId = 2;

  @override
  ExpenseChangeHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseChangeHistory(
      type: fields[0] as ChangeType,
      changeDate: fields[1] as DateTime,
      oldValues: (fields[2] as Map?)?.cast<String, dynamic>(),
      newValues: (fields[3] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseChangeHistory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.changeDate)
      ..writeByte(2)
      ..write(obj.oldValues)
      ..writeByte(3)
      ..write(obj.newValues);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseChangeHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChangeTypeAdapter extends TypeAdapter<ChangeType> {
  @override
  final int typeId = 3;

  @override
  ChangeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChangeType.created;
      case 1:
        return ChangeType.edited;
      case 2:
        return ChangeType.deleted;
      case 3:
        return ChangeType.restored;
      default:
        return ChangeType.created;
    }
  }

  @override
  void write(BinaryWriter writer, ChangeType obj) {
    switch (obj) {
      case ChangeType.created:
        writer.writeByte(0);
        break;
      case ChangeType.edited:
        writer.writeByte(1);
        break;
      case ChangeType.deleted:
        writer.writeByte(2);
        break;
      case ChangeType.restored:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
