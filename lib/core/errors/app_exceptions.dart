/// Exceptions typées personnalisées pour l'application Somba.
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}

/// Absence totale de connexion Internet.
class NoInternetException extends AppException {
  const NoInternetException([
    super.message =
        'Aucune connexion Internet. Veuillez vérifier votre Wi-Fi ou vos données mobiles.',
  ]);
}

/// Délai d'attente dépassé lors d'une requête réseau.
class NetworkTimeoutException extends AppException {
  const NetworkTimeoutException([
    super.message =
        'La requête a mis trop de temps à répondre. Veuillez réessayer.',
  ]);
}

/// Erreur côté serveur distant / Firebase.
class ServerException extends AppException {
  const ServerException([
    super.message =
        'Le serveur distant a rencontré une difficulté. Veuillez réessayer dans quelques instants.',
    String? code,
  ]) : super(code: code);
}

/// Erreur de cache local ou de stockage.
class CacheException extends AppException {
  const CacheException([
    super.message = 'Impossible de charger les données sauvegardées.',
  ]);
}
