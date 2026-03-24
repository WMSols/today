/// Maps DioException and response to [ApiFailure] / [Failure].
class ApiExceptions {
  ApiExceptions._();

  static String messageFromStatus(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized request';
      case 403:
        return 'Forbidden request';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Something went wrong';
    }
  }
}
