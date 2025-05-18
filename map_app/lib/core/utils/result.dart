class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  Result._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  factory Result.success(T data) {
    return Result._(
      data: data,
      isSuccess: true,
    );
  }

  factory Result.error(String error) {
    return Result._(
      error: error,
      isSuccess: false,
    );
  }

  bool get isError => !isSuccess;

  void when({
    required Function(T data) success,
    required Function(String error) error,
  }) {
    if (isSuccess) {
      success(data as T);
    } else {
      error(this.error!);
    }
  }
} 