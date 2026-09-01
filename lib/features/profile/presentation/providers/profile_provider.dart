import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/user_profile.dart';

/// Notifier gérant le profil de l'utilisateur connecté dynamiquement depuis Firebase.
class ProfileNotifier extends Notifier<UserProfile?> {
  @override
  UserProfile? build() {
    final firebaseUser = ref.watch(authStateProvider).value;
    if (firebaseUser == null) return null;

    final displayName = firebaseUser.displayName;
    final name = (displayName != null && displayName.trim().isNotEmpty)
        ? displayName
        : (firebaseUser.email?.split('@').first ?? 'Utilisateur Somba');

    return UserProfile(
      id: firebaseUser.uid,
      fullName: name,
      email: firebaseUser.email ?? '',
      phoneNumber: firebaseUser.phoneNumber ?? '+242 05 304 66 52',
      avatarUrl: firebaseUser.photoURL ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
      address: '80, rue Banda Poto-Poto, Brazzaville',
    );
  }

  void updateProfile(UserProfile updatedProfile) {
    state = updatedProfile;
  }

  Future<void> logout() async {
    await ref.read(authNotifierProvider.notifier).signOut();
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, UserProfile?>(
  ProfileNotifier.new,
);

