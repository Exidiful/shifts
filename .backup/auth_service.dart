import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendVerificationCode(
    String phoneNumber,
    Function(String, int?) codeSent,
    Function(FirebaseAuthException) verificationFailed,
    Function(String) codeAutoRetrievalTimeout,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieve may be enabled on some devices. In this case, we don't need to do anything.
      },
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      timeout: const Duration(seconds: 60),
    );
  }

  Future<UserCredential> verifyCode(String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Future<String?> signInWithPhoneNumber(String phoneNumber) async {
    Completer<String?> completer = Completer<String?>();
    
    await sendVerificationCode(
      phoneNumber,
      (verificationId, resendToken) async {
        // Here, we should show a dialog to enter the SMS code
        // For now, we'll just complete with the verificationId
        completer.complete(verificationId);
      },
      (error) {
        completer.completeError(error);
      },
      (verificationId) {
        // Timeout, handle if needed
      },
    );

    return completer.future;
  }
}
