
import 'package:admin_panel/logic/all_checkout/all_check_out_state.dart';

class AllCheckOutBloc {
  AllCheckOutBloc() {
    initDetails();
  }

  final state = AllCheckOutState();

  Future<void> initDetails() async {
    state.carSelectionStream.add('All');
  }

  void dispose(){
    state.dispose();
  }
}
