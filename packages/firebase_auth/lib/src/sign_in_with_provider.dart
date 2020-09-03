part of firebase_auth_ui;


class SignInWithProviderOptions {
  const SignInWithProviderOptions();
}

/// The entry point for triggering the phone number verification UI.
///
/// Resolves with the result of the flow. If the user successfully verifies the
/// phone number, they will be signed in and the [UserCredential] will be returned.
/// Otherwise, `null` will be returned (e.g. if they cancel the flow).
Future<UserCredential> signInWithProvider(BuildContext context,
    [SignInWithProviderOptions options = const SignInWithProviderOptions()]) {
  assert(context != null);

  return showDialog<UserCredential>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Text("Sign In");
      });
}



