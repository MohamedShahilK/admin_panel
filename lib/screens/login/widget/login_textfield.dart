// ignore_for_file: public_member_api_docs, sort_constructors_first, lines_longer_than_80_chars
import 'package:admin_panel/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';



final formKeyForReqOperatorId = GlobalKey<FormState>();
final formKeyForLogin = GlobalKey<FormState>();

class LoginTextField extends StatefulWidget {
  const LoginTextField({
    required this.textStream,
    // required this.controller,
    required this.hintText,
    required this.icon,
    this.suffixIcon,
    super.key,
    this.isObscure = false,
    this.enabled = true,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.onChanged,
  });
  final BehaviorSubject<String> textStream;
  // final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isObscure;
  final bool enabled;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final void Function(String)? onChanged;

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {

  final _controller = TextEditingController();
  @override
  void initState() {
    widget.textStream.listen((value) {
      if (value.isEmpty) {
        _controller.clear();
      } else if (_controller.text != value) {
       _controller.text = value;
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
  print('1111111111111111111111 ${_controller.text}');
    return StreamBuilder(
      stream: widget.textStream,
      builder: (context, snapshot) {
        return Padding(
          // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
          child: SizedBox(
            // height: 40,
            child: TextFormField(
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              style: TextStyle(color: Colors.grey[500]),
              cursorColor: secondaryColor,
              controller: _controller,
              validator: widget.validator,
              obscuringCharacter: '*',
              obscureText: widget.isObscure,
              enabled: widget.enabled,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(20),
                  // borderSide: BorderSide(color: AppColors.loginBorderColor!),
                  borderSide: BorderSide(color: Colors.purple.withOpacity(.1)),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(20),
                  // borderSide: BorderSide(color: AppColors.loginBorderColor!),
                  borderSide: BorderSide(color: Colors.purple.withOpacity(.1)),
                  borderRadius: BorderRadius.circular(5),
                ),
                disabledBorder: OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(20),
                  // borderSide: BorderSide(color: AppColors.loginBorderColor!),
                  borderSide: BorderSide(color: Colors.purple.withOpacity(.1)),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(20),
                  // borderSide: BorderSide(color: AppColors.focusedBorderColor),
                  // borderSide: BorderSide(color: Colors.grey[400]!),
                  borderSide: BorderSide(color: Colors.purple[700]!),
                  borderRadius: BorderRadius.circular(5),
                ),
                errorBorder: OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(20),
                  // borderSide: BorderSide(color: AppColors.focusedBorderColor),
                  // borderSide: BorderSide(color: Colors.grey[400]!),
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(5),
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey[500]),
                // hintStyle:
                //     AppStyles.loginHintTextStyle.copyWith(color: Colors.blue[900]),
                labelText: widget.hintText,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // color: Colors.grey[100],
                        // border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 18,
                        // color: AppColors.loginPrefixIconColor,
                        color: Colors.purple.withOpacity(.7),
                      ),
                    ),
                  ],
                ),
                suffixIcon: widget.suffixIcon,
              ),
            ),
          ),
        );
      },
    );
  }
}
