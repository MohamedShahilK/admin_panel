// ignore_for_file: unawaited_futures, use_build_context_synchronously, inference_failure_on_instance_creation, lines_longer_than_80_chars

import 'dart:io';
import 'package:admin_panel/controllers/dashboard_tab_controller.dart';
import 'package:admin_panel/logic/account/account_bloc.dart';
import 'package:admin_panel/logic/actions/actions_bloc.dart';
import 'package:admin_panel/logic/auth/auth_bloc.dart';
import 'package:admin_panel/logic/dashboard/dashboard_bloc.dart';
import 'package:admin_panel/logic/notification/notification_bloc.dart';
import 'package:admin_panel/logic/search/search_bloc.dart';
import 'package:admin_panel/screens/dashboard/dashboard_screen.dart';
import 'package:admin_panel/screens/login/widget/glass_morphism.dart';
import 'package:admin_panel/screens/login/widget/login_textfield.dart';
import 'package:admin_panel/services/auth/auth_services.dart';
import 'package:admin_panel/utils/constants.dart';
import 'package:admin_panel/utils/custom_tools.dart';
import 'package:admin_panel/utils/ripple.dart';
import 'package:admin_panel/utils/storage_services.dart';
import 'package:admin_panel/utils/string_constants.dart';
import 'package:admin_panel/utils/utility_functions.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final isPasswordObscure = ValueNotifier(true);
final selectedCountryFromLoginNotifier = ValueNotifier('');

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with RouteAware {
  bool isLoading = false;
  // final email = TextEditingController();
  String isValidString = '';

  bool isShifted = false;

  @override
  void initState() {
    super.initState();
    print('inittttttttttttttttttttttttttttttttt');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Loader.hide();
    });
  }

  // @override
  // void didPush() {
  //   super.didPush();
  //   print('qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
  //   Loader.hide();
  // }

  // @override
  // void didPushNext() {
  //   super.didPushNext();
  //   print('wwwwwwwwwwwwwwwwwwwwwwwwwwwwww');
  //   Loader.hide();
  // }

  // @override
  // void didPop() {
  //   super.didPop();
  //   print('ttttttttttttttttttttttt');
  //   Loader.hide();
  // }

  // @override
  // void didPopNext() {
  //   super.didPopNext();
  //   print('yyyyyyyyyyyyyyyyyyyyyyyy');
  //   Loader.hide();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value) ? 'Enter a valid email address' : null;
  }

  @override
  Widget build(BuildContext context) {
    // final authBloc = BlocProvider.of<AuthBloc>(context);
    final authBloc = Provider.of<AuthBloc>(context);
    // final state = authBloc.state;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return MediaQuery.withClampedTextScaling(
            minScaleFactor: 0.85, // set min scale value here
            maxScaleFactor: .95,
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.purple),
                borderRadius: BorderRadius.circular(15),
              ),
              actionsPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              iconPadding: const EdgeInsets.symmetric(horizontal: 12),
              buttonPadding: const EdgeInsets.symmetric(horizontal: 12),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              // insetPadding: EdgeInsets.only(
              //   bottom: 50,
              //   left: 15,
              //   right: 15,
              // ),
              titlePadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              title: const Text(
                'Exit',
                style: TextStyle(
                  fontSize: 13,
                  color: Color.fromARGB(255, 104, 0, 239),
                ),
              ),
              content: const Text(
                'Are you want to exit from app?',
                style: TextStyle(fontSize: 14),
              ),
              actions: <Widget>[
                SizedBox(
                  height: 35,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        // color: Color.fromARGB(255, 209, 174, 226),
                        color: Colors.transparent,
                      ),
                      // foregroundColor: const Color.fromARGB(255, 146, 80, 177),
                      backgroundColor: const Color.fromARGB(255, 146, 80, 177),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      if (Platform.isAndroid) {
                        // It is Ok
                        SystemNavigator.pop();
                      } else if (Platform.isIOS) {
                        // Warning: Do not call the exit function. Applications calling exit will appear to the user to have crashed, rather than performing a graceful termination and animating back to the Home screen.
                        exit(0);
                      }
                    },
                    child: const Text(
                      'Exit',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color.fromARGB(255, 209, 174, 226),
                      ),
                      // backgroundColor:
                      //     Color.fromARGB(255, 146, 80, 177),
                      foregroundColor: const Color.fromARGB(255, 146, 80, 177),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              filterQuality: FilterQuality.medium,
              colorFilter: ColorFilter.matrix(<double>[
                // R  G  B  A  Offset
                0.4, 0, 0, 0, 0, // Red channel
                0, 0.4, 0, 0, 0, // Green channel
                0, 0, 0.4, 0, 0, // Blue channel
                0, 0, 0, 1, 0, // Alpha channel
              ]),
              // colorFilter: ColorFilter.mode(
              //   Colors.deepPurpleAccent[100]!,
              //   BlendMode.darken,
              // ),
              image: AssetImage(
                // 'assets/images/car4.jpeg',
                // AppImages.car5,
                'assets/images/bg4.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            // backgroundColor: Colors.grey[300],
            body: SafeArea(
              child: Padding(
                // padding: const EdgeInsets.only(top: 50),
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Main Lock Icon
                    // Positioned(
                    //   top: 120,
                    //   left: MediaQuery.of(context).size.width / 2,
                    //   right: MediaQuery.of(context).size.width / 2,
                    //   child: const Icon(
                    //     Icons.lock,
                    //     color: AppColors.mainLockIconColor,
                    //     // color: Colors.black.withOpacity(.7),
                    //     size: 65,
                    //   ),
                    // ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          // horizontal: 40,
                          // vertical: 80,
                          horizontal: 20,
                          vertical: 25,
                        ),
                        child: GlassMorphism(
                          // child: _loginBody(context, authBloc),
                          child: isShifted ? _formForOperatorIdCreation(authBloc) : _loginBody(context, authBloc),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _formForOperatorIdCreation(AuthBloc authBloc) {
    // ignore: use_decorated_box
    return Container(
      // height: 400,
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 2,
        //     blurRadius: 5,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      child: Form(
        key: formKeyForReqOperatorId,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              // child: Image.asset('assets/logo.png'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Lock Icon
                  // Icon(
                  //   Icons.lock,
                  //   // color: AppColors.mainColor!.withOpacity(.5),
                  //   // color: Colors.white38,
                  //   color: AppColors.mainColor,
                  //   size: 35,
                  // ),
                  // SizedBox(width: 5),

                  // Logo
                  SizedBox(
                    width: 240,
                    child: Image(
                      // image: AssetImage(AppImages.appLogo),
                      image: AssetImage(
                        // 'assets/images/logo-removebg-preview.png',
                        'assets/images/new_logo-removebg-preview.png',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // TextFields
            LoginTextField(
              enabled: !isLoading,
              // controller: operatorIdController,
              onChanged: authBloc.nameStream.add,
              textStream: authBloc.nameStream,
              hintText: 'Name',
              // keyboardType: TextInputType.number,
              icon: Icons.person_2_outlined,
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Name is required';
                } else if (input.length < 5) {
                  return 'Name atleast contains 5 letters';
                }
                return null;
              },
            ),

            LoginTextField(
              enabled: !isLoading,
              onChanged: authBloc.companyEmailStream.add,
              textStream: authBloc.companyEmailStream,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Email',
              icon: Icons.email_outlined,
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Company Email is required';
                }
                return validateEmail(input);
              },
            ),

            LoginTextField(
              enabled: !isLoading,
              onChanged: authBloc.companyPhoneStream.add,
              textStream: authBloc.companyPhoneStream,
              keyboardType: TextInputType.phone,
              hintText: 'Mobile Number',
              icon: Icons.phone_android_outlined,
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Company Phone is required';
                } else if (input.length < 7) {
                  return 'Company Phone atleast contains 7 digits';
                }
                return null;
              },
            ),

            LoginTextField(
              enabled: !isLoading,
              onChanged: authBloc.companyNameStream.add,
              textStream: authBloc.companyNameStream,
              hintText: 'Company Name',
              icon: Icons.account_balance_outlined,
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Company Name is required';
                } else if (input.length < 5) {
                  return 'Company Name atleast contains 5 letters';
                }
                return null;
              },
              // validator: (input) {
              //   if (input == null || input.isEmpty) {
              //     return 'Company Name is required';
              //   }
              //   return null;
              // },
            ),

            // LoginTextField(
            //   enabled: !isLoading,
            //   onChanged: authBloc.countryStream.add,
            //   textStream: authBloc.countryStream,
            //   hintText: 'Country',
            //   icon: FontAwesomeIcons.earthAsia,
            //   // validator: (input) {
            //   //   if (input == null || input.isEmpty) {
            //   //     return 'Country is required';
            //   //   }
            //   //   return null;
            //   // },
            // ),

            InkWell(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                showCountryPicker(
                  context: context,
                  // countryFilter: ['AE', 'KW', 'SA'],
                  countryListTheme: CountryListThemeData(
                    flagSize: 25,
                    backgroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                    bottomSheetHeight: 500, // Optional. Country list modal height
                    //Optional. Sets the border radius for the bottomsheet.
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    //Optional. Styles the search field.
                    inputDecoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Start typing to search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color(0xFF8C98A8).withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                  // showPhoneCode: false, // optional. Shows phone code before the country name.
                  onSelect: (Country country) {
                    // print('Select country: ${country.displayName}');
                    // selectedCountryFromLoginNotifier.value = country.displayNameNoCountryCode;
                    selectedCountryFromLoginNotifier.value = country.displayName;
                    selectedCountryFromLoginNotifier.notifyListeners();
                  },
                );
              },
              child: Container(
                alignment: Alignment.center,
                // margin: EdgeInsets.only(top: 12),
                margin: const EdgeInsets.only(left: 15, right: 15, top: 12),
                // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                decoration: BoxDecoration(
                  // color: Colors.white,
                  // border: Border.all(color: Colors.grey[300]!),
                  border: Border.all(color: Colors.purple.withOpacity(.1)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ValueListenableBuilder(
                  valueListenable: selectedCountryFromLoginNotifier,
                  builder: (context, countryVal, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.earthAsia,
                          size: 18,
                          // color: AppColors.loginPrefixIconColor,
                          color: Colors.purple.withOpacity(.7),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          countryVal == '' ? 'Select Country' : countryVal,
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Login Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 90),
                    decoration: const BoxDecoration(
                        // color: Colors.grey[100],
                        // border: Border(
                        //   top: BorderSide(color: Colors.grey[300]!),
                        // ),
                        ),
                    child: GestureDetector(
                      onTap: () async {
                        // if (formKeyForReqOperatorId.currentState == null) {
                        //   return;
                        // }

                        // // final isValid = formKeyForReqOperatorId.currentState!.validate();
                        // final isValid = formKeyForReqOperatorId.currentState!.validate();
                        // FocusScope.of(context).requestFocus(FocusNode());

                        // if (isValid) {
                        //   customLoader(context);

                        //   if (selectedCountryFromLoginNotifier.value == '') {
                        //     erroMotionToastInfo(context, msg: 'Forget to select your country');
                        //     Loader.hide();
                        //     return;
                        //   }
                        //   print('object ${authBloc.companyEmailStream.value.trim()}');
                        //   // final Email email = Email(
                        //   //   body: 'Email body',
                        //   //   subject: 'Email subject',
                        //   //   recipients: ['example@example.com'],
                        //   //   cc: ['cc@example.com'],
                        //   //   bcc: ['bcc@example.com'],
                        //   //   // attachmentPaths: ['/path/to/attachment.zip'],
                        //   //   isHTML: false,
                        //   // );selectedCountryFromLoginNotifier

                        //   // await FlutterEmailSender.send(email);

                        //   // Replace these values with your SMTP server configuration

                        //   // final smtpServer = SmtpServer(
                        //   //   'sandbox.smtp.mailtrap.io',
                        //   //   username: '0b5cc3f120e3bc',
                        //   //   password: '6d4936dd405a43',
                        //   //   port: 2525, // Usually 587 for TLS
                        //   //   // ssl: true, // Set to true if your server requires SSL
                        //   //   // tls: true, // Set to false if your server does not support STARTTLS
                        //   // );

                        //   final smtpServer = SmtpServer(
                        //     'mail.varletpark.com',
                        //     username: 'info@varletpark.com',
                        //     password: 'v@rlet@123',
                        //     port: 465, // Usually 587 for TLS
                        //     ssl: true,
                        //     // ssl: true, // Set to true if your server requires SSL
                        //     // tls: true, // Set to false if your server does not support STARTTLS
                        //   );

                        //   // var nameFromSomeInput = 'Jane Doe';
                        //   // var yourHtmlTemplate = '<html>Dear {{NAME}}</html>';
                        //   // message.html = yourHtmlTemplate.replaceAll('{{NAME}}', nameFromSomeInput);

                        //   // Create a message
                        //   final message = Message()
                        //     // ..from = Address('shahil.k007@gmail.com', 'Shahil')
                        //     ..from = Address(authBloc.companyEmailStream.value.trim(), authBloc.nameStream.value)
                        //     // ..from = Address('shahil.k007@gmail.com', authBloc.nameStream.value)
                        //     ..recipients.add('info@varletpark.com')
                        //     // ..recipients.addAll(['info@varletpark.com','virtualshahil@gmail.com'])
                        //     ..subject = 'New Enquiry From Varlet Parking App'
                        //     ..html = '''
                        //               <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                        //               $html
                        //               </html>'''
                        //         // .replaceAll('{{NAME}}', 'Jane Doe')
                        //         .replaceAll('{{NAME}}', authBloc.nameStream.value)
                        //         // .replaceAll('{{COMPANY_NAME}}', 'Arabinfotec')
                        //         .replaceAll('{{COMPANY_NAME}}', authBloc.companyNameStream.value)
                        //         // .replaceAll('{{EMAIL}}', 'Shahil.k007@gmail.com')
                        //         .replaceAll('{{EMAIL}}', authBloc.companyEmailStream.value)
                        //         // .replaceAll('{{PHONE_NUMBER}}', '+971151615647')
                        //         .replaceAll('{{PHONE_NUMBER}}', authBloc.companyPhoneStream.value)
                        //         // .replaceAll('{{COUNTRY}}', 'United Arab Emirates');
                        //         // .replaceAll('{{COUNTRY}}', authBloc.countryStream.value);
                        //         .replaceAll('{{COUNTRY}}', selectedCountryFromLoginNotifier.value);

                        //   try {
                        //     final sendReport = await send(message, smtpServer).then((value) {
                        //       Loader.hide();
                        //       authBloc.emailStream.add('');
                        //       authBloc.passwordStream.add('');
                        //       authBloc.operatorIdStream.add('');
                        //       authBloc.nameStream.add('');
                        //       authBloc.companyEmailStream.add('');
                        //       authBloc.companyNameStream.add('');
                        //       authBloc.companyPhoneStream.add('');
                        //       authBloc.countryStream.add('');
                        //       return successMotionToastInfo(context, msg: 'Email Send Successfully. We will Contact you soon.');
                        //     });
                        //     // print('Message sent: ${sendReport.sent}');
                        //   } on MailerException catch (e) {
                        //     print('Message not sent. ${e.message}');
                        //     for (var p in e.problems) {
                        //       print('Problem: ${p.code}: ${p.msg}');
                        //     }
                        //     Loader.hide();
                        //     return erroMotionToastInfo(context, msg: 'Email Failed To Send!');
                        //   } on SocketException catch (e) {
                        //     print('SocketException: ${e.message}');
                        //     Loader.hide();
                        //     return erroMotionToastInfo(context, msg: 'Email Failed To Send!');
                        //   }
                        //   Loader.hide();
                        // }
                      },
                      child: Container(
                        height: 35,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isLoading ? Colors.grey : secondaryColor,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[600]!,
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isLoading)
                              Container(
                                width: 24,
                                height: 24,
                                padding: const EdgeInsets.all(2),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            else
                              const Icon(Icons.lock, size: 20, color: Colors.white70),
                            const SizedBox(width: 5),
                            const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //  SizedBox(height: 10),

                  // Back to login
                  InkWell(
                    onTap: () {
                      setState(() {
                        // formKeyForReqOperatorId.currentState!.deactivate();
                        // authBloc.nameController.value.text = '';
                        // authBloc.companyNameController.value.text = '';
                        // authBloc.companyEmailController.value.text = '';
                        // authBloc.companyPhoneController.value.text = '';
                        // authBloc.countryController.value.text = '';
                        authBloc.nameStream.add('');
                        authBloc.companyNameStream.add('');
                        authBloc.companyEmailStream.add('');
                        authBloc.companyPhoneStream.add('');
                        authBloc.countryStream.add('');

                        authBloc.operatorIdStream.add('');
                        authBloc.emailStream.add('');
                        authBloc.passwordStream.add('');
                        isShifted = !isShifted;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      child: Text(
                        'Go Back To Login',
                        style: GoogleFonts.openSans().copyWith(
                          fontSize: 12,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Powered by ',
                  style: GoogleFonts.openSans().copyWith(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                Image.asset(
                  'assets/images/logo-removebg-preview.png',
                  width: 70,
                ),
                Text(
                  ' © ${DateTime.now().year}',
                  style: GoogleFonts.openSans().copyWith(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _loginBody(
    BuildContext context,
    // AuthState state,
    AuthBloc authBloc,
  ) {
    // final operatorIdController = TextEditingController();
    return Builder(
      builder: (context) {
        return Container(
          // width: MediaQuery.of(context).size.width ,

          // height: 300,
          // height: isValidString == 'valid' ? 455.h : 400,
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5),
            //     spreadRadius: 2,
            //     blurRadius: 5,
            //     offset: const Offset(0, 3),
            //   ),
            // ],
          ),
          child: Form(
            key: formKeyForLogin,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  // child: Image.asset('assets/logo.png'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Lock Icon
                      // Icon(
                      //   Icons.lock,
                      //   // color: AppColors.mainColor!.withOpacity(.5),
                      //   // color: Colors.white38,
                      //   color: AppColors.mainColor,
                      //   size: 35,
                      // ),
                      // SizedBox(width: 5),

                      // Logo
                      SizedBox(
                        width: 240,
                        child: Image(
                          // image: AssetImage(AppImages.appLogo),
                          image: AssetImage(
                            // 'assets/images/logo-removebg-preview.png',
                            'assets/images/new_logo-removebg-preview.png',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // TextFields

                LoginTextField(
                  enabled: !isLoading,
                  // controller: operatorIdController,
                  onChanged: authBloc.operatorIdStream.add,
                  textStream: authBloc.operatorIdStream,
                  keyboardType: TextInputType.visiblePassword,
                  hintText: 'Operator Id',
                  // keyboardType: TextInputType.number,
                  icon: Icons.security_rounded,
                  validator: (input) {
                    if (input == null || input.isEmpty) {
                      return 'Operator is required';
                    }
                    return null;
                  },
                ),

                LoginTextField(
                  keyboardType: TextInputType.visiblePassword,
                  enabled: !isLoading,
                  onChanged: authBloc.emailStream.add,
                  textStream: authBloc.emailStream,
                  hintText: 'Username',
                  icon: Icons.person,
                  validator: (input) {
                    if (input == null || input.isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),

                ValueListenableBuilder(
                  valueListenable: isPasswordObscure,
                  builder: (context, isObscure, _) {
                    return LoginTextField(
                      enabled: !isLoading,
                      onChanged: authBloc.passwordStream.add,
                      isObscure: isPasswordObscure.value,
                      textStream: authBloc.passwordStream,
                      hintText: 'Password',
                      icon: Icons.key_sharp,
                      suffixIcon: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 40,
                        child: Icon(
                          isPasswordObscure.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          size: 18,
                          // color: AppColors.loginPrefixIconColor,
                          color: Colors.blue[900],
                        ),
                      ).ripple(context, () {
                        isPasswordObscure.value = !isPasswordObscure.value;
                        isPasswordObscure.notifyListeners();
                      }),
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    );
                  },
                ),

                // Forgot Password
                // Padding(
                //   padding: const EdgeInsets.only(top: 5, right: 20),
                //   child: Align(
                //     alignment: Alignment.centerRight,
                //     child: Text(
                //       'Forgot Password?',
                //       style: TextStyle(
                //         fontSize: 13,
                //         color: AppColors.loginForgotPasswordColor,
                //       ),
                //     ),
                //   ),
                // ),

                // const Spacer(),

                // Login Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 90),
                        decoration: const BoxDecoration(
                            // color: Colors.grey[100],
                            // border: Border(
                            //   top: BorderSide(color: Colors.grey[300]!),
                            // ),
                            ),
                        child: GestureDetector(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());

                            if (isLoading) return;

                            if (formKeyForLogin.currentState == null) {
                              return;
                            }

                            // final isValid = formKeyForLogin.currentState!.validate();
                            final isValid = formKeyForLogin.currentState!.validate();
                            setState(() {
                              isValidString = 'valid';
                            });

                            if (isValid) {
                              setState(() {
                                isValidString = '';
                              });

                              // customLoader(context);
                              setState(() {
                                isLoading = true;
                              });
                              Future.delayed(
                                const Duration(seconds: 2),
                                () async {
                                  final dashBloc = Provider.of<DashboardBloc>(context, listen: false);
                                  final dashTabController = Provider.of<DashBoardTabController>(context, listen: false);
                                  final email = authBloc.emailStream.value;
                                  final pass = authBloc.passwordStream.value;
                                  final operatorId = authBloc.operatorIdStream.value;

                                  final authResp = await AuthServices().login(
                                    context,
                                    // username: email.text,
                                    // password: pass.text,
                                    // operatorId: operatorId.text,
                                    username: email,
                                    password: pass,
                                    operatorId: operatorId,
                                  );

                                  if (authResp != null && authResp.status == 'OK' && authResp.message == 'Login success') {
                                    final token = authResp.data.token;

                                    // Saving token in to SharedPreference
                                    await StorageServices.to.setString(
                                      StorageServicesKeys.token,
                                      token,
                                    );
                                    // Saving token in to SharedPreference

                                    // final now = DateTime.now();
                                    // final todayStartDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
                                    // final todayEndDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

                                    // final formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(todayStartDate);
                                    // final formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(todayEndDate);

                                    await context.read<AccountBloc>().getTokenDetails();

                                    // Ignore Location Admin And Report User

                                    // if (StorageServices.to.getString('userType') == 'LA' || StorageServices.to.getString('userType') == 'R') {
                                    //   erroMotionToastInfo(context, msg: 'No Permission to login');

                                    //   AuthServices().logout();
                                    //   navigationItemIndex.value = 0;
                                    //   await StorageServices.to.remove('cvas');
                                    //   await StorageServices.to.remove('logoPath');
                                    //   await StorageServices.to.remove('locationId');
                                    //   await StorageServices.to.remove('locationName');
                                    //   await StorageServices.to.remove('operatorId');
                                    //   await StorageServices.to.remove('userType');
                                    //   await StorageServices.to.remove('userName');
                                    //   await StorageServices.to.remove('company_logo_file_path');
                                    //   await StorageServices.to.remove('appEndDate');
                                    //   await StorageServices.to.remove('curreny');
                                    //   await StorageServices.to.remove('timezone');
                                    //   navigationItemIndex.notifyListeners();

                                    //   setState(() {
                                    //     isLoading = false;
                                    //   });
                                    //   return;
                                    // }

                                    // Ignore Location Admin And Report User

                                    final operatorId = StorageServices.to
                                        .getString('operatorId')
                                        .trim()
                                        .replaceAll(' ', '')
                                        .replaceAll(',', '')
                                        .replaceAll(RegExp(r'[^\w\s]+'), '')
                                        .replaceAll(RegExp(r'\s+(?=\d)'), '')
                                        .replaceAll(RegExp(r'[\s,]+(?=\d)'), '');
                                    final userType = StorageServices.to.getString('userType');
                                    final locationName = StorageServices.to
                                        .getString('locationName')
                                        .trim()
                                        .replaceAll(' ', '')
                                        .replaceAll(',', '')
                                        .replaceAll(RegExp(r'[^\w\s]+'), '')
                                        .replaceAll(RegExp(r'\s+(?=\d)'), '')
                                        .replaceAll(RegExp(r'[\s,]+(?=\d)'), '');
                                    print('222222222222222222222222222 $locationName');

                                    String userCat = userType == 'ADMIN' ? 'A' : userType;

                                    // print('1111111111111111111111111111locationName $locationName$operatorId');

                                    if (userCat != 'A') {
                                      try {
                                        // await FirebaseMessaging.instance.subscribeToTopic('$locationName$operatorId').then((value) {
                                        //   // print('111111111111111111111222222222222222222222222223333333333333333333');
                                        // });
                                      } catch (e) {
                                        print('erorrrrrrrrrrrrrrrrrrrr $e');
                                        await erroMotionToastInfo(context, msg: "Can't able to subscribe the current firebase messaging.Please contact developer");
                                        Loader.hide();
                                        // return;
                                      }
                                    }

                                    await context.read<DashboardBloc>().getSettings();

                                    await context.read<SearchBloc>().getAllCheckInItems();
                                    await context.read<SearchBloc>().getAllTicketsWithPageNo(orderBy: 'parking_time', pageNo: 1);
                                    // await context.read<DashboardBloc>().getDashBoardWithTicket(pageNo: 1);
                                    // await context.read<DashboardBloc>().getDashBoardAllTicketsWithDate(pageNo: 1, startDate: formattedStartDate, endDate: formattedEndDate);

                                    // final now = DateTime.now();
                                    final now = DateTime.now().subtract(UtilityFunctions.convertLocalToDubaiTime());

                                    // final endDate = DateTime(now.year, now.month, now.day, 0, 0, 0);

                                    // Calculate the first date of the 3-day period
                                    final startDate = now.subtract(const Duration(days: 3));

                                    final formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate);
                                    final formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

                                    await context.read<DashboardBloc>().getDashBoardAllTicketsWithDate(pageNo: 1, startDate: formattedStartDate, endDate: formattedEndDate);

                                    currentPageForDashBoardPage.value = 1;
                                    currentPageForDashBoardPage.notifyListeners();
                                    dashTabController.setMenuName('Current Inventory');
                                    dashBloc.state.filterDate.add('Last 3 Days');

                                    await context.read<ActionsBloc>().getAllCheckInItems();
                                    await context.read<DashboardBloc>().getCarBrands();

                                    // // To refresh notification count in bottom navigation bar
                                    await context.read<NotificationBloc>().getRequestedTickets(orderBy: 'id');
                                    await context.read<NotificationBloc>().getOntheWayTickets(orderBy: 'id');

                                    await context.read<DashboardBloc>().getCheckInTickets(orderBy: 'id', pageNo: 1);
                                    await context.read<DashboardBloc>().getCheckOutTickets(orderBy: 'id', pageNo: 1);
                                    await context.read<DashboardBloc>().getRequestedTickets(orderBy: 'id', pageNo: 1);
                                    await context.read<DashboardBloc>().getOntheWayTickets(orderBy: 'id', pageNo: 1);
                                    await context.read<DashboardBloc>().getCollectNowTickets(orderBy: 'id', pageNo: 1);
                                    await context.read<DashboardBloc>().getParkedTickets(orderBy: 'id', pageNo: 1);

                                    if (userCat == 'A' || userCat == 'ADMIN') {
                                      await context.read<DashboardBloc>().getAllTickets(orderBy: 'id');
                                    }

                                    await context.read<ActionsBloc>().getAllPermissions();
                                    final locationId = StorageServices.to.getInt('locationId');
                                    await context.read<DashboardBloc>().getPrintingSettingsAndHeader(locationId: locationId);

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      // MaterialPageRoute(
                                      //   // builder: (context) => const DashBoard(),
                                      //   // builder: (context) => const CustomDrawer(),
                                      //   builder: (context) => UpgradeAlert(
                                      //     dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material,
                                      //     showIgnore: false,
                                      //     upgrader: Upgrader(durationUntilAlertAgain: const Duration(seconds: 2)),
                                      //     child: const NavigationPage(),
                                      //   ),
                                      // ),

                                      //   PageRouteBuilder(
                                      //     pageBuilder: (context, animation, secondaryAnimation) => UpgradeAlert(
                                      //       dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material,
                                      //       showIgnore: false,
                                      //       upgrader: Upgrader(durationUntilAlertAgain: const Duration(seconds: 2)),
                                      //       child: const NavigationPage(),
                                      //     ),
                                      //     transitionDuration: const Duration(milliseconds: 400),
                                      //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      //       return FadeTransition(
                                      //         opacity: animation,
                                      //         child: child,
                                      //       );
                                      //     },
                                      //   ),
                                      //   (route) => false,
                                      // );
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
                                      (route) => false,
                                    );
                                    // await toastInfo(
                                    //   msg: 'Login Successfully',
                                    //   gravity: ToastGravity.BOTTOM,
                                    //   backgroundColor: Colors.green,
                                    // );
                                    // MotionToast.success(
                                    //   title: Text('Login Successfully', style: TextStyle(fontSize: 12)),
                                    //   description: const Text(''),
                                    //   height: 40,
                                    //   width: 300,
                                    //   iconSize: 23,
                                    //   animationType: AnimationType.fromLeft,
                                    //   animationDuration: const Duration(milliseconds: 800),
                                    // ).show(context);

                                    // StorageServices.to.setString('operatorId', authBloc.operatorIdController.value.text);
                                    // authBloc.emailController.value.text = '';
                                    // authBloc.passwordController.value.text = '';
                                    // authBloc.operatorIdController.value.text = '';
                                    // authBloc.nameController.value.text = '';
                                    // authBloc.companyNameController.value.text = '';
                                    // authBloc.companyEmailController.value.text = '';
                                    // authBloc.companyPhoneController.value.text = '';
                                    // authBloc.countryController.value.text = '';
                                    StorageServices.to.setString('operatorId', authBloc.operatorIdStream.value);
                                    authBloc.emailStream.add('');
                                    authBloc.passwordStream.add('');
                                    authBloc.operatorIdStream.add('');
                                    authBloc.nameStream.add('');
                                    authBloc.companyEmailStream.add('');
                                    authBloc.companyNameStream.add('');
                                    authBloc.companyPhoneStream.add('');
                                    authBloc.countryStream.add('');
                                    successMotionToastInfo(context, msg: 'Login Successfully');
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    // await toastInfo(
                                    //   msg: 'Invalid Username or Password',
                                    //   gravity: ToastGravity.BOTTOM,
                                    // );
                                  }

                                  //
                                  // final email = state.emailController;
                                  // final pass = state.passwordController;
                                  // final userData =
                                  //     await LoginServices().getUserData();
                                  // if (email.value.text == userData.email &&
                                  //     pass.value.text == userData.password) {
                                  //   setState(() {
                                  //     isLoading = false;
                                  //   });
                                  //   await StorageServices.to.setBool(
                                  //     StorageServicesKeys.isLoginKey,
                                  //     true,
                                  //   );

                                  //   Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       // builder: (context) => const DashBoard(),
                                  //       // builder: (context) => const CustomDrawer(),
                                  //       builder: (context) =>
                                  //           const NavigationPage(),
                                  //     ),
                                  //   );
                                  //   // Loader.hide();
                                  // } else {
                                  //   setState(() {
                                  //     isLoading = false;
                                  //   });
                                  //   await toastInfo(
                                  //     msg: 'Invalid Username or Password',
                                  //   );
                                  // }
                                  // else{
                                  //   await toastInfo(msg: 'Invalid Username or Password');
                                  //   // Loader.hide();
                                  // }
                                },
                              );
                            }

                            // else {
                            //   customLoader(context);
                            //   await Future.delayed(
                            //     const Duration(seconds: 2),
                            //     () async {
                            //       await toastInfo(msg: 'Invalid Username or Password');
                            //     },
                            //   );
                            //   Loader.hide();
                            // }
                            // }
                            ;
                          },
                          child: Container(
                            height: 35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isLoading ? Colors.grey : secondaryColor,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[600]!,
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isLoading)
                                  Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.all(2),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                else
                                  const Icon(
                                    Icons.lock,
                                    size: 20,
                                    color: Colors.white70,
                                  ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // SizedBox(height: 10),

                      // Request For New Operator ID
                      InkWell(
                        onTap: () {
                          if (isLoading) return;
                          setState(() {
                            // authBloc.emailController.value.text = '';
                            // authBloc.passwordController.value.text = '';
                            // authBloc.operatorIdController.value.text = '';

                            authBloc.nameStream.add('');
                            authBloc.companyNameStream.add('');
                            authBloc.companyEmailStream.add('');
                            authBloc.companyPhoneStream.add('');
                            authBloc.countryStream.add('');

                            authBloc.operatorIdStream.add('');
                            authBloc.emailStream.add('');
                            authBloc.passwordStream.add('');

                            isShifted = !isShifted;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 25,
                          child: Text(
                            'Request For New Operator ID',
                            style: GoogleFonts.openSans().copyWith(
                              fontSize: 12,
                              color: isLoading ? Colors.grey : Colors.purple,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Powered by ',
                      style: GoogleFonts.openSans().copyWith(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    Image.asset(
                      'assets/images/logo-removebg-preview.png',
                      width: 70,
                    ),
                    Text(
                      ' © ${DateTime.now().year}',
                      style: GoogleFonts.openSans().copyWith(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
