// ignore_for_file: lines_longer_than_80_chars

import 'package:rxdart/rxdart.dart';
import 'package:admin_panel/logic/check_out/check_out_state.dart';
import 'package:admin_panel/models/new/actions/ticket_models/ticket_details_response_model.dart';
import 'package:admin_panel/models/new/status/change_status_response.dart';
import 'package:admin_panel/services/actions/actions_services.dart';

class CheckOutBloc {
  CheckOutBloc() {
    initDetails();
  }
  final ticketDetailsResponse = BehaviorSubject<TicketDetailsResponseModel?>();
  final checkoutSubmitResponse = BehaviorSubject<ChangeStatusResponse?>();

  Future<void> initDetails() async {}
  final state = CheckOutState();

  Future<bool> checkValidation() async {
    var isValid = true;
    if (state.barcodeStream.value.isEmpty) {
      isValid = false;
      state.barcodeStreamError.add('Please provide barcode');
    } else if (state.barcodeStream.value.length < 3) {
      isValid = false;
      state.barcodeStreamError.add('Please enter atleast 3 digit barcode');
    } else {
      state.barcodeStreamError.add('');
    }
    return isValid;
  }

  // get Ticket details
  Future<void> getTicketDetails({required String ticketNumber}) async {
    final respModel = await ActionsServices().getTicketDetails(ticketNumber: ticketNumber);
    ticketDetailsResponse.add(respModel);
    // //print('444444444444444 ${respModel!.data.ticketInfo[0].cvaIn}');
  }

  // checkout submit
  Future<void> checkOutSubmit({
    required String id,
    required String status,
    required String ticketNumber,
    required int? cvaOutId,
    required int? outletId,
    required String paymentPaidMethod,
    required int paymentMethodId,
    required String paymentNote,
    required String discountAmount,
    required double vatPercentage,
    required double vatAmount,
    required String grossAmount,
    required double subTotal,
    required String payment,
  }) async {
    final respModel = await ActionsServices().checkOutSubmit(
      id: id,
      status: status,
      ticketNumber: ticketNumber,
      cvaOutId: cvaOutId,
      outletId:outletId,
      paymentPaidMethod: paymentPaidMethod,
      paymentMethodId: paymentMethodId,
      paymentNote: paymentNote,
      discountAmount: discountAmount,
      vatPercentage: vatPercentage,
      vatAmount: vatAmount,
      grossAmount: grossAmount,
      subTotal: subTotal,
      payment: payment,
    );
    checkoutSubmitResponse.add(respModel);
  }

  // checkout submit for Payment Section
  Future<void> checkOutSubmitForPaymentSection({
    required String id,
    required String status,
    required String ticketNumber,
    required int? cvaOutId,
    required String paymentPaidMethod,
    required int paymentMethodId,
    required String paymentNote,
    required String discountAmount,
    required double vatPercentage,
    required double vatAmount,
    required String grossAmount,
    required double subTotal,
    required String payment,
  }) async {
    final respModel = await ActionsServices().checkOutSubmit(
      id: id,
      status: status,
      ticketNumber: ticketNumber,
      cvaOutId: cvaOutId,
      outletId: null,
      paymentPaidMethod: paymentPaidMethod,
      paymentMethodId: paymentMethodId,
      paymentNote: paymentNote,
      discountAmount: discountAmount,
      vatPercentage: vatPercentage,
      vatAmount: vatAmount,
      grossAmount: grossAmount,
      subTotal: subTotal,
      payment: payment,
    );
    checkoutSubmitResponse.add(respModel);
  }

  void dispose() {
    state.dispose();
  }
}
