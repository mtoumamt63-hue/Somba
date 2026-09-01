import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';
import '../../domain/auth_state.dart';

// =============================================================================
// 1. REPOSITORY PROVIDER
// =============================================================================

/// Provider exposant l'instance unique du repository d'authentification.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// =============================================================================
// 2. AUTH STATE STREAM PROVIDER
// =============================================================================

/// StreamProvider écoutant les changements d'état d'authentification Firebase.
/// Réémet automatiquement à chaque connexion/déconnexion.
final authStateProvider = StreamProvider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

// =============================================================================
// 3. AUTH NOTIFIER — Actions login / register / logout
// =============================================================================

/// Notifier gérant les actions d'authentification avec états de chargement.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState.loading()) {
    // Écouter les changements d'état Firebase pour synchroniser l'état local
    _repository.authStateChanges.listen((user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  /// Connexion avec email et mot de passe.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      await _repository.signInWithEmail(email: email, password: password);
      // L'état sera mis à jour par le listener authStateChanges
    } on AuthException catch (e) {
      state = AuthState.unauthenticated(e.message);
    } catch (e) {
      state = AuthState.unauthenticated('Erreur inattendue : $e');
    }
  }

  /// Inscription avec email, mot de passe et nom complet.
  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = const AuthState.loading();
    try {
      await _repository.registerWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      );
      // L'état sera mis à jour par le listener authStateChanges
    } on AuthException catch (e) {
      state = AuthState.unauthenticated(e.message);
    } catch (e) {
      state = AuthState.unauthenticated('Erreur inattendue : $e');
    }
  }

  /// Connexion via Google Sign-In.
  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();
    try {
      await _repository.signInWithGoogle();
      // L'état sera mis à jour par le listener authStateChanges
    } on AuthException catch (e) {
      state = AuthState.unauthenticated(e.message);
    } catch (e) {
      state = AuthState.unauthenticated('Erreur inattendue : $e');
    }
  }

  /// Déconnexion complète (Firebase + Google).
  Future<void> signOut() async {
    try {
      await _repository.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.unauthenticated('Erreur de déconnexion : $e');
    }
  }

  /// Réinitialise le message d'erreur (ex: après affichage).
  void clearError() {
    if (state.errorMessage != null) {
      state = const AuthState.unauthenticated();
    }
  }
}

/// Provider principal du StateNotifier d'authentification.
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

// =============================================================================
// 4. PROVIDERS DÉRIVÉS UTILITAIRES
// =============================================================================

/// Provider booléen indiquant si l'utilisateur est connecté.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isAuthenticated;
});

/// Provider retournant le displayName de l'utilisateur connecté.
final currentUserNameProvider = Provider<String?>((ref) {
  return ref.watch(authNotifierProvider).user?.displayName;
});
