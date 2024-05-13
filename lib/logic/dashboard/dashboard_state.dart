import 'package:rxdart/rxdart.dart';
import 'package:admin_panel/models/new/all_tickets/get_all_tickets_response.dart';
import 'package:admin_panel/models/new/dashboard/dashboard_resp_model.dart';

class DashboardState {
  factory DashboardState() {
    return _singleton;
  }

  DashboardState._internal();

  static final DashboardState _singleton = DashboardState._internal();

  // final filterDate = BehaviorSubject<String>.seeded('Today');
  final filterDate = BehaviorSubject<String>.seeded('Last 3 Days');

  final getAllTicketsRespStream = BehaviorSubject<GetAllTicketsResponse?>();

  final getDashRespStream = BehaviorSubject<DashBoardResponseModel?>();

  void dispose() {
    filterDate.close();
    getAllTicketsRespStream.close();
    getDashRespStream.close();
  }
}
