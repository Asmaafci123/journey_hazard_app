import 'package:journeyhazard/core/errors/base_error.dart';
import 'package:journeyhazard/core/errors/unexpected_error.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class HttpService {
  /** 
   * If you're making multiple requests to the same server,
   *  you can keep open a persistent connection by using a Client
   *  rather than making one-off requests. If you do this, 
   * make sure to close the client when you're done:
  */
  final client = http.Client();
  final Map<String, String> publicHeader = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  // add public post,get,put and delete  Methods without any [authentication token]
  Future<Either<BaseError, http.Response>> httpPublicPost(
      String url, dynamic body) async {
    try {
      var urlUri = Uri.parse(url);
      final res =
          await this.client.post(urlUri, headers: publicHeader, body: body);
      return Right(res);
    } catch (error) {
      return Left(UnExpectedError());
    }
  }

  Future<Either<BaseError, http.Response>> httpPublicGet(String url) async {
    try {
      var urlUri = Uri.parse(url);

      final res = await this.client.get(urlUri, headers: publicHeader);
      /// TODO SERIALIZE
      return Right(res);
    } catch (error) {
      return Left(UnExpectedError());
    }
  }

  Future<Either<BaseError, http.Response>> httpPublicPut(
      String url, dynamic body) async {
    try {
      var urlUri = Uri.parse(url);

      final res = await this.client.put(urlUri, headers: publicHeader, body: body);
      return Right(res);
    } catch (error) {
      return Left(UnExpectedError());
    }
  }

  Future<Either<BaseError, http.Response>> httpPublicDelete(String url) async {
    try {
      var urlUri = Uri.parse(url);

      final res = await this.client.delete(urlUri, headers: publicHeader);
      return Right(res);
    } catch (error) {
      return Left(UnExpectedError());
    }
  }

// add [Authenticated] post , get , put and delete Methods

  Future<Either<BaseError, http.Response>> httpAuthPost(
      String url, dynamic body, String token) async {
    try {
      publicHeader['Authorization'] = token;
      var urlUri = Uri.parse(url);

      final res =
          await this.client.post(urlUri, headers: publicHeader, body: body);
      return Right(res);
    } catch (error) {
      return Left(UnExpectedError());
    }
  }

  Future<Either<BaseError, http.Response>> httpAuthGet(
      String url, String token) async {
    try {
      publicHeader['Authorization'] = token;
      var urlUri = Uri.parse(url);

      final res = await this.client.get(urlUri, headers: publicHeader);
      return Right(res);
    } catch (error) {
      return Left(UnExpectedError());
    }
  }

  Future<Either<BaseError, http.Response>> httpAuthPut(
      String url, dynamic body, String token) async {
    try {
      publicHeader['Authorization'] = token;
      var urlUri = Uri.parse(url);

      final res = await this.client.put(urlUri, headers: publicHeader, body: body);
      return Right(res);
    } catch (error) {
      return Left(UnExpectedError());
    }
  }

  Future<Either<BaseError, http.Response>> httpAuthDelete(
      String url, String token) async {
    try {
      publicHeader['Authorization'] = token;
      var urlUri = Uri.parse(url);

      final res = await this.client.delete(urlUri, headers: publicHeader);
      return Right(res);
    } catch (error) {
      return Left(UnExpectedError());
    }
  }

  // close the http connection
  closeClient() {
    client.close();
  }
}
