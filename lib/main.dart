import 'package:admin_panel/controllers/MenuController.dart';
import 'package:admin_panel/controllers/sidemenu_controller.dart';
import 'package:admin_panel/screens/dashboard/dashboard_screen.dart';
import 'package:admin_panel/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'utils/constants.dart';
import 'screens/main/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => CustomMenuController()),
            ChangeNotifierProvider(create: (context) => SideMenuController()),
          ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: " Flutter Dashboard ",
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
