//!ServerException
import 'package:dio/dio.dart';
import 'package:rick_and_morty_series/core/error/error_model.dart';

class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

//!CacheExeption
class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class CofficientException extends ServerException {
  CofficientException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
      throw ConnectionErrorException(ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.badCertificate:
      throw BadCertificateException(ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(ErrorModel.fromJson(e.response!.data));

    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(ErrorModel.fromJson(e.response!.data));

    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.cancel:
      throw CancelException(ErrorModel.fromJson(e.response!.data));

    case DioExceptionType.unknown:
      throw UnknownException(ErrorModel.fromJson(e.response!.data));

    case DioExceptionType.badResponse:
      switch (e.response!.statusCode) {
        case 400: // Bad request
          throw BadResponseException(ErrorModel.fromJson(e.response!.data));
        case 401: //unauthorized
          throw UnauthorizedException(ErrorModel.fromJson(e.response!.data));
        case 403: //forbidden
          throw ForbiddenException(ErrorModel.fromJson(e.response!.data));
        case 404: //not found
          throw NotFoundException(ErrorModel.fromJson(e.response!.data));
        case 409: //cofficient
          throw CofficientException(ErrorModel.fromJson(e.response!.data));
        case 500: //cofficient
          throw CofficientException(ErrorModel.fromJson(e.response!.data));
        case 504: // Bad request
          throw BadResponseException(ErrorModel.fromJson(e.response!.data));
        default:
          throw ServerException(ErrorModel.fromJson(e.response!.data));
      }
  }
}
