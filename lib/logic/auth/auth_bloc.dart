// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
// ignore: unused_import
import 'package:admin_panel/models/new/actions/ticket_models/ticket_generation_settings_model.dart';

class AuthBloc {
  AuthBloc() {
    initDetails();
  }
  // final emailController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  // final passwordController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  // final operatorIdController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());

  // final nameController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  // final companyNameController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  // final companyEmailController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  // final companyPhoneController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());
  // final countryController = BehaviorSubject<TextEditingController>.seeded(TextEditingController());

  final emailStream = BehaviorSubject<String>.seeded('');
  final passwordStream = BehaviorSubject<String>.seeded('');
  final operatorIdStream = BehaviorSubject<String>.seeded('');

  final nameStream = BehaviorSubject<String>.seeded('');
  final companyNameStream = BehaviorSubject<String>.seeded('');
  final companyEmailStream = BehaviorSubject<String>.seeded('');
  final companyPhoneStream = BehaviorSubject<String>.seeded('');
  final countryStream = BehaviorSubject<String>.seeded('');

  Future<void> initDetails() async {}

  void dispose() {
    // emailController.close();
    // passwordController.close();
    // operatorIdController.close();
    emailStream.close();
    passwordStream.close();
    operatorIdStream.close();
    nameStream.close();
    companyNameStream.close();
    companyEmailStream.close();
    companyPhoneStream.close();
    countryStream.close();
  }
}
