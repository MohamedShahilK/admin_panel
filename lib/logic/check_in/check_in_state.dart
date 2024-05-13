import 'package:rxdart/rxdart.dart';

class CheckInState {
  factory CheckInState() {
    return _singleton;
  }

  CheckInState._internal();

  static final CheckInState _singleton = CheckInState._internal();

  // TextFields
  final barcodeStream = BehaviorSubject<String>.seeded('');
  final phoneNumberStream = BehaviorSubject<String>.seeded('');
  final plateNumberStream = BehaviorSubject<String>.seeded('');
  final parkingNumberStream = BehaviorSubject<String>.seeded('');
  final descriptionStream = BehaviorSubject<String>.seeded('');
  final roomNumberStream = BehaviorSubject<String>.seeded('');
  final amountToBePaidStream = BehaviorSubject<String>.seeded('');

  // DropDowns
  final carBrandStream = BehaviorSubject<String>.seeded('');
  final carColorStream = BehaviorSubject<String>.seeded('');
  final registerNumberStream = BehaviorSubject<String>.seeded('');
  final driverStream = BehaviorSubject<String>.seeded('');
  final guestTypeStream = BehaviorSubject<String>.seeded('');

  // Error
  final barcodeStreamError = BehaviorSubject<String>.seeded('');

  void dispose() {
    barcodeStream.close();
    phoneNumberStream.close();
    plateNumberStream.close();
    descriptionStream.close();
    parkingNumberStream.close();
    roomNumberStream.close();
    amountToBePaidStream.close();
    carBrandStream.close();
    carColorStream.close();
    registerNumberStream.close();
    driverStream.close();
    guestTypeStream.close();
    barcodeStreamError.close();
  }
}
