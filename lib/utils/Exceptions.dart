abstract class MessioException implements Exception {
  errorMessage();
}

class UserNotFoundException implements MessioException {
  @override
  errorMessage() => 'No user found for provided uid/username';
}

class UsernameMappingUndefinedException implements MessioException {
  @override
  errorMessage() => 'User not found';
}

class ContactAlreadyExistsException implements MessioException {
  @override
  String errorMessage() => 'Contact already exists!';
}
