// firebase_auth_service.dart
// A comprehensive Firebase Authentication service for Flutter (Dart, null-safe).
// Supports: Email/Password, Google Sign-In, Phone (OTP) Sign-In, Anonymous sign-in,
// Link/unlink providers, password reset, email verification, token refresh, profile updates,
// and auth state stream.

// How to use:
// 1. Add dependencies in pubspec.yaml:
//    firebase_core: ^2.0.0
//    firebase_auth: ^4.0.0
//    google_sign_in: ^6.0.0
// 2. Initialize Firebase in main():
//    WidgetsFlutterBinding.ensureInitialized();
//    await Firebase.initializeApp();
// 3. Use FirebaseAuthService.instance to call methods.

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthResult<T> {
  final T? data;
  final Exception? error;
  final String? message;

  AuthResult({this.data, this.error, this.message});

  bool get ok => error == null;
}

class FirebaseAuthService {
  FirebaseAuthService._privateConstructor();
  static final FirebaseAuthService instance = FirebaseAuthService._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
 

  /// Stream to listen to authentication state changes (User?).
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Returns the currently signed-in user or null.
  User? get currentUser => _auth.currentUser;

  /// Create user with email and password.
  Future<AuthResult<User>> signUpWithEmail({required String email, required String password}) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return AuthResult(data: userCred.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e, message: _firebaseErrorMessage(e));
    } catch (e) {
      return AuthResult(error: Exception(e.toString()));
    }
  }

  /// Sign in with email and password.
  Future<AuthResult<User>> signInWithEmail({required String email, required String password}) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return AuthResult(data: userCred.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e, message: _firebaseErrorMessage(e));
    } catch (e) {
      return AuthResult(error: Exception(e.toString()));
    }
  }

  /// Send password reset email.
  Future<AuthResult<void>> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthResult(data: null);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e, message: _firebaseErrorMessage(e));
    } catch (e) {
      return AuthResult(error: Exception(e.toString()));
    }
  }

  /// Sign in with Google (works on Android/iOS/web with proper setup).
  Future<AuthResult<User>> signInWithGoogle() async {
    try {
      _googleSignIn.initialize(serverClientId: "178669730773-nue4reppp27vcrdkcb2n20b9h9otki4a.apps.googleusercontent.com");
      // Trigger the authentication flow
      if(_googleSignIn.supportsAuthenticate()){
         final googleUser = await _googleSignIn.authenticate();
         // if (googleUser == null) return AuthResult(error: Exception('Google sign in aborted by user'));

      // // Obtain the auth details from the request
      final googleAuth = await googleUser.authentication;

      print("GoogleIdToken ${googleAuth.idToken}");

      // // Create a new credential
      final credential = GoogleAuthProvider.credential(
        // accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
       
      // // Sign in to Firebase with the Google user credential
      final userCredential = await _auth.signInWithCredential(credential);
      return AuthResult(data: userCredential.user);
      }
     
      return AuthResult(message: "Does Not support GoogleAuth");
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException: ${e.code} - ${e.message}");
      return AuthResult(error: e, message: _firebaseErrorMessage(e));
      
    } catch (e) {
      debugPrint("Unexpected error: $e");
      return AuthResult(error: Exception(e.toString()));
    }
  }

  /// Sign out from Firebase and Google (if signed in with Google).
  Future<AuthResult<void>> signOut() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // If signed in with Google, sign out from GoogleSignIn as well
      try {
        if (currentUser != null) {
          await _googleSignIn.signOut();
        }
      } catch (_) {}

      return AuthResult(data: null);
    } catch (e) {
      return AuthResult(error: Exception(e.toString()));
    }
  }

  /// Sign in anonymously.
  Future<AuthResult<User>> signInAnonymously() async {
    try {
      final userCred = await _auth.signInAnonymously();
      return AuthResult(data: userCred.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e, message: _firebaseErrorMessage(e));
    } catch (e) {
      return AuthResult(error: Exception(e.toString()));
    }
  }

  /// Send email verification to current user.
  Future<AuthResult<void>> sendEmailVerification() async {
    try {
      final u = _auth.currentUser;
      if (u == null) return AuthResult(error: Exception('No user currently signed in'));
      await u.sendEmailVerification();
      return AuthResult(data: null);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e, message: _firebaseErrorMessage(e));
    } catch (e) {
      return AuthResult(error: Exception(e.toString()));
    }
  }

  /// Check if current user's email is verified.
  Future<bool> isEmailVerified() async {
    final u = _auth.currentUser;
    if (u == null) return false;
    await u.reload();
    return u.emailVerified;
  }

  /// Refresh ID token (force refresh).
  Future<AuthResult<String>> getIdToken({bool forceRefresh = false}) async {
    try {
      final u = _auth.currentUser;
      if (u == null) return AuthResult(error: Exception('No user currently signed in'));
      final token = await u.getIdToken(forceRefresh);
      return AuthResult(data: token);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e, message: _firebaseErrorMessage(e));
    } catch (e) {
      return AuthResult(error: Exception(e.toString()));
    }
  }

  /// Re-authenticate the user with email+password (required for sensitive operations).
  Future<AuthResult<void>> reauthenticateWithEmail({required String email, required String password}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return AuthResult(error: Exception('No user currently signed in'));

      final cred = EmailAuthProvider.credential(email: email, password: password);
      await user.reauthenticateWithCredential(cred);
      return AuthResult(data: null);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e, message: _firebaseErrorMessage(e));
    } catch (e) {
      return AuthResult(error: Exception(e.toString()));
    }
  }

  /// Update profile displayName and photoURL.
  Future<AuthResult<User>> updateProfile({String? displayName, String? photoURL}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return AuthResult(error: Exception('No user currently signed in'));
      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoURL);
      await user.reload();
      return AuthResult(data: _auth.currentUser);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e, message: _firebaseErrorMessage(e));
    } catch (e) {
      return AuthResult(error: Exception(e.toString()));
    }
  }

  /// Delete current user.
  Future<AuthResult<void>> deleteUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return AuthResult(error: Exception('No user currently signed in'));
      await user.delete();
      return AuthResult(data: null);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e, message: _firebaseErrorMessage(e));
    } catch (e) {
      return AuthResult(error: Exception(e.toString()));
    }
  }

  /// Link Google credential to existing user account. Useful when linking providers.
  Future<AuthResult<User>> linkWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) return AuthResult(error: Exception('Google sign in aborted by user'));
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        // accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final user = _auth.currentUser;
      if (user == null) return AuthResult(error: Exception('No user currently signed in'));
      final userCred = await user.linkWithCredential(credential);
      return AuthResult(data: userCred.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e, message: _firebaseErrorMessage(e));
    } catch (e) {
      return AuthResult(error: Exception(e.toString()));
    }
  }

  /// Unlink a provider (e.g., 'google.com', 'phone', 'password') from the current user.
  Future<AuthResult<User>> unlinkProvider(String providerId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return AuthResult(error: Exception('No user currently signed in'));
      final updated = await user.unlink(providerId);
      return AuthResult(data: updated);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e, message: _firebaseErrorMessage(e));
    } catch (e) {
      return AuthResult(error: Exception(e.toString()));
    }
  }

  // ---------------------
  // PHONE (OTP) AUTH FLOW
  // ---------------------

  /// Starts phone number verification. Returns a verificationId on success.
  /// Note: On Android this will auto-retrieve in many cases; on iOS, you may need
  /// to handle verificationCompleted callback differently. For web you must use
  /// RecaptchaVerifier (not covered here).
  Future<AuthResult<String>> verifyPhoneNumber({
    required String phoneNumber,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final completer = Completer<AuthResult<String>>();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: timeout,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Android only: auto-retrieval or instant validation.
          try {
            final userCred = await _auth.signInWithCredential(credential);
            completer.complete(AuthResult(data: userCred.user?.uid));
          } catch (e) {
            completer.complete(AuthResult(error: Exception(e.toString())));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.complete(AuthResult(error: e, message: _firebaseErrorMessage(e)));
        },
        codeSent: (String verificationId, int? resendToken) async {
          completer.complete(AuthResult(data: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto retrieval timed out — still we may have codeSent result earlier.
        },
      );

      return completer.future;
    } catch (e) {
      return AuthResult(error: Exception(e.toString()));
    }
  }

  /// Sign in with SMS code (after verifyPhoneNumber returned verificationId).
  Future<AuthResult<User>> signInWithSmsCode({required String verificationId, required String smsCode}) async {
    try {
      final credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      final userCred = await _auth.signInWithCredential(credential);
      return AuthResult(data: userCred.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e, message: _firebaseErrorMessage(e));
    } catch (e) {
      return AuthResult(error: Exception(e.toString()));
    }
  }

  /// Link phone number to existing user (requires reauthentication sometimes).
  Future<AuthResult<User>> linkPhoneNumber({required String verificationId, required String smsCode}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return AuthResult(error: Exception('No user currently signed in'));
      final credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      final userCred = await user.linkWithCredential(credential);
      return AuthResult(data: userCred.user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(error: e, message: _firebaseErrorMessage(e));
    } catch (e) {
      return AuthResult(error: Exception(e.toString()));
    }
  }

  // ---------------------
  // Utilities
  // ---------------------

  /// Returns a user-friendly error message for common FirebaseAuth exceptions.
  String _firebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'The user account has been disabled.';
      case 'user-not-found':
        return 'No user found for the provided credentials.';
      case 'wrong-password':
        return 'Incorrect password provided for that user.';
      case 'email-already-in-use':
        return 'The email is already in use by another account.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please enable it in the Firebase console.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'invalid-verification-code':
        return 'The SMS verification code used is invalid.';
      case 'invalid-verification-id':
        return 'The SMS verification ID used is invalid.';
      default:
        return e.message ?? 'An undefined FirebaseAuth error occurred.';
    }
  }
}

// Example (brief):
// final auth = FirebaseAuthService.instance;
// auth.authStateChanges.listen((user) => print('User changed: $user'));
// final res = await auth.signInWithEmail(email: 'a@b.com', password: '123456');
// if (res.ok) { print('Signed in: ${res.data}'); } else { print('Error: ${res.message}'); }
