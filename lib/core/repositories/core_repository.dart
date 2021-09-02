import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:journeyhazard/core/errors/bad_request_error.dart';
import 'package:journeyhazard/core/errors/base_error.dart';
import 'package:journeyhazard/core/errors/handle_dio_error.dart';
import 'package:journeyhazard/core/errors/socket_error.dart';
import 'package:journeyhazard/core/models/empty_response_model.dart';
import 'package:journeyhazard/core/models/models_factory.dart';
import 'package:journeyhazard/core/results/result.dart';
import 'package:dio/dio.dart';

enum HttpMethod {
  GET,
  POST,
  PUT,
  DELETE
}
class CoreRepository {
  RemoteResult<T> handleRemoteResult<T>(Either<BaseError, T> response) {
    print('isRight().....................');
    if (response.isRight()) {
      return RemoteResult(data: (response as Right<BaseError, T>).value);
    } else {

      return RemoteResult(error: (response as Left<BaseError, T>).value);
    }
  }

  static Future<Result<T>> request<T>({
    @required T Function(Map<String, dynamic>) converter,
    @required HttpMethod method,
    @required String url,
    dynamic data,
    Map<String, String> headers,
    Map<String, dynamic> queryParameters,
    bool withAuthentication = false,
    // CancelToken cancelToken,
 }) async {
    assert(method != null);
    assert(url != null);
    try {
      print('[$method: $url]');

// Get the response from the server
      Response response;
      switch (method) {
        case HttpMethod.GET:
          response = await Dio().get(
            url,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            // cancelToken: cancelToken,
          );
          break;
        case HttpMethod.POST:
          response = await Dio().post(
            url,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            // cancelToken: cancelToken,
          );
          break;
        case HttpMethod.PUT:
          response = await Dio().put(
            url,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            // cancelToken: cancelToken,
          );
          break;
        case HttpMethod.DELETE:
          response = await Dio().delete(
            url,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            // cancelToken: cancelToken,
          );
          break;
      }

// Get the decoded json
      var decodedJson;
//      decodedJson = response.data;
      print(' decodedJsonnn = ${response}');
      if (response.data is String && !(T is EmptyResultModel) && decodedJson!=null)
        decodedJson = json.decode(response.data);
      else
        decodedJson = response.data;

      print(decodedJson);
      print(' TTTTTTTTTTTTT IS $T');
//// Return the http response with actual data
      if(T.toString() == 'EmptyResultModel'){
        print('here TTTTTTTTTTTTT IS $T');
        return  Result(data: EmptyResultModel() as T);
      }
      else
      //  return Result(data: ModelsFactory.getInstance().createModel<T>(decodedJson));
      return Result(data: decodedJson);

    }

// Handling errors
    on DioError catch (e) {
      print(e);
      print('DioErrorDioErrorDioError ${Errors.handleDioError(e)}');
      var err = Errors.handleDioError(e);
      return Result(error: Errors.handleDioError(e));
    }

// Couldn't reach out the server
    on SocketException catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return Result(error: SocketError() );
    }
  }


}

