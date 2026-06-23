import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/app_role.dart';
import '../core/firebase_bootstrapper.dart';
import '../models/demo_data.dart';
import '../models/models.dart';

class AuthService {
  AuthService({required this.firebase});

  final FirebaseBootstrapper firebase;

  FirebaseAuth get _auth => FirebaseAuth.instance;
  User? get currentFirebaseUser => firebase.isConnected ? _auth.currentUser : null;

  Stream<User?> authStateChanges() {
    if (!firebase.isConnected) return const Stream<User?>.empty();
    return _auth.authStateChanges();
  }

  Future<UserCredential?> registerWithEmail(String email, String password, String fullName) async {
    if (!firebase.isConnected) return null;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(fullName);
      await credential.user?.reload();
      return credential;
    } on FirebaseAuthException catch (error) {
      throw Exception('AUTH_CODE:${error.code}|MESSAGE:${error.message ?? ''}');
    } catch (error) {
      throw Exception('AUTH_UNKNOWN:$error');
    }
  }

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    if (!firebase.isConnected) return null;
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      throw Exception('AUTH_CODE:${error.code}|MESSAGE:${error.message ?? ''}');
    } catch (error) {
      throw Exception('AUTH_UNKNOWN:$error');
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    if (!firebase.isConnected) return null;
    try {
      if (kIsWeb) {
        return await _auth.signInWithPopup(GoogleAuthProvider());
      }

      final account = await GoogleSignIn().signIn();
      if (account == null) return null;
      final tokens = await account.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: tokens.accessToken, idToken: tokens.idToken);
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw Exception('AUTH_CODE:${error.code}|MESSAGE:${error.message ?? ''}');
    } catch (error) {
      throw Exception('AUTH_UNKNOWN:$error');
    }
  }

  Future<void> signOut() async {
    if (!firebase.isConnected) return;
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  Future<void> sendPasswordReset(String email) async {
    if (!firebase.isConnected) return;
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      throw Exception('AUTH_CODE:${error.code}|MESSAGE:${error.message ?? ''}');
    } catch (error) {
      throw Exception('AUTH_UNKNOWN:$error');
    }
  }

  AppUser demoUserForRole(AppRole role) {
    switch (role) {
      case AppRole.seller:
        return demoUsers[1];
      case AppRole.admin:
        return demoUsers[2];
      case AppRole.customer:
        return demoUsers[0];
    }
  }
}
