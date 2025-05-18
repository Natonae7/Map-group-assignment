import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/theme_config.dart';
import '../../widgets/error_dialog.dart';

class AppError {
  final String message;
  final String? code;
  final dynamic originalError;

  AppError({
    required this.message,
    this.code,
    this.originalError,
  });

  factory AppError.fromException(dynamic error) {
    if (error is AppError) return error;
    
    return AppError(
      message: error.toString(),
      originalError: error,
    );
  }
}

final errorHandlerProvider = Provider<ErrorHandler>((ref) {
  return ErrorHandler();
});

class ErrorHandler {
  void handleError(BuildContext context, dynamic error) {
    final appError = error is AppError ? error : AppError.fromException(error);
    
    ErrorDialog.show(
      context,
      title: 'Error',
      message: appError.message,
      onRetry: () {
        // Implement retry logic if needed
      },
    );
  }

  void handleNetworkError(BuildContext context) {
    ErrorDialog.show(
      context,
      title: 'Network Error',
      message: 'Please check your internet connection and try again.',
      onRetry: () {
        // Implement retry logic if needed
      },
    );
  }

  void handleAuthError(BuildContext context) {
    ErrorDialog.show(
      context,
      title: 'Authentication Error',
      message: 'Your session has expired. Please log in again.',
      onRetry: () {
        // Navigate to login screen
      },
    );
  }

  void handleValidationError(BuildContext context, String message) {
    ErrorDialog.show(
      context,
      title: 'Validation Error',
      message: message,
    );
  }

  void handleServerError(BuildContext context) {
    ErrorDialog.show(
      context,
      title: 'Server Error',
      message: 'Something went wrong on our end. Please try again later.',
    );
  }

  void handlePermissionError(BuildContext context, String permission) {
    ErrorDialog.show(
      context,
      title: 'Permission Required',
      message: 'Please grant $permission permission to continue.',
      onRetry: () {
        // Open app settings
      },
    );
  }
} 