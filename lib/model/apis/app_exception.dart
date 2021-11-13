class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix $_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super("Error During Communication", message);
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super("Invalid Request:", message);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super("Unauthorised Request:", message);
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super("Invalid Input:");
}
