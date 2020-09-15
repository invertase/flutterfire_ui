part of firebase_auth_ui;


/// The entry point for signing in with Google.
///
/// Resolves with the result of the flow. If the user successfully signs in with
/// Google, the [UserCredential] will be returned.
/// Otherwise, the error will be returned
Future<UserCredential> signInWithGoogle([GoogleConfig options = const GoogleConfig()]) async {
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
Future<UserCredential> signInWithTwitter([TwitterConfig options = const TwitterConfig()]) async {

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
Future<UserCredential> signInWithGitHub(context, [GitHubConfig options = const GitHubConfig()]) async {
  FirebaseAuth auth = options.auth ?? FirebaseAuth.instance;

  final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: options.clientId,
      clientSecret: options.clientSecret,
      redirectUrl: options.redirectUrl);

  final result = await gitHubSignIn.signIn(context);

  final AuthCredential githubAuthCredential = GithubAuthProvider.credential(result.token);

  return auth.signInWithCredential(githubAuthCredential);
}

/// The entry point for signing in with Facebook.
///
/// Resolves with the result of the flow. If the user successfully signs in with
/// Facebook, the [UserCredential] will be returned.
/// Otherwise, the error will be returned
// Future<UserCredential> signInWithFacebook([FacebookConfig options = const FacebookConfig()]) async {
//   FirebaseAuth auth = options.auth ?? FirebaseAuth.instance;
//
//   final LoginResult result = await FacebookAuth.instance.login();
//
//   final FacebookAuthCredential facebookAuthCredential =
//   FacebookAuthProvider.credential(result.accessToken.token);
//
//   return auth.signInWithCredential(facebookAuthCredential);
// }






