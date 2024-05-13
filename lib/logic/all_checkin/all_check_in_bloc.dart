import 'package:admin_panel/logic/all_checkin/all_check_in_state.dart';

class AllCheckInBloc {
  AllCheckInBloc() {
    initDetails();
  }

  final state = AllCheckInState();

  Future<void> initDetails() async {
    state.carSelectionStream.add('All');
  }

  void dispose(){
    state.dispose();
  }
}
