import 'package:hive_flutter/hive_flutter.dart';
part 'check_in.g.dart';

@HiveType(typeId: 0)
class HiveCheckInModel {
  HiveCheckInModel({
    required this.barcode,
    this.phoneNumber = '',
    this.carBrand = '',
    this.carColor = '',
    this.registerNumber = '',
    this.parkingNumber = '',
    this.driver = '',
    this.guestType = '',
    this.description = '',
    this.roomNumber = '',
  });

  @HiveField(0)
  final String barcode;

  @HiveField(1)
  final String phoneNumber;

  @HiveField(2)
  final String carBrand;

  @HiveField(3)
  final String carColor;

  @HiveField(4)
  final String registerNumber;

  @HiveField(5)
  final String parkingNumber;

  @HiveField(6)
  final String driver;

  @HiveField(7)
  final String guestType;

  @HiveField(8)
  final String description;

  @HiveField(9)
  final String roomNumber;

  @override
  String toString() {
    return 'Barcode: $barcode';
  }
}
