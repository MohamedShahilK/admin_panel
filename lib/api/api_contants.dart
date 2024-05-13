// ignore_for_file: constant_identifier_names, lines_longer_than_80_chars

// import 'package:dio/dio.dart';

class ApiConstants {
  // static const _adminToken =
  //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjEsIm5hbWUiOiJhaXRhZG1pbnRlc3QiLCJ1c2VybmFtZSI6ImFpdGFkbWludGVzdCIsImxvY2F0aW9uSWQiOjAsInVzZXJDYXRlZ29yeSI6IkFETUlOIiwidXNlclR5cGUiOiJBIiwicGVybWlzc2lvbnMiOnsiZmVlX2NvbGxlY3Rpb24iOiJZIiwidGlja2V0X2NoZWNraW4iOiJOIiwidGlja2V0X3JlcXVlc3QiOiJZIiwidGlja2V0X29udGhld2F5IjoiWSIsInRpY2tldF9jb2xsZWN0bm93IjoiWSIsInRpY2tldF9jaGVja291dCI6IlkiLCJ0aWNrZXRfZWRpdCI6IlkiLCJ0aWNrZXRfZGVsZXRlIjoiWSIsInRpY2tldF9tb2JpbGVfcHJpbnQiOiJZIiwicmVwb3J0IjoiWSIsImNhc2hfY2hlY2tpbiI6IlkiLCJjYXNoX2NoZWNraW5fZWRpdCI6IlkiLCJpbWFnZV91cGxvYWQiOiJZIn0sImlhdCI6MTY5MzkxNDU3MCwiZXhwIjoxNjk2NTA2NTcwfQ.Hqo1QCNiGyJiovA176gpj5bBAbuUeeO9wiNiT9TF2zg';
  static const BASE_URL = 'https://varletpark.com/vps_api/v1';

  // static final options = Options(
  //   headers: {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $_adminToken',
  //   },
  // );
}

class EndPoints {
  static const login = '/login';
  static const getToken = '/get-token';
  static const regenerateToken = '/regenerate-token';
  static const checkinForm = '/checkin-form';
  static const checkinSubmit = '/checkin-submit';
  static const CheckTicketExists = '/check-ticket-number-exists';
  static const getTicketNumberSettings = '/get-ticket-number';
  static const changeTicketStatus = '/change-ticket-status';
  static const getAllTickets = '/get-all-tickets';
  static const checkoutForm = '/checkout-form';
  static const uploadImageForm = '/upload-image-form';
  static const uploadImageSubmit = '/upload-image-submit';
  static const getTokenDetails = '/get-token-details';
  static const changePassword = '/change-password';
  static const dashboard = '/dashboard';
  static const getAllCheckins = '/get-all-checkins';
  static const getAllCheckOuts = '/get-all-checkouts';
  static const carBrands = '/car-brands';
  static const getPermissions = '/get-permissions';
  static const printSettings = '/print-settings';
  static const ticketInfo = '/ticket-info';
  static const deleteImage = '/delete-image';
  static const settings = '/settings';
  static const getUsers = '/get-users';
}
