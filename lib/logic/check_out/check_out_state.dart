import 'package:rxdart/rxdart.dart';

class CheckOutState {
  factory CheckOutState() {
    return _singleton;
  }

  CheckOutState._internal();

  static final CheckOutState _singleton = CheckOutState._internal();

  // TextFields
  final barcodeStream = BehaviorSubject<String>.seeded('');
  final cashierNameStream = BehaviorSubject<String>.seeded('');
  final amountToBePaidStream = BehaviorSubject<String>.seeded('');
  final notesStream = BehaviorSubject<String>.seeded('');

  // DropDowns
  final driverStream = BehaviorSubject<String>.seeded('');
  final driverIdStream = BehaviorSubject<int?>();
  final outletStream = BehaviorSubject<String>.seeded('');
  final outletIdStream = BehaviorSubject<int?>();

  final paymentIdStream = BehaviorSubject<int?>();

  // Error
  final barcodeStreamError = BehaviorSubject<String>.seeded('');

  void clearStreams() {
    barcodeStream.add('');
    cashierNameStream.add('');
    amountToBePaidStream.add('');
    notesStream.add('');
    driverStream.add('');
    outletStream.add('');
    barcodeStreamError.add('');
  }

  void dispose() {
    barcodeStream.close();
    cashierNameStream.close();
    driverStream.close();
    barcodeStreamError.close();
    driverIdStream.close();
  }
}
