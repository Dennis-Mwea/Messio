abstract class MessioException implements Exception {
  errorMessage();
}

class UserNotFoundException implements MessioException {
  @override
  errorMessage() {
    return 'No user found for the provided uid/username.';
  }
}

class UsernameMappingUndefinedException implements MessioException {
  @override
  errorMessage() {
    return 'No uid for the provided username.';
  }
}
