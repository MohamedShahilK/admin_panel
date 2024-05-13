import 'package:admin_panel/models/new/all_tickets/get_all_tickets_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

final ticketListNotifier = BehaviorSubject<List<TicketsList>>.seeded([]);

final filterValue = BehaviorSubject<String>.seeded('');

final selectedStartDate = ValueNotifier<DateTime?>(null);
final selectedEndDate = ValueNotifier<DateTime?>(null);

ValueNotifier<int> currentPageForTicket = ValueNotifier(1);

class Ticket extends StatelessWidget {
  const Ticket({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
