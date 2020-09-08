# Firebase Auth UI

## `verifyPhoneNumber`

A dialog popup which handles the user verifying their phone number and signing in or linking the account.

- [x] Setup basic working example
- [ ] Break out common widgets into own directory
- [x] Implement "resend" flow
- [ ] Display errors better
- [ ] Overall UI improvements (Google Pay has a good SMS validation UI)
- [ ] Support Web (possible since sign-in is carried out).


## `signInWith[Provider]`

A Future that handles the authentication flow for the provider

- [x] Setup basic example

## `signInWithExistingProvider`
A UI flow which triggers a "provider first" UI flow:

1. User enters their email address into an input box.
2. [`fetchSignInProviders`](https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/fetchSignInMethodsForEmail.html) is called.
3. List of login providers is shown to the user

- [ ] Setup working example
- [ ] How are the credentials from all providers handled? (e.g. Facebook)
- [ ] Do we have to import all auth packages (even though they may not be used)

