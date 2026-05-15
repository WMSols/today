import 'package:today/core/utils/app_texts/app_texts.dart';

/// Maps DioException and response to [ApiFailure] / [Failure].
class ApiExceptions {
  ApiExceptions._();

  static String messageFromStatus(int? statusCode) {
    switch (statusCode) {
      case 400:
        return AppTexts.httpBadRequest;
      case 401:
        return AppTexts.httpUnauthorizedRequest;
      case 403:
        return AppTexts.httpForbiddenRequest;
      case 404:
        return AppTexts.httpResourceNotFound;
      case 500:
        return AppTexts.httpInternalServerError;
      default:
        return AppTexts.httpSomethingWentWrong;
    }
  }
}
