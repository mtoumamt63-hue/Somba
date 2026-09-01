import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Représente le statut d'authentification global de l'application.
enum AuthStatus {
  /// L'utilisateur est authentifié et possède une session active.
  authenticated,

  /// Aucune session active — l'utilisateur doit se connecter.
  unauthenticated,

  /// Vérification de l'état d'authentification en cours.
  loading,
}

/// État immutable encapsulant les informations d'authentification.
@immutable
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.loading,
    this.user,
    this.errorMessage,
  });

  /// Session active avec utilisateur connecté.
  const AuthState.authenticated(User this.user)
      : status = AuthStatus.authenticated,
        errorMessage = null;

  /// Aucune session active.
  const AuthState.unauthenticated([this.errorMessage])
      : status = AuthStatus.unauthenticated,
        user = null;

  /// Chargement / vérification en cours.
  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        errorMessage = null;

  /// Vérifie si l'utilisateur est connecté.
  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthState &&
          other.status == status &&
          other.user?.uid == user?.uid &&
          other.errorMessage == errorMessage);

  @override
  int get hashCode => Object.hash(status, user?.uid, errorMessage);
}
