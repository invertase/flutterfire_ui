part of firebase_auth_ui;

/// Options which can be passed to the sign in methods to control
/// the sign-in flow.
///
/// ```dart
/// signInWithGoogle( SignInProviderOptions(
///   apiKey: 'key',
///   apiSecret: 'secret'
/// ));
/// ```
class SignInProviderOptions {
  const SignInProviderOptions(
      {
        this.auth,
        this.apiKey,
        this.apiSecret,
        this.redirectUrl,
      });

  /// The [FirebaseAuth] instance to authentication with.
  ///
  /// The default [FirebaseAuth] instance will be used if not provided.
  final FirebaseAuth auth;

  /// The API Key for the provider
  final String apiKey;

  /// The API Secret for the provider
  final String apiSecret;

  /// The Redirect URL for the instance
  final String redirectUrl;
}


/// The entry point for signing in with Google.
///
/// Resolves with the result of the flow. If the user successfully signs in with
/// Google, the [UserCredential] will be returned.
/// Otherwise, the error will be returned
Future<UserCredential> signInWithGoogle([SignInProviderOptions options = const SignInProviderOptions()]) async {
  FirebaseAuth auth = options.auth ?? FirebaseAuth.instance;

  GoogleAuthCredential googleAuthCredential;

  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  googleAuthCredential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return auth.signInWithCredential(googleAuthCredential);
}

/// The entry point for signing in with Twitter.
///
/// Resolves with the result of the flow. If the user successfully signs in with
/// Twitter, the [UserCredential] will be returned.
/// Otherwise, the error will be returned
Future<UserCredential> signInWithTwitter([SignInProviderOptions options = const SignInProviderOptions()]) async {

  FirebaseAuth auth = options.auth ?? FirebaseAuth.instance;

  final TwitterLogin twitterLogin = new TwitterLogin(consumerKey: options.apiKey, consumerSecret: options.apiSecret);

  final TwitterLoginResult loginResult = await twitterLogin.authorize();

  final TwitterSession twitterSession = loginResult.session;

  final AuthCredential twitterAuthCredential =
      TwitterAuthProvider.credential(
          accessToken: twitterSession.token,
          secret: twitterSession.secret);

  return auth.signInWithCredential(twitterAuthCredential);
}

/// The entry point for signing in with GitHub.
///
/// Resolves with the result of the flow. If the user successfully signs in with
/// GitHub, the [UserCredential] will be returned.
/// Otherwise, the error will be returned
Future<UserCredential> signInWithGitHub(context, [SignInProviderOptions options = const SignInProviderOptions()]) async {
  FirebaseAuth auth = options.auth ?? FirebaseAuth.instance;

  final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: options.apiKey,
      clientSecret: options.apiSecret,
      redirectUrl: options.redirectUrl);

  final result = await gitHubSignIn.signIn(context);

  final AuthCredential githubAuthCredential = GithubAuthProvider.credential(result.token);

  return auth.signInWithCredential(githubAuthCredential);
}








