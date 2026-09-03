import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/network/firestore_service.dart';
import 'core/storage/local_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/widgets/auth_gate.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Initialiser le stockage local persistant (Hive CE)
  await LocalStorageService.init();

  // 2. Initialiser Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Seeding des données initiales Firestore (si vide, non bloquant)
  FirestoreService().seedInitialDataIfEmpty().catchError((e) {
    debugPrint('Firestore seed skipped: $e');
  });

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Somba',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AuthGate(),
    );
  }
}

