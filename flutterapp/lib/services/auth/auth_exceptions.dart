// Login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// register exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUesAuthException implements Exception {}

class InvalidEmailInAuthException implements Exception {}

// generic excptions

class GenericAuthException implements Exception {}


class UserNotLoggedInAuthException implements Exception {}