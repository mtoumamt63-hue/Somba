# 🛍️ Somba — Application E-Commerce Moderne (Flutter & Firebase)

[![CI/CD Pipeline](https://github.com/mtoumamt63-hue/Somba/actions/workflows/ci.yml/badge.svg)](https://github.com/mtoumamt63-hue/Somba/actions)
[![Tests](https://img.shields.io/badge/Tests-48%20Passed-success?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Riverpod](https://img.shields.io/badge/State_Management-Riverpod-blueviolet?style=for-the-badge)](https://riverpod.dev/)
[![i18n](https://img.shields.io/badge/i18n-FR%20%7C%20EN-orange?style=for-the-badge)](https://flutter.dev/to/internationalization)
[![Accessibility](https://img.shields.io/badge/Accessibility-Semantics%20Ready-brightgreen?style=for-the-badge)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

**Somba** est une application e-commerce mobile complète, élégante et hautement réactive conçue avec **Flutter**, propulsée par **Firebase** et structurée selon les meilleures pratiques d'architecture logicielle (**Feature-First Architecture**).

Elle intègre une expérience utilisateur fluide avec une approche **Offline-First**, une gestion d'état déclarative via **Riverpod**, l'internationalisation **FR / EN**, l'accessibilité avec **Semantics**, et le support complet des modes **Clair et Sombre**.

---

## 📱 Aperçu Visuel & Écrans

| Authentification | Catalogue & Recherche | Fiche Produit | Panier & Commande | Profil & Favoris |
| :---: | :---: | :---: | :---: | :---: |
| 🔐 Connexion & Inscription | 🛍️ Carrousel & Filtres | 🔍 Détails & Avis | 🛒 Calculs Temps Réel | ❤️ Wishlist & Historique |

---

## 📱 Aperçu des Fonctionnalités

### 🔐 Authentification & Sécurité
- Connexion & Inscription sécurisées par **Email / Mot de passe**.
- Authentification rapide via **Google Sign-In**.
- Gestion transparente de l'état de session avec `AuthGate`.
- Profil utilisateur avec synchronisation en temps réel.

### 🛍️ Découverte & Catalogue Produits
- **Page d'accueil dynamique** : carrousel d'offres promotionnelles, bannières Héro et mise en avant des nouveautés.
- **Recherche en temps réel** et filtrage intuitif par catégories (Chips interactifs).
- **Fiche produit détaillée** : galerie d'images optimisée avec mise en cache, sélecteur de quantité, description extensible et avis.

### ❤️ Favoris & Panier Interactif
- Ajout et suppression instantanés de produits dans la liste des **Favoris (Wishlist)**.
- **Panier d'achat complet** : mise à jour dynamique des quantités, calcul automatique des sous-totaux, taxes et remises.
- Persistance locale du panier pour ne jamais perdre ses articles.

### ⚡ Architecture Offline-First & Performances
- **Stockage local ultra-rapide** propulsé par **Hive CE**.
- Détection continue de l'état réseau avec `connectivity_plus` et indicateur visuel hors-ligne (`OfflineBanner`).
- Mise en cache intelligente des images réseau (`cached_network_image`).
- Écrans de chargement animés avec effet Shimmer (`shimmer`).

### 🌐 Internationalisation (i18n) & Accessibilité
- Support multi-langues natif : **Français (`fr`)** et **Anglais (`en`)** configuré via `flutter_localizations`.
- Balises d'accessibilité `Semantics` sur les boutons interactifs, champs de texte, cartes et prix pour lecteurs d'écran (TalkBack / VoiceOver).

### 🎨 Design & Expérience Utilisateur (UI/UX)
- Support natif des thèmes **Light Mode** & **Dark Mode**.
- Typographie soignée via **Google Fonts**.
- Composants conformes aux standards **Material Design 3**.

---

## 🏗️ Architecture du Projet

Le projet suit une organisation **Feature-First / Clean Architecture** modulaire :

```
lib/
├── core/                       # Utilitaires globaux, thèmes, services transverses
│   ├── network/                # Services réseau & Firestore
│   ├── storage/                # Services de stockage local (Hive CE)
│   ├── theme/                  # Thèmes clair et sombre, couleurs, typographies
│   └── widgets/                # Composants UI réutilisables (Bannières, Shimmer, PriceTag, etc.)
├── features/                   # Modules applicatifs autonomes
│   ├── auth/                   # Authentification (Login, Register, Gate, Providers)
│   ├── cart/                   # Gestion du panier (Domain, Repositories, Providers, UI)
│   ├── favorites/              # Gestion des favoris / Wishlist
│   ├── main/                   # Navigation principale (Bottom Navigation Bar)
│   ├── products/               # Catalogue, détails, recherche et filtres
│   └── profile/                # Profil utilisateur & historique des commandes
├── l10n/                       # Dictionnaires d'internationalisation (.arb)
├── firebase_options.dart       # Configuration multi-plateforme générée par FlutterFire CLI
└── main.dart                   # Point d'entrée de l'application
```

---

## 🧪 Qualité du Code & Suite de Tests (48 Tests)

Le projet dispose d'une suite de tests complète exécutée via CI/CD :

```bash
# Lancer l'ensemble des 48 tests
flutter test

# Vérifier la conformité du code et l'analyse statique
flutter analyze
```

- **33 Tests Unitaires** : validation des modèles, Notifiers et calculs de prix.
- **13 Tests de Widgets** : validation des composants UI et interactions.
- **2 Tests d'Intégration** : scénarios complets de commande et gestion des favoris.

---

## 🚀 Démarrage Rapide

### Prérequis
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version `>= 3.12.2`)
- [Dart SDK](https://dart.dev/get-dart)
- Un compte [Firebase](https://firebase.google.com/) configuré avec un projet actif.
- Un émulateur Android / iOS ou un appareil physique connecté.

### Installation

1. **Cloner le dépôt GitHub :**
   ```bash
   git clone https://github.com/mtoumamt63-hue/Somba.git
   cd Somba
   ```

2. **Installer les dépendances & générer les traductions :**
   ```bash
   flutter pub get
   flutter gen-l10n
   ```

3. **Configurer Firebase :**
   ```bash
   flutterfire configure
   ```

4. **Lancer l'application :**
   ```bash
   flutter run
   ```

---

## 📦 Stack Technique & Dépendances Clés

| Package | Utilisation |
| :--- | :--- |
| **`flutter_riverpod`** | Gestion d'état réactive et injection de dépendances |
| **`flutter_localizations`** | Internationalisation (FR / EN) |
| **`firebase_auth` & `google_sign_in`** | Gestion des sessions et authentification Google |
| **`cloud_firestore`** | Base de données NoSQL temps réel dans le Cloud |
| **`hive_ce` / `hive_ce_flutter`** | Base de données locale NoSQL pour le mode Offline-First |
| **`connectivity_plus`** | Surveillance de l'état de la connexion Internet |
| **`cached_network_image`** | Chargement et mise en cache des images distantes |
| **`shimmer`** | Effets de squelette de chargement (Shimmer loading) |
| **`google_fonts`** | Typographie moderne et personnalisée |

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour toute suggestion ou amélioration :

1. Forkez le projet
2. Créez votre branche de fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'feat: Add some AmazingFeature'`)
4. Pushez vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une **Pull Request**

---

## 📄 Licence

Ce projet est sous licence open-source MIT. Consultez le fichier `LICENSE` pour plus de détails.
