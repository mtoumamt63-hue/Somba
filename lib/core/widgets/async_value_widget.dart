import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'error_view.dart';

/// Widget générique réutilisable pour gérer harmonieusement les états `AsyncValue<T>`
/// de Riverpod (`data`, `loading`, `error`) avec support complet des modes Box et Sliver.
class AsyncValueWidget<T> extends StatelessWidget {
  /// L'instance `AsyncValue<T>` observée via Riverpod.
  final AsyncValue<T> value;

  /// Callback exécuté lorsque les données sont disponibles.
  final Widget Function(T data) data;

  /// Constructeur optionnel pour la vue de chargement.
  final Widget Function()? loading;

  /// Constructeur optionnel pour la vue d'erreur.
  final Widget Function(Object error, StackTrace? stackTrace)? error;

  /// Action de réessai.
  final VoidCallback? onRetry;

  /// Si vrai, configure le widget pour retourner des Slivers (`SliverToBoxAdapter` / `SliverFillRemaining`).
  final bool isSliver;

  /// Si vrai, conserve les données précédentes pendant le rechargement.
  final bool skipLoadingOnReload;

  /// Si vrai, conserve les données précédentes lors du rafraîchissement (pull-to-refresh).
  final bool skipLoadingOnRefresh;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.onRetry,
    this.isSliver = false,
    this.skipLoadingOnReload = false,
    this.skipLoadingOnRefresh = true,
  });

  /// Constructeur dédié aux listes et grilles dans un `CustomScrollView.slivers`.
  const AsyncValueWidget.sliver({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.onRetry,
    this.skipLoadingOnReload = false,
    this.skipLoadingOnRefresh = true,
  }) : isSliver = true;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnReload: skipLoadingOnReload,
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      data: data,
      loading: () {
        if (loading != null) {
          return loading!();
        }
        if (isSliver) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator.adaptive(strokeWidth: 2.5),
              ),
            ),
          );
        }
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator.adaptive(strokeWidth: 2.5),
          ),
        );
      },
      error: (err, stack) {
        if (error != null) {
          return error!(err, stack);
        }
        final errorWidget = ErrorView(
          message: _formatErrorMessage(err),
          onRetry: onRetry,
        );

        if (isSliver) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: errorWidget,
          );
        }
        return errorWidget;
      },
    );
  }

  /// Nettoie les messages d'erreur techniques pour l'affichage utilisateur.
  String _formatErrorMessage(Object error) {
    final raw = error.toString();
    if (raw.startsWith('Exception: ')) {
      return raw.replaceFirst('Exception: ', '');
    }
    return raw;
  }
}
