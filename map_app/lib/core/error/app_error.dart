class AppError implements Exception {
  final String message;
  final int? statusCode;
  final ErrorType type;

  AppError(this.message, {this.statusCode, this.type = ErrorType.unknown});

  factory AppError.network(String message) {
    return AppError(message, type: ErrorType.network);
  }

  factory AppError.server(String message, {int? statusCode}) {
    return AppError(message, statusCode: statusCode, type: ErrorType.server);
  }

  factory AppError.validation(String message) {
    return AppError(message, type: ErrorType.validation);
  }

  factory AppError.unauthorized(String message) {
    return AppError(message, type: ErrorType.unauthorized);
  }

  @override
  String toString() => message;
}

enum ErrorType {
  network,
  server,
  validation,
  unauthorized,
  unknown,
} 