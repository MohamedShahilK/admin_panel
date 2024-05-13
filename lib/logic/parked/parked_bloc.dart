// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:admin_panel/models/new/actions/checkin/checkin_responce_model.dart';
import 'package:admin_panel/models/new/actions/image_upload/image_upload_form_response_model.dart';
import 'package:admin_panel/models/new/actions/image_upload/post_image_upload_response_model.dart';
import 'package:admin_panel/models/new/actions/ticket_models/ticket_details_response_model.dart';
import 'package:admin_panel/services/actions/actions_services.dart';

class ParkedBloc {
  ParkedBloc() {
    initDetails();
  }
  final brandStream = BehaviorSubject<String>.seeded('');
  final brandIdStream = BehaviorSubject<int?>();
  final colorStream = BehaviorSubject<String>.seeded('');
  final colorIdStream = BehaviorSubject<int?>();
  final driverStream = BehaviorSubject<String>.seeded('');
  final driverIdStream = BehaviorSubject<int?>();
  final imageListStream = BehaviorSubject<Map<String, List<XFile?>>>.seeded({});

  final sourceStream = BehaviorSubject<String>.seeded('');
  final sourceIdStream = BehaviorSubject<int?>();
  final vechicleNumberStream = BehaviorSubject<String>.seeded('');
  final codeStream = BehaviorSubject<String>.seeded('');
  final remarkStream = BehaviorSubject<String>.seeded('');
  // final vechicleNumberIdStream = BehaviorSubject<int>.seeded(0);

  final parkingSlotStream = BehaviorSubject<String>.seeded('');

  final guestNameStream = BehaviorSubject<String>.seeded('');
  final guestNumberStream = BehaviorSubject<String>.seeded('');
  final guestNotesStream = BehaviorSubject<String>.seeded('');

  final ticketDetailsResponse = BehaviorSubject<TicketDetailsResponseModel?>();
  final checkInSubmitResponse = BehaviorSubject<CheckInSubmitResponseModel?>();

  final getImageUploadFormResponse = BehaviorSubject<ImageUploadFormResponseModel?>();

  Future<void> initDetails() async {}

  // get Ticket details
  Future<void> getTicketDetails({required String ticketNumber}) async {
    final respModel = await ActionsServices().getTicketDetails(ticketNumber: ticketNumber);
    print('444444444444444 ${respModel}');
    ticketDetailsResponse.add(respModel);
  }

  // Check In SubmitEdit
  Future<void> checkInSubmitEdit(
    BuildContext context, {
    required String ticketNumber,
  }) async {
    print('2222222222222222222222222222222');
    checkInSubmitResponse.add(null);
    if (ticketDetailsResponse.value != null) {
      print('Brand Id : ${parkingSlotStream.value}');
      if (ticketDetailsResponse.value!.data!.ticketInfo != null && ticketDetailsResponse.value!.data!.ticketInfo!.isNotEmpty) {
        final respModel = await ActionsServices().checkInSubmitEdit(
          context,
          ticketNumber: ticketNumber,
          id: ticketDetailsResponse.value!.data!.ticketInfo![0].id!,
          colorId: colorIdStream.valueOrNull,
          driverId: driverIdStream.valueOrNull,
          modelId: brandIdStream.valueOrNull,
          vechicleNumber: '${codeStream.valueOrNull}${vechicleNumberStream.valueOrNull}',
          vechicleNumberId: sourceIdStream.valueOrNull,
          slot: parkingSlotStream.valueOrNull,
          guestName: guestNameStream.valueOrNull,
          guestPhoneNumber: guestNumberStream.valueOrNull,
          guestNotes: guestNotesStream.valueOrNull,
        );
        checkInSubmitResponse.add(respModel);
      }
      // //print(respModel!.data.ticketInfo.vehicleModel);
    }
  }

  Future<void> getImageUploadForm({required int ticketId}) async {
    final respModel = await ActionsServices().getImageUploadForm(ticketId: ticketId);
    getImageUploadFormResponse.add(respModel);
  }

  Future<PostUploadImageResponseModel?> postUploadImageIntoServer({required int ticketId, required int? vechiclePartId, required String remark, required File file}) async {
    final respModel = await ActionsServices().postUploadImageIntoServer(ticketId: ticketId, vechiclePartId: vechiclePartId, remark: remark, file: file);
    return respModel;
  }

  Future<bool> ticketHavingSamePlateNumberExcludeCheckOut({required int emirates, required String vehicleNumber}) async {
    final respModel = await ActionsServices().ticketHavingSamePlateNumberExcludeCheckOut(vehicleNumber: vehicleNumber, emirates: emirates);

    if (respModel == null) return false;

    final isNotEmpty = respModel.data?.totalRecords != 0;

    print('totalRecords : ${respModel.data?.totalRecords}');
    if (respModel.data!.ticketsList!.isNotEmpty) {
      print('barcode : ${respModel.data?.ticketsList?.first.barcode}');
      print('emiratesName : ${respModel.data?.ticketsList?.first.emiratesName}');
      print('emiratesName : ${respModel.data?.ticketsList?.first.emirates}');
    }
    print('isNotEmpty : $isNotEmpty');

    return isNotEmpty;
  }

  Future<Map<String, dynamic>?> deleteImage({required String ticketId, required String imageId}) async {
    final mapData = await ActionsServices().deleteImage(ticketId: ticketId, imageId: imageId);
    return mapData;
  }

  void clearStreams() {
    brandStream.add('');
    colorStream.add('');
    driverStream.add('');
    brandIdStream.add(null);
    colorIdStream.add(null);
    driverIdStream.add(null);
    imageListStream.add({});

    sourceStream.add('');
    sourceIdStream.add(null);
    vechicleNumberStream.add('');
    codeStream.add('');
    remarkStream.add('');
    parkingSlotStream.add('');
    guestNameStream.add('');
    guestNumberStream.add('');
    guestNotesStream.add('');
    // ticketDetailsResponse.add(null);
    // checkInSubmitResponse.add(null);
    // getImageUploadFormResponse.add(null);
  }

  void dispose() {
    brandStream.close();
    colorStream.close();
    driverStream.close();
    brandIdStream.close();
    colorIdStream.close();
    driverIdStream.close();
    imageListStream.close();

    sourceStream.close();
    sourceIdStream.close();
    vechicleNumberStream.close();
    codeStream.close();
    remarkStream.close();
    parkingSlotStream.close();
    guestNameStream.close();
    guestNumberStream.close();
    guestNotesStream.close();
    ticketDetailsResponse.close();
    checkInSubmitResponse.close();
    getImageUploadFormResponse.close();
  }
}
