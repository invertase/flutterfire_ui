part of firebase_auth_ui;

/// Used to set the type of verification request on [VerifyPhoneNumberOptions].
enum VerifyPhoneNumberType {
  /// Once verified, the user signed in.
  ///
  /// The user must be logged out otherwise an error will be thrown.
  signIn,

  /// Once verified, the phone number is linked to the currently signed in user.
  ///
  /// The user must be signed in otherwise an error will be thrown.
  link,
}

/// Custom error callback handler.
typedef String VerifyPhoneNumberError(Object exception);

/// Options which can be passed to the [verifyPhoneNumber] method to control
/// the sign-in flow.
///
/// ```dart
/// verifyPhoneNumber(context, VerifyPhoneNumberOptions(
///   title: 'Phone number verification',
/// ));
/// ```
class VerifyPhoneNumberOptions {
  const VerifyPhoneNumberOptions(
      {this.auth,
      this.type = VerifyPhoneNumberType.signIn,
      this.onError,
      this.title = "Mobile Verification",
      this.description =
          "Please enter your phone number to verify your account",
      this.phoneNumberLabel = "Enter your phone number",
      this.send = "Send SMS Code",
      this.cancel = "Cancel",
      this.backgroundColor = Colors.white,
      this.borderRadius = 3,
      this.favoriteCountries = const ['US'],
        this.defaultCountry = 'US'
      });

  /// The [FirebaseAuth] instance to authentication with.
  ///
  /// The default [FirebaseAuth] instance will be used if not provided.
  final FirebaseAuth auth;

  /// The type of authentication to carry out once verified.
  final VerifyPhoneNumberType type;

  /// A custom error handler function.
  ///
  /// By default, errors will be stringified and displayed to users. Use this
  /// argument to return your own custom error messages.
  final VerifyPhoneNumberError onError;

  /// The title of the dialog.
  ///
  /// Defaults to "Verify your phone number".
  final String title;

  /// The description shown below the [title].
  final String description;

  /// The label shown for the phone number text field.
  final String phoneNumberLabel;

  /// The text used for the send button.
  final String send;

  /// The text used for the cancel button.
  final String cancel;

  /// The background color of the popup
  final Color backgroundColor;

  /// The borderRadius of the popup
  final double borderRadius;

  /// The favorite countries to be used in the Country Picker
  final List<String> favoriteCountries;

  /// The default country code used in the Country Picker
  final String defaultCountry;
}

/// The entry point for triggering the phone number verification UI.
///
/// Resolves with the result of the flow. If the user successfully verifies the
/// phone number, they will be signed in and the [UserCredential] will be returned.
/// Otherwise, `null` will be returned (e.g. if they cancel the flow).
Future<UserCredential> verifyPhoneNumber(BuildContext context,
    [VerifyPhoneNumberOptions options = const VerifyPhoneNumberOptions()]) {
  assert(context != null);

  return showDialog<UserCredential>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(options.borderRadius)),
          insetPadding: EdgeInsets.all(16),
          child: _VerifyPhoneNumber(
            context: context,
            options: options,
          ),
        );
      });
}

class _VerifyPhoneNumber extends StatefulWidget {
  _VerifyPhoneNumber({
    @required this.context,
    @required this.options,
    Key key,
  })  : auth = options.auth ?? FirebaseAuth.instance,
        super(key: key);

  final BuildContext context;

  final VerifyPhoneNumberOptions options;

  final FirebaseAuth auth;

  @override
  State<StatefulWidget> createState() {
    return _VerifyPhoneNumberState();
  }
}

class _VerifyPhoneNumberState extends State<_VerifyPhoneNumber> {
  String _error;
  String _phoneNumber;
  String _verificationId;
  String _countryCode = '+1';
  bool _verifying = false;
  bool _enterSmsCode = false;
  int _resendToken;

  TextEditingController codeInputController = TextEditingController();

  void setVerifying(bool value) {
    setState(() {
      _verifying = value;
    });
  }

  void parsePhoneNumber(String phoneNumber) {
    setState(() {
      _phoneNumber = _countryCode + phoneNumber;
    });
  }

  void updateCountryCode(String countryCode) {
    setState(() {
      _phoneNumber = countryCode + _phoneNumber;
    });
  }

  void setEnterSmsCode(bool value) {
    setState(() {
      _enterSmsCode = value;
    });
  }

  Widget get title {
    return Container(
        margin: EdgeInsets.only(bottom: 24),
        child: Text(
          widget.options.title,
          style: TextStyle(fontSize: 24),
        ));
  }

  Widget get description {
    return Text(widget.options.description,
        style: TextStyle(fontSize: 14, color: Colors.grey));
  }

  Widget get error {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Text(_error, style: TextStyle(color: Colors.red)),
    );
  }

  Widget get input {
    return Container(
        margin: EdgeInsets.only(top: 24),
        child: Row(
          children: <Widget>[
            CountryCodePicker(
              onInit: (code) => _countryCode = code.toString(),
              onChanged: (code) => updateCountryCode(code.toString()),
              initialSelection: widget.options.defaultCountry,
              favorite: widget.options.favoriteCountries,
            ),
            Expanded(child: TextField(
              onChanged: (value) => parsePhoneNumber(value),
              decoration: InputDecoration(
                  labelText: widget.options.phoneNumberLabel,
                  suffix: _verifying
                      ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : null),
            ))
          ],
        ));
  }

  Widget get footer {
    return Container(
      margin: EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if(_enterSmsCode)
            FlatButton(
              onPressed: () => triggerVerification(),
              padding: EdgeInsets.all(16),
              child: Text("Resend Code", style: TextStyle(fontSize: 16)),
            ),
          FlatButton(
            onPressed: () => Navigator.pop(context, null),
            padding: EdgeInsets.all(16),
            child: Text("Cancel", style: TextStyle(fontSize: 16)),
          ),
          if (!_enterSmsCode)
            FlatButton(
              onPressed: () => triggerVerification(),
              padding: EdgeInsets.all(16),
              child: Text(
                widget.options.send,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void performAuthAction(PhoneAuthCredential phoneAuthCredential) async {
    UserCredential userCredential;

    if (widget.options.type == VerifyPhoneNumberType.signIn) {
      assert(widget.auth.currentUser == null);
      userCredential =
          await widget.auth.signInWithCredential(phoneAuthCredential);
    } else {
      assert(widget.auth.currentUser != null);
      userCredential =
          await widget.auth.currentUser.linkWithCredential(phoneAuthCredential);
    }

    Navigator.pop(context, userCredential);
  }

  void handleError(Object e) {
    if (widget.options.onError != null) {
      setState(() {
        _error = widget.options.onError(e);
      });
    } else {
      String message;

      if (e is FirebaseException) {
        switch (e.code) {
          case 'invalid-phone-number':
            message = "Please check the format of the provided phone number: $_phoneNumber";
            break;
          case 'phone-number-already-exists':
            message = "The number $_phoneNumber is already in use";
            break;
          default:
            message = e.message;
        }
      } else {
        message = e.toString();
      }
      print(message);
      setState(() {
        _error = message;
      });
    }
  }

  void verificationCompleted(PhoneAuthCredential credential) {
    try {
      codeInputController.text = credential.smsCode;
      Timer(Duration(seconds: 1), () {
        performAuthAction(credential);
      });
    } catch (e) {
      handleError(e);
    }
  }

  void codeSent(String verificationId, int resendToken) {
    _resendToken = resendToken;
    _verificationId = verificationId;
    setEnterSmsCode(true);
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    print('codeAutoRetrievalTimeout');
  }

  void onCodeEntered(String code) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: code);
    performAuthAction(credential);
  }

  Future<void> triggerVerification({ bool resendCode = false}) async {
    if (_verifying || (_phoneNumber == null || _phoneNumber.isEmpty)) {
      return;
    }

    try {
      setVerifying(true);
      await widget.auth.verifyPhoneNumber(
          phoneNumber: _phoneNumber ?? '',
          verificationCompleted: verificationCompleted,
          verificationFailed: handleError,
          codeSent: codeSent,
          forceResendingToken: resendCode ? _resendToken : null,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      handleError(e);
    } finally {
      setVerifying(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.options.borderRadius),
            color: widget.options.backgroundColor,
          ),
          width: 500,
          child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  description,
                  if (!_enterSmsCode) input,
                  if (_enterSmsCode) _SMSCodeInput(onCodeEntered),
                  if (_error != null) _Error(_error),
                  footer,
                ],
              )),
        ));
  }
}

class _Error extends StatelessWidget {
  const _Error(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Text(text, style: TextStyle(color: Colors.red)),
    );
  }
}

class _SMSCodeInput extends StatelessWidget {
  _SMSCodeInput(this.onEntered);

  final void Function(String code) onEntered;

  final int total = 6;

  final List<String> codeArray = [];

  final List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  Widget input(BuildContext context, int index) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 60,
        alignment: Alignment.center,
        child: TextField(
          focusNode: focusNodes[index],
          onChanged: (value) {
            codeArray.insert(index, value);
            if (index + 1 == focusNodes.length) {
              onEntered(codeArray.join());
            } else {
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            }
          },
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          textInputAction: TextInputAction.next,
          style: TextStyle(
            fontSize: 18,
            height: 2,
          ),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.only(
              bottom: 30,
            ),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> inputs = [];

    for (var i = 0; i < total; i++) {
      inputs.add(input(context, i));
    }

    return Container(
      margin: EdgeInsets.only(top: 24),
      child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: inputs,
            ),
          ]),
    );
  }
}
