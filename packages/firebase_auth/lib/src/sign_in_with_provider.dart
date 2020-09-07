part of firebase_auth_ui;

class SignInProviderOptions {
  const SignInProviderOptions(
      {
        @required this.apiKey,
        @required this.apiSecret,
      });

  final String apiKey;

  final String apiSecret;
}

class GitHubSignInOptions {
  const GitHubSignInOptions(
      {
        @required this.apiKey,
        @required this.apiSecret,
        @required this.redirectUrl,
      });

  final String apiKey;

  final String redirectUrl;

  final String apiSecret;
}

Future<void> signInWithGoogle() async {
  GoogleAuthCredential googleAuthCredential;

  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  googleAuthCredential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return FirebaseAuth.instance.signInWithCredential(googleAuthCredential);
}

Future<void> signInWithTwitter([SignInProviderOptions options = const SignInProviderOptions()]) async {
  final TwitterLogin twitterLogin = new TwitterLogin(consumerKey: options.apiKey, consumerSecret: options.apiSecret);

  final TwitterLoginResult loginResult = await twitterLogin.authorize();

  final TwitterSession twitterSession = loginResult.session;

  final AuthCredential twitterAuthCredential =
      TwitterAuthProvider.credential(
          accessToken: twitterSession.token,
          secret: twitterSession.secret);

  return FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
}

Future<void> signInWithGitHub(context, [GitHubSignInOptions options = const GitHubSignInOptions()]) async {
  final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: options.apiKey,
      clientSecret: options.apiSecret,
      redirectUrl: options.redirectUrl);

  final result = await gitHubSignIn.signIn(context);

  final AuthCredential githubAuthCredential = GithubAuthProvider.credential(result.token);

  return FirebaseAuth.instance.signInWithCredential(githubAuthCredential);
}








