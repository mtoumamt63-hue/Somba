import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/user_profile.dart';

/// Notifier gérant le profil de l'utilisateur connecté.
class ProfileNotifier extends Notifier<UserProfile?> {
  @override
  UserProfile? build() {
    // Données de profil utilisateur par défaut pour démonstration
    return const UserProfile(
      id: 'usr_001',
      fullName: 'Zénas Alpha TOUMAINI',
      email: 'mtoumamt63@gmail.com',
      phoneNumber: '+242 05 304 66 52',
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
      address: '80, rue Banda Poto-Poto',
    );
  }

  void updateProfile(UserProfile updatedProfile) {
    state = updatedProfile;
  }

  void logout() {
    state = null;
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, UserProfile?>(
  ProfileNotifier.new,
);
