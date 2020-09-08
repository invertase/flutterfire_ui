part of firebase_auth_ui;

class GitHubConfig{
  const GitHubConfig({
    @required this.clientId,
    @required this.clientSecret,
    this.redirectUrl,
    this.auth
  });

  /// The [FirebaseAuth] instance to authentication with.
  ///
  /// The default [FirebaseAuth] instance will be used if not provided.
  final FirebaseAuth auth;

  /// The GitHub Client ID
  final String clientId;

  /// The GitHub Client Secret
  final String clientSecret;

  /// The GitHub RedirectUrl
  final String redirectUrl;
}

class TwitterConfig{
  const TwitterConfig({
    @required this.apiKey,
    @required this.apiSecret,
    this.auth
  });

  /// The [FirebaseAuth] instance to authentication with.
  ///
  /// The default [FirebaseAuth] instance will be used if not provided.
  final FirebaseAuth auth;

  /// The Twitter Consumer ID
  final String apiKey;

  /// The Twitter Consumer Secret
  final String apiSecret;
}

class GoogleConfig{
  const GoogleConfig({
    this.auth
  });

  /// The [FirebaseAuth] instance to authentication with.
  ///
  /// The default [FirebaseAuth] instance will be used if not provided.
  final FirebaseAuth auth;
}