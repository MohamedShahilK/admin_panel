// ignore_for_file: use_build_context_synchronously, unawaited_futures, avoid_print, inference_failure_on_instance_creation, lines_longer_than_80_chars

import 'dart:io';
import 'package:admin_panel/screens/dashboard/dashboard_screen.dart';
import 'package:admin_panel/screens/login/login.dart';
import 'package:admin_panel/services/auth/auth_services.dart';
import 'package:admin_panel/utils/storage_services.dart';
import 'package:admin_panel/utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // final isLogined = StorageServices.to.getBool(StorageServicesKeys.isLoginKey);

  Future<void> validLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    final authServices = AuthServices();
    final token = StorageServices.to.getString(StorageServicesKeys.token);
    final haveToken = token.isNotEmpty;
    if (haveToken) {
      final authResp = await authServices.getToken(token: token);

      if (authResp != null && authResp.status == 'OK' && authResp.message == 'Valid Token') {
        final regenerateAuthResp = await authServices.regenerateToken(token: token);

        //print('Valid Token ${authResp.data.token}');

        if (regenerateAuthResp.status == 'OK' && regenerateAuthResp.message == 'Token regenerated') {
          //print('Token Regenerated ${regenerateAuthResp.data.token}');
          await StorageServices.to.setString(
            StorageServicesKeys.token,
            regenerateAuthResp.data.token,
          );
          Navigator.pushReplacement(
            context,
            // MaterialPageRoute(
            //   builder: (context) => UpgradeAlert(
            //     dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material,
            //     showIgnore: false,
            //     upgrader: Upgrader(durationUntilAlertAgain: const Duration(seconds: 2)),
            //     child: const NavigationPage(),
            //   ),
            // ),
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const DashboardScreen(),
              transitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
          return;
        }
      } else if (authResp == null) {
        //print('Invalid Token $token');
        Navigator.pushAndRemoveUntil(
          context,
          // MaterialPageRoute(
          //   builder: (context) => UpgradeAlert(
          //     dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material,
          //     showIgnore: false,
          //     upgrader: Upgrader(durationUntilAlertAgain: const Duration(seconds: 2)),
          //     child: const LoginPage(),
          //   ),
          // ),
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
          (route) => false,
        );
        return;
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        // MaterialPageRoute(
        //   builder: (context) => UpgradeAlert(
        //     dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material,
        //     showIgnore: false,
        //     upgrader: Upgrader(durationUntilAlertAgain: const Duration(seconds: 2)),
        //     child: const LoginPage(),
        //   ),
        // ),
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // navigateToHome();
    validLogin();
  }

  // Future<void> navigateToHome() async {
  //   await Future.delayed(const Duration(seconds: 3));
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             // isLogined ? const CustomDrawer() : const LoginPage(),
  //             isLogined ? NavigationPage() : const LoginPage(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withClampedTextScaling(
      minScaleFactor: 0.85, // set min scale value here
      maxScaleFactor: .95,
      child: Scaffold(
        // backgroundColor: Colors.amber,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.matrix(<double>[
                // R  G  B  A  Offset
                0.65, 0, 0, 0, 0, // Red channel
                0, 0.65, 0, 0, 0, // Green channel
                0, 0, 0.65, 0, 0, // Blue channel
                0, 0, 0, 1, 0, // Alpha channel
              ]),
              image: AssetImage('assets/images/splash2.jpg'),
              // image: NetworkImage('https://img.freepik.com/free-photo/view-3d-car_23-2150998612.jpg?t=st=1716273978~exp=1716277578~hmac=3ea4a9e8ad70110943472f919daf84e3247839aa3630684b06d9896f1758da27&w=1380'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            // padding: const EdgeInsets.only(top: 230),
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Container(),

                // Logo
                Column(
                  children: [
                    Image.asset(
                      // AppImages.appLogo,
                      'assets/images/new_logo-removebg-preview.png',
                      width: 320,
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
                // ShaderMask(
                //   blendMode: BlendMode.srcIn,
                //   shaderCallback: (bounds) => LinearGradient(
                //     colors: [
                //       Colors.pink.shade900,
                //       Colors.purple.shade900,
                //     ],
                //   ).createShader(
                //     Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                //   ),
                //   child: Text(
                //     'Valet parking services',
                //     style:
                //         // GoogleFonts.pacifico(color: Colors.red, fontSize: 25.sp),
                //         GoogleFonts.pacifico(color: Colors.red, fontSize: 22.w),
                //   ),
                // ),
                const SizedBox(height: 10),
                LoadingAnimationWidget.beat(color: Colors.purple.shade400, size: 40),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Powered by ',
                      style: GoogleFonts.openSans().copyWith(fontSize: 12),
                    ),
                    Image.asset(
                      'assets/images/logo-removebg-preview.png',
                      width: 70,
                    ),
                    Text(
                      ' © ${DateTime.now().year}',
                      style: GoogleFonts.openSans().copyWith(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 25)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
