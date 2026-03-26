/// Result type for API calls: success with data or failure with message/code.
sealed class ApiResult<T> {
  const ApiResult();
}

final class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);
  final T data;
}

final class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure({
    this.message = 'Something went wrong',
    this.statusCode,
    this.fieldErrors,
    this.isConnectionError = false,
  });
  final String message;
  final int? statusCode;
  final Map<String, String>? fieldErrors;
  final bool isConnectionError;
}
