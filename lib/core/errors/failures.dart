import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({this.message = '', this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error', super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error', super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection', super.code});
}

class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication error', super.code});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({super.message = 'Database error', super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Validation error', super.code});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Not found', super.code});
}

class PermissionFailure extends Failure {
  const PermissionFailure({super.message = 'Permission denied', super.code});
}
