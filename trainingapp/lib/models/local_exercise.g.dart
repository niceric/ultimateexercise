// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalExerciseAdapter extends TypeAdapter<LocalExercise> {
  @override
  final int typeId = 3;

  @override
  LocalExercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalExercise(
      name: fields[0] as String,
      muscleGroup: fields[1] as String,
      isCustom: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LocalExercise obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.muscleGroup)
      ..writeByte(2)
      ..write(obj.isCustom);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
