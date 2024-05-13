// ignore_for_file: lines_longer_than_80_chars

import 'package:admin_panel/utils/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:admin_panel/models/new/account/change_pass_response_model.dart';
import 'package:admin_panel/models/new/account/token_details_response_model.dart';
import 'package:admin_panel/services/account/account_services.dart';


class AccountBloc {
  AccountBloc() {
    initDetails();
  }
  final tokenDetailsResponseStream = BehaviorSubject<GetTokenDetailsResponse?>();
  final currentPasswordStream = BehaviorSubject<String>.seeded('');
  final newPasswordStream = BehaviorSubject<String>.seeded('');
  final confirmPasswordStream = BehaviorSubject<String>.seeded('');

  final currentPasswordStreamError = BehaviorSubject<String>.seeded('');
  final newPasswordStreamError = BehaviorSubject<String>.seeded('');
  final confirmPasswordStreamError = BehaviorSubject<String>.seeded('');

  Future<void> initDetails() async {
    await getTokenDetails();
  }

  // Future<bool> checkValidation() async {
  //   final minValue = StorageServices.to.getInt(StorageServicesKeys.minValue);
  //   final maxValue = StorageServices.to.getInt(StorageServicesKeys.maxValue);
  //   var isValid = true;
  //   if (barcodeStream.value.isEmpty) {
  //     isValid = false;
  //     barcodeStreamError.add('Please provide barcode');
  //   } else if (barcodeStream.value.length < minValue) {
  //     isValid = false;
  //     barcodeStreamError.add('Please enter atleast $minValue digit barcode');
  //   } else if (barcodeStream.value.length > maxValue) {
  //     isValid = false;
  //     barcodeStreamError.add('Maximum Length Exceeded ($maxValue in length)');
  //   } else {
  //     barcodeStreamError.add('');
  //   }
  //   return isValid;
  // }

  Future<bool> checkValidation() async {
    var isValid = true;

    if (currentPasswordStream.value.isEmpty) {
      isValid = false;
      currentPasswordStreamError.add('Please Provide Current Password');
    }
    if (newPasswordStream.value.isEmpty) {
      isValid = false;
      newPasswordStreamError.add('Please Provide New Password');
    } // lENGTH
    else if (newPasswordStream.value.isNotEmpty && newPasswordStream.value.length < 6) {
      isValid = false;
      newPasswordStreamError.add('New password minimum length is 6');
    } // lENGTH

    else {
      newPasswordStreamError.add('');
    }
    if (confirmPasswordStream.value.isEmpty) {
      isValid = false;
      confirmPasswordStreamError.add('Please Confirm New Password');
    }

    // lENGTH
    else if (newPasswordStream.value.length < 6) {
      isValid = false;
      newPasswordStreamError.add('New password minimum length is 6');
    }
    // lENGTH

    if (currentPasswordStream.value.isNotEmpty) {
      currentPasswordStreamError.add('');
    }
    // if (newPasswordStream.value.isNotEmpty) {
    //   newPasswordStreamError.add('');
    // }
    if (confirmPasswordStream.value.isNotEmpty) {
      confirmPasswordStreamError.add('');
    }

    return isValid;
  }

  Future<void> getTokenDetails() async {
    final respModel = await AccountServices().getTokenDetails();
    tokenDetailsResponseStream.add(respModel);
    if (respModel != null && respModel.data != null && respModel.data!.isNotEmpty) {
      await StorageServices.to.setString('operatorId', respModel.data![0].operatorId ?? '');
      await StorageServices.to.setString('userType', respModel.data![0].userCategory ?? '');
      await StorageServices.to.setString('locationName', respModel.data![0].locationName ?? '');
      final userType = StorageServices.to.getString('userType');
      // print('dddddddddddddddddddddddddddddddddddddddddddd $userType');
      String userCat = userType == 'ADMIN' ? 'A' : userType;
      if (userCat != 'A') {
        await StorageServices.to.setInt('locationId', respModel.data![0].locationId ?? 0);
      }
      print('locccccccccccccccccccccccc : ${StorageServices.to.getString('locationName')}');
    }
  }

  Future<ChangePasswordResponseModel?> changePassword(
    BuildContext context, {
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final respModel = await AccountServices().changePassword(context, currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword);
    return respModel;
  }

  void dispose() {
    tokenDetailsResponseStream.close();
    currentPasswordStream.close();
    newPasswordStream.close();
    confirmPasswordStream.close();
    currentPasswordStreamError.close();
    newPasswordStreamError.close();
    confirmPasswordStreamError.close();
  }
}
