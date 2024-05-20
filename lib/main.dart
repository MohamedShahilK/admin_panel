import 'dart:html';

import 'package:admin_panel/controllers/MenuController.dart';
import 'package:admin_panel/controllers/dashboard_tab_controller.dart';
import 'package:admin_panel/controllers/sidemenu_controller.dart';
import 'package:admin_panel/logic/account/account_bloc.dart';
import 'package:admin_panel/logic/actions/actions_bloc.dart';
import 'package:admin_panel/logic/check_in/check_in_bloc.dart';
import 'package:admin_panel/logic/check_out/check_out_bloc.dart';
import 'package:admin_panel/logic/dashboard/dashboard_bloc.dart';
import 'package:admin_panel/logic/notification/notification_bloc.dart';
import 'package:admin_panel/logic/parked/parked_bloc.dart';
import 'package:admin_panel/logic/report/cash_collection_bloc.dart';
import 'package:admin_panel/logic/report/master_report_bloc.dart';
import 'package:admin_panel/logic/report/navigation_report_bloc.dart';
import 'package:admin_panel/logic/search/search_bloc.dart';
import 'package:admin_panel/main_initialization.dart';
import 'package:admin_panel/screens/dashboard/dashboard_screen.dart';
import 'package:admin_panel/utils/routes.dart';
import 'package:admin_panel/utils/storage_services.dart';
import 'package:admin_panel/utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'utils/constants.dart';

Future<void> main() async {
  await mainInitialization();
  runApp(const MyApp());
}

const token =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjIsIm5hbWUiOiJhaXRAbG9iYnkiLCJ1c2VybmFtZSI6ImFpdEBsb2JieSIsImxvY2F0aW9uSWQiOjEsInVzZXJDYXRlZ29yeSI6IkwiLCJ1c2VyVHlwZSI6IlUiLCJwZXJtaXNzaW9ucyI6eyJmZWVfY29sbGVjdGlvbiI6IlkiLCJ0aWNrZXRfY2hlY2tpbiI6IlkiLCJ0aWNrZXRfcmVxdWVzdCI6IlkiLCJ0aWNrZXRfb250aGV3YXkiOiJZIiwidGlja2V0X2NvbGxlY3Rub3ciOiJZIiwidGlja2V0X2NoZWNrb3V0IjoiWSIsInRpY2tldF9lZGl0IjoiTiIsInRpY2tldF9kZWxldGUiOiJOIiwidGlja2V0X21vYmlsZV9wcmludCI6Ik4iLCJyZXBvcnQiOiJOIiwiY2FzaF9jaGVja2luIjoiWSIsImNhc2hfY2hlY2tpbl9lZGl0IjoiWSIsImltYWdlX3VwbG9hZCI6IlkifSwibG9jYXRpb25OYW1lIjoiYXJhYmluZm90ZWMtZGVtbyIsIk9QRVJBVE9SX0lEIjoidGVzdDEzMiIsImlhdCI6MTcxNTYwMDc2OCwiZXhwIjoxNzE4MTkyNzY4fQ.mgj-oL-e0Yf8eMYf03nIErWlJW7p4884TAgJsZ1FgZU';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    StorageServices.to.setString(StorageServicesKeys.token, token);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CustomMenuController()),
        ChangeNotifierProvider(create: (context) => SideMenuController()),
        ChangeNotifierProvider(create: (context) => DashBoardTabController()),

        //
        Provider(
          create: (context) => DashboardBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        ),

        Provider(
          create: (context) => ActionsBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        ),

        Provider(
          create: (context) => CheckOutBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        ),

        Provider(
          create: (context) => NotificationBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        ),

        Provider(
          create: (context) => AccountBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        ),

        Provider(
          create: (context) => SearchBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        ),

        Provider(
          create: (context) => ParkedBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        ),

        Provider(
          create: (context) => MasterReportBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        ),

        Provider(
          create: (context) => NavigationReportBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        ),

        Provider(
          create: (context) => CashCollectionBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Varlet Parking",
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),

        routes: routes,

        onGenerateRoute: generateRoutes,
        // home: MultiProvider(
        //   providers: [
        //     ChangeNotifierProvider(create: (context) => CustomMenuController()),
        //     ChangeNotifierProvider(create: (context) => SideMenuController()),
        //   ],
        //   child: MainScreen(),
        // ),
      ),
    );
  }
}
