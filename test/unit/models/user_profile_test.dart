import 'package:flutter_test/flutter_test.dart';
import 'package:somba/features/profile/domain/user_profile.dart';

void main() {
  group('UserProfile Model Tests', () {
    const testProfile = UserProfile(
      id: 'usr_77',
      fullName: 'Amadou Diallo',
      email: 'amadou.diallo@example.com',
      phoneNumber: '+221771234567',
      avatarUrl: 'https://example.com/avatar.jpg',
      address: 'Dakar, Sénégal',
    );

    test('doit créer un profil utilisateur complet', () {
      expect(testProfile.id, 'usr_77');
      expect(testProfile.fullName, 'Amadou Diallo');
      expect(testProfile.email, 'amadou.diallo@example.com');
      expect(testProfile.phoneNumber, '+221771234567');
      expect(testProfile.address, 'Dakar, Sénégal');
    });

    test('doit cloner avec copyWith', () {
      final updated = testProfile.copyWith(
        fullName: 'Amadou K. Diallo',
        address: 'Abidjan, Côte d\'Ivoire',
      );

      expect(updated.id, testProfile.id);
      expect(updated.fullName, 'Amadou K. Diallo');
      expect(updated.email, testProfile.email);
      expect(updated.address, 'Abidjan, Côte d\'Ivoire');
      expect(updated.phoneNumber, testProfile.phoneNumber);
    });

    test('doit sérialiser et désérialiser en JSON fidèlement', () {
      final json = testProfile.toJson();
      final parsed = UserProfile.fromJson(json);

      expect(parsed.id, testProfile.id);
      expect(parsed.fullName, testProfile.fullName);
      expect(parsed.email, testProfile.email);
      expect(parsed.phoneNumber, testProfile.phoneNumber);
      expect(parsed.address, testProfile.address);
    });
  });
}
