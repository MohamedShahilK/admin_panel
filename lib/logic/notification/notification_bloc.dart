// ignore_for_file: lines_longer_than_80_chars

import 'package:rxdart/rxdart.dart';
import 'package:admin_panel/models/new/all_checkout/all_checkout_response_model.dart';

import 'package:admin_panel/services/notification/notification_services.dart';

class NotificationBloc {
  NotificationBloc() {
    initDetails();
  }

  Future<void> initDetails() async {
    await getRequestedTickets(orderBy: 'id');
    await getOntheWayTickets(orderBy: 'id');
  }

  final getAllRequestedTickets = BehaviorSubject<AllCheckOutResponse?>();
  final getAllOntheWayTickets = BehaviorSubject<AllCheckOutResponse?>();

  Future<void> getRequestedTickets({
    required String orderBy,
    String orderByDirection = 'DESC', //ASC
  }) async {
    final respModel = await NotificationsServices().getRequestedTickets(orderBy: orderBy, orderByDirection: orderByDirection);
    getAllRequestedTickets.add(respModel);
  }

  Future<void> getOntheWayTickets({
    required String orderBy,
    String orderByDirection = 'DESC', //ASC
  }) async {
    final respModel = await NotificationsServices().getOnTheWayTickets(orderBy: orderBy, orderByDirection: orderByDirection);
    getAllOntheWayTickets.add(respModel);
  }

  void dispose() {
    getAllRequestedTickets.close();
    getAllOntheWayTickets.close();
  }
}
