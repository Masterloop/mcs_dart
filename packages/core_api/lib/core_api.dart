library masterloop_core_api;

abstract class Api {}

class ApiError extends Error {
  final String reason;

  ApiError({this.reason}) : super();

  @override
  String toString() => reason;
}
