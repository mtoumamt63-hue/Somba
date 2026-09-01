import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service gérant la détection et l'écoute de l'état du réseau (en ligne / hors-ligne).
class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// Vérifie si l'appareil est actuellement connecté à Internet (WiFi, Mobile, Ethernet, etc.).
  Future<bool> get isConnected async {
    try {
      final List<ConnectivityResult> results =
          await _connectivity.checkConnectivity();
      return _isOnline(results);
    } catch (_) {
      return false;
    }
  }

  /// Flux réactif émettant `true` si connecté, `false` si hors-ligne.
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isOnline);
  }

  bool _isOnline(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn);
  }
}

/// Provider pour injecter le service de connectivité.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// StreamProvider réactif indiquant l'état de la connexion (true = en ligne, false = hors-ligne).
final isOnlineProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onConnectivityChanged;
});
