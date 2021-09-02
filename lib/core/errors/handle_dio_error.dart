import 'dart:io';
import 'package:dio/dio.dart';
import 'package:journeyhazard/core/errors/base_error.dart';
import 'package:journeyhazard/core/errors/socket_error.dart';
import 'package:journeyhazard/core/errors/timeout_error.dart';
import 'package:journeyhazard/core/errors/unauthorized_error.dart';
import 'package:journeyhazard/core/errors/unknown_error.dart';

import 'bad_request_error.dart';
import 'cancel_error.dart';
import 'conflict_error.dart';
import 'forbidden_error.dart';
import 'http_error.dart';
import 'internal_server_error.dart';
import 'net_error.dart';
import 'not_found_error.dart';

class Errors {

  static BaseError handleDioError(DioError error) {
    print('error.type = ${(error.type) }');
    if (error.type == DioErrorType.other || error.type == DioErrorType.response) {
      if (error is SocketException) return SocketError();
      if (error.type == DioErrorType.response) {
        print(error.response.statusCode);
        switch (error.response.statusCode) {
          case 400:
            return BadRequestError(message: error.response.data['message'] );
          case 401:
            return UnauthorizedError();
          case 403:
            return ForbiddenError();
          case 404:
            return NotFoundError();
          case 409:
            return ConflictError();
          case 500:
            return InternalServerError();
          default:
            return HttpError();
        }
      }
      return NetError();
    } else if (error.type == DioErrorType.connectTimeout ||
        error.type == DioErrorType.sendTimeout ||
        error.type == DioErrorType.receiveTimeout) {
      return TimeoutError();
    } else if (error.type == DioErrorType.cancel) {
      return CancelError();
    } else
      return UnknownError();
  }
}