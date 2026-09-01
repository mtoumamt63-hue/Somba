import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app_exceptions.dart';

/// Gestionnaire et formateur centralisé des erreurs avec icônes et messages clairs en français.
class AppErrorHandler {
  /// Transforme n'importe quel objet d'erreur en un message lisible pour l'utilisateur.
  static String format(Object error) {
    if (error is AppException) {
      return error.message;
    }

    if (error is SocketException) {
      return 'Impossible de contacter le serveur. Vérifiez votre connexion Internet.';
    }

    if (error is TimeoutException) {
      return 'Délai d\'attente dépassé. Votre connexion semble instable.';
    }

    if (error is FirebaseException) {
      switch (error.code) {
        case 'unavailable':
          return 'Service temporairement indisponible. Vérifiez votre réseau.';
        case 'permission-denied':
          return 'Accès refusé. Vous n\'avez pas les droits nécessaires.';
        case 'not-found':
          return 'Ressource introuvable sur le serveur.';
        case 'deadline-exceeded':
          return 'Délai de réponse dépassé. Veuillez réessayer.';
        default:
          return error.message ?? 'Une erreur de communication est survenue.';
      }
    }

    final raw = error.toString();
    if (raw.startsWith('Exception: ')) {
      return raw.replaceFirst('Exception: ', '');
    }

    return 'Une erreur inattendue est survenue. Veuillez réessayer.';
  }

  /// Retourne l'icône la plus pertinente en fonction du type d'erreur.
  static IconData getIcon(Object error) {
    if (error is NoInternetException || error is SocketException) {
      return Icons.wifi_off_rounded;
    }

    if (error is NetworkTimeoutException || error is TimeoutException) {
      return Icons.timer_off_outlined;
    }

    if (error is ServerException || error is FirebaseException) {
      return Icons.cloud_off_rounded;
    }

    return Icons.error_outline_rounded;
  }
}
