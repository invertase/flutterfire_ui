part of firebase_auth_ui;

class ExistingProviderOptions {
  const ExistingProviderOptions({
    this.auth,
    this.email
  });

  /// The [FirebaseAuth] instance to authentication with.
  ///
  /// The default [FirebaseAuth] instance will be used if not provided.
  final FirebaseAuth auth;

  /// The users email address to fetch providers
  final String email;
}

