import 'package:admin_panel/logic/check_in/check_in_state.dart';

class CheckInBloc {
  CheckInBloc() {
    initDetails();
  }

  Future<void> initDetails() async {}
  final state = CheckInState();

  Future<bool> checkValidation() async {
    var isValid = true;
    if (state.barcodeStream.value.isEmpty) {
      isValid = false;
      state.barcodeStreamError.add('Please provide barcode');
    } else if (state.barcodeStream.value.length < 3) {
      isValid = false;
      state.barcodeStreamError.add('Please enter atleast 3 digit barcode');
    } else {
      state.barcodeStreamError.add('');

    }
    return isValid;
  }

  void dispose() {
    state.dispose();
  }
}
