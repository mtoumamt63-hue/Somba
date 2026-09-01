import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Repository centralisant toutes les opérations d'authentification Firebase.
class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  /// Flux réactif des changements d'état d'authentification.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Utilisateur actuellement connecté (null si déconnecté).
  User? get currentUser => _firebaseAuth.currentUser;

  /// Vérifie si un utilisateur est actuellement connecté.
  bool get isSignedIn => currentUser != null;

  // ---------------------------------------------------------------------------
  // Connexion par Email / Mot de passe
  // ---------------------------------------------------------------------------

  /// Connecte un utilisateur avec son email et mot de passe.
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthError(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Inscription par Email / Mot de passe
  // ---------------------------------------------------------------------------

  /// Crée un nouveau compte utilisateur avec email, mot de passe et nom complet.
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Met à jour le displayName du profil Firebase
      await credential.user?.updateDisplayName(fullName.trim());
      await credential.user?.reload();

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthError(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Connexion Google Sign-In (v7.x authenticate)
  // ---------------------------------------------------------------------------

  /// Connecte un utilisateur via Google Sign-In.
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthError(e);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Erreur de connexion Google : $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Déconnexion
  // ---------------------------------------------------------------------------

  /// Déconnecte l'utilisateur de Firebase et de Google.
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      debugPrint('Erreur lors de la déconnexion : $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Réinitialisation du mot de passe
  // ---------------------------------------------------------------------------

  /// Envoie un email de réinitialisation de mot de passe.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthError(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Mapping des erreurs Firebase → Messages utilisateur en français
  // ---------------------------------------------------------------------------

  AuthException _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const AuthException('Aucun compte trouvé avec cet email.');
      case 'wrong-password':
        return const AuthException('Mot de passe incorrect.');
      case 'email-already-in-use':
        return const AuthException('Cet email est déjà utilisé par un autre compte.');
      case 'weak-password':
        return const AuthException(
            'Le mot de passe est trop faible. Utilisez au moins 6 caractères.');
      case 'invalid-email':
        return const AuthException('Adresse email invalide.');
      case 'user-disabled':
        return const AuthException('Ce compte a été désactivé.');
      case 'too-many-requests':
        return const AuthException(
            'Trop de tentatives. Veuillez réessayer plus tard.');
      case 'operation-not-allowed':
        return const AuthException('Cette méthode de connexion n\'est pas activée.');
      case 'invalid-credential':
        return const AuthException('Email ou mot de passe incorrect.');
      case 'network-request-failed':
        return const AuthException(
            'Erreur réseau. Vérifiez votre connexion internet.');
      default:
        return AuthException('Erreur d\'authentification : ${e.message ?? e.code}');
    }
  }
}

/// Exception d'authentification avec message utilisateur lisible.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
