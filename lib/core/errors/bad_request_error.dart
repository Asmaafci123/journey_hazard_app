import './http_error.dart';

class BadRequestError extends HttpError {
  final dynamic message;

  BadRequestError({this.message});

}