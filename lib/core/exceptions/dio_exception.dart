class DioExceptionMessage implements Exception {
  final String message;
  DioExceptionMessage(this.message);

  @override
  String toString() => message;
}
