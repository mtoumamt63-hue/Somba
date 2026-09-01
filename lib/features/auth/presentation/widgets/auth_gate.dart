import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../main/main_nav_scaffold.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';

/// Portail d'authentification réactif : redirige vers le catalogue ou l'écran de login
/// selon l'état de la session Firebase.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const MainNavScaffold();
        }
        return const LoginScreen();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
      error: (e, st) => const LoginScreen(),
    );
  }
}
