# Changelog

Toutes les modifications notables apportées à ce projet sont documentées dans ce fichier.
Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/) et ce projet adhère à la version sémantique [Semantic Versioning](https://semver.org/lang/fr/).

---

## [1.0.0] - 2026-09-02

### ✨ Ajouté
- **Accessibilité complète** : Intégration des `Semantics` et labels d'accessibilité sur tous les boutons interactifs, balises de prix et champs de formulaire.
- **Internationalisation (i18n)** : Support multi-langues complet Français (`fr`) et Anglais (`en`) via `flutter_localizations` et fichiers standard `.arb`.
- **Suite de tests complète (48 tests automatisés)** :
  - 33 tests unitaires (modèles, providers, notifiers, filtres).
  - 13 tests de widgets (boutons, badges, fiches de prix, états vides, cartes produits).
  - 2 tests d'intégration de flux bout en bout (parcours panier, catalogue et favoris).
- **Pipeline CI/CD GitHub Actions** : Automatisation de l'analyse statique (`flutter analyze`) et de l'exécution des tests à chaque push/PR.
- **Architecture Offline-First complète** : Persistance du panier et des favoris avec **Hive CE** et détection de connectivité en temps réel.

### ⚡ Amélioré
- Optimisation des performances à 60fps constants avec rendu d'images en cache et shimmer placeholder.
- Documentation exhaustive et structurée du projet.

---

## [0.2.0] - 2026-08-15

### ✨ Ajouté
- **Intégration Firebase Auth & Google Sign-In** : Connexion par email/mot de passe et compte Google.
- **Firestore Backend** : Synchronisation en temps réel du catalogue de produits et des commandes.
- **Système de Thèmes** : Basculement dynamique entre Light Mode et Dark Mode avec design system Material 3.
- **Composants d'interface riches** : `CustomBadge`, `CustomCachedImage`, `PriceTag` haute précision et `AnimatedAddToCartButton`.

### ⚡ Amélioré
- Refonte des cartes produits avec effets d'élévation et animations de micro-interactions.

---

## [0.1.0] - 2026-07-28

### ✨ Ajouté
- **Initialisation du projet Somba** : Mise en place de la Feature-First Clean Architecture.
- **Catalogue & Découverte** : Écran d'accueil avec bannières promotionnelles et carrousel d'offres.
- **Gestion d'état réactive** : Implémentation globale avec `flutter_riverpod`.
- **Fiches Produits** : Affichage des détails, avis clients et sélecteur de quantité.
