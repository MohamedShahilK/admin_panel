// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveCheckInModelAdapter extends TypeAdapter<HiveCheckInModel> {
  @override
  final int typeId = 0;

  @override
  HiveCheckInModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCheckInModel(
      barcode: fields[0] as String,
      phoneNumber: fields[1] as String,
      carBrand: fields[2] as String,
      carColor: fields[3] as String,
      registerNumber: fields[4] as String,
      parkingNumber: fields[5] as String,
      driver: fields[6] as String,
      guestType: fields[7] as String,
      description: fields[8] as String,
      roomNumber: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCheckInModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.barcode)
      ..writeByte(1)
      ..write(obj.phoneNumber)
      ..writeByte(2)
      ..write(obj.carBrand)
      ..writeByte(3)
      ..write(obj.carColor)
      ..writeByte(4)
      ..write(obj.registerNumber)
      ..writeByte(5)
      ..write(obj.parkingNumber)
      ..writeByte(6)
      ..write(obj.driver)
      ..writeByte(7)
      ..write(obj.guestType)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.roomNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCheckInModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
