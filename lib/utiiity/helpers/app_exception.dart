class AppException implements Exception{
  final String message;
  const AppException({this.message = "Uncaught Exception"});
}

class FetchDataException extends AppException{
  const FetchDataException({super.message = "Error During Communication"});
}

class InvalidRequestException extends AppException{
  const InvalidRequestException({super.message = "Invalid Request"});
}

class UnAuthorizedException extends AppException{
  const UnAuthorizedException({super.message = "Unauthorized Request"});
}

class InvalidInputException extends AppException{
  const InvalidInputException({super.message = "Invalid Input"});
}