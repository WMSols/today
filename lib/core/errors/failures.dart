/// Domain-level failure types.
sealed class Failure {
  const Failure({this.message = 'Something went wrong'});
  final String message;
}

final class ServerFailure extends Failure {
  const ServerFailure({super.message, this.statusCode});
  final int? statusCode;
}

final class ValidationFailure extends Failure {
  const ValidationFailure({super.message, this.fieldErrors});
  final Map<String, String>? fieldErrors;
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message});
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.message});
}

final class CacheFailure extends Failure {
  const CacheFailure({super.message});
}
