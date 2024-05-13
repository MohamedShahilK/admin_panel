// ignore_for_file: overridden_fields, annotate_overrides, lines_longer_than_80_chars

import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {
  // AppInterceptors(this.dio);
  // final Dio dio;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions, err.response);

      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err.requestOptions, err.response);
          case 401:
            throw UnauthorizedException(err.requestOptions, err.response);
          case 404:
            throw NotFoundException(err.requestOptions, err.response);
          case 409:
            throw ConflictException(err.requestOptions, err.response);
          case 500:
            throw InternalServerErrorException(err.requestOptions, err.response);
        }
        break;
      case DioExceptionType.connectionError:
        throw NoInternetConnectionException(err.requestOptions,err.message);
      case DioExceptionType.badCertificate:
        break;
      case DioExceptionType.unknown:
        break;
      case DioExceptionType.cancel:
        break;
    }

    return handler.next(err);
  }
}

class DeadlineExceededException extends DioException {
  DeadlineExceededException(RequestOptions r, this.response) : super(requestOptions: r);

  final Response<dynamic>? response;

  @override
  String toString() {
    return 'The connection has timed out, please try again. $response';
  }
}

class BadRequestException extends DioException {
  BadRequestException(RequestOptions r, this.response) : super(requestOptions: r);

  final Response<dynamic>? response;

  @override
  String toString() {
    return 'Invalid request  $response';
  }
}

class UnauthorizedException extends DioException {
  UnauthorizedException(RequestOptions r, this.response) : super(requestOptions: r);

  final Response<dynamic>? response;

  @override
  String toString() {
    return 'Access denied $response';
  }

  
}

class NotFoundException extends DioException {
  NotFoundException(RequestOptions r, this.response) : super(requestOptions: r);

  final Response<dynamic>? response;

  @override
  String toString() {
    return 'The requested information could not be found $response';
  }
}

class ConflictException extends DioException {
  ConflictException(RequestOptions r, this.response) : super(requestOptions: r);

  final Response<dynamic>? response;

  @override
  String toString() {
    return 'Conflict occurred $response';
  }
}

class InternalServerErrorException extends DioException {
  InternalServerErrorException(RequestOptions r, this.response) : super(requestOptions: r);

  final Response<dynamic>? response;

  @override
  String toString() {
    return 'Unknown error occurred, please try again later. $response';
  }
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException(RequestOptions r, this.message) : super(requestOptions: r);

  // final Response<dynamic>? response;
  final String? message;

  @override
  String toString() {
    return 'No internet connection detected, please try again. $message';
  }
}
