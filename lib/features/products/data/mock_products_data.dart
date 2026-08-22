import '../domain/product.dart';

/// Données mockées réalistes avec des images Unsplash haute résolution optimisées.
const List<Product> kMockProducts = [
  // --- Électronique / Audio ---
  Product(
    id: 'prod_001',
    title: 'Sony WH-1000XM5 Réduction de Bruit',
    description:
        'Casque audio circum-aural sans fil avec réduction de bruit adaptative haut de gamme. Doté de 8 microphones, 30 heures d\'autonomie et traitement sonore Hi-Res LDAC pour une immersion absolue.',
    price: 12000,
    category: 'Audio',
    rating: 4.9,
    imageUrl:
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&auto=format&fit=crop&q=80',
    isFavorite: true,
  ),
  Product(
    id: 'prod_002',
    title: 'Apple AirPods Pro (2ème Génération)',
    description:
        'Écouteurs intra-auriculaires sans fil avec puce H2, réduction active du bruit 2x plus efficace, mode Tr  ansparence adaptative et boîtier de charge MagSafe USB-C.',
    price: 5000,
    category: 'Audio',
    rating: 4.8,
    imageUrl:
        'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=800&auto=format&fit=crop&q=80',
    isFavorite: false,
  ),
  Product(
    id: 'prod_003',
    title: 'Enceinte Portable JBL Charge 5',
    description:
        'Enceinte Bluetooth nomade étanche (IP67) avec transducteur longue portée et radiateurs passifs pour des basses percutantes. Autonomie de 20 heures avec fonction powerbank intégrée.',
    price: 85000,
    category: 'Audio',
    rating: 4.7,
    imageUrl:
        'https://images.unsplash.com/photo-1545454675-3531b543be5d?w=800&auto=format&fit=crop&q=80',
    isFavorite: false,
  ),

  // --- High-Tech & Wearables ---
  Product(
    id: 'prod_004',
    title: 'Apple Watch Ultra 2 Titane',
    description:
        'La montre connectée d\'aventure par excellence : boîtier en titane aérospatial 49 mm, écran Retina OLED 3000 nits, GPS double fréquence ultra-précis et autonomie jusqu\'à 72h en mode économie.',
    price: 22000,
    category: 'Montres & Tech',
    rating: 4.9,
    imageUrl:
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
    isFavorite: true,
  ),
  Product(
    id: 'prod_005',
    title: 'Minimalist Chronograph Black Edition',
    description:
        'Montre chronographe élégante avec cadran noir mat brossé, mouvement à quartz japonais de haute précision, verre en cristal minéral anti-reflets et bracelet en cuir véritable.',
    price: 89000,
    category: 'Montres & Tech',
    rating: 4.6,
    imageUrl:
        'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=800&auto=format&fit=crop&q=80',
    isFavorite: false,
  ),
  Product(
    id: 'prod_006',
    title: 'Appareil Photo Mirrorless Alpha 4K',
    description:
        'Capteur plein format 33 MP, autofocus en temps réel avec suivi de l\'œil piloté par IA, stabilisation d\'image 5 axes intégrée et enregistrement vidéo cinématographique 4K 60p.',
    price: 1329000,
    category: 'Photo & Vidéo',
    rating: 5.0,
    imageUrl:
        'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800&auto=format&fit=crop&q=80',
    isFavorite: true,
  ),

  // --- Vêtements & Mode ---
  Product(
    id: 'prod_007',
    title: 'Veste Biker en Cuir Véritable',
    description:
        'Confection artisanale en cuir d\'agneau pleine fleur souple et résistant. Fermetures zippées YKK métalliques robustes, doublure thermique satinée et coupe slim fit moderne.',
    price: 279000,
    category: 'Vêtements',
    rating: 4.7,
    imageUrl:
        'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop&q=80',
    isFavorite: false,
  ),
  Product(
    id: 'prod_008',
    title: 'Hoodie Oversized Coton Bio',
    description:
        'Sweat à capuche épais en 100% coton biologique peigné (450 g/m²). Toucher velouté premium, finitions bords-côtes renforcées et coupe contemporaine décontractée.',
    price: 37000,
    category: 'Vêtements',
    rating: 4.5,
    imageUrl:
        'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&auto=format&fit=crop&q=80',
    isFavorite: false,
  ),

  // --- Chaussures / Sneakers ---
  Product(
    id: 'prod_009',
    title: 'Sneakers Heritage Classic White',
    description:
        'Baskets iconiques combinant cuir nappa souple et daim italien. Semelle intérieure ergonomique à mémoire de forme et semelle d\'usure en caoutchouc naturel recyclé pour un confort quotidien.',
    price: 18000,
    category: 'Chaussures',
    rating: 4.8,
    imageUrl:
        'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=800&auto=format&fit=crop&q=80',
    isFavorite: true,
  ),
  Product(
    id: 'prod_010',
    title: 'Running Pro Boost Carbon',
    description:
        'Chaussures de running haute performance intégrant une plaque de propulsion en fibre de carbone et amorti mousse supercritique ultra-réactif. Conçues pour battre vos records de vitesse.',
    price: 15000,
    category: 'Chaussures',
    rating: 4.9,
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80',
    isFavorite: false,
  ),

  // --- Bagagerie & Accessoires ---
  Product(
    id: 'prod_011',
    title: 'Sac à Dos Urban Commuter 25L',
    description:
        'Sac étanche en Cordura balistique avec compartiment matelassé pour ordinateur 16 pouces, poches magnétiques d\'accès rapide et passants ergonomiques respirants.',
    price: 8900,
    category: 'Accessoires',
    rating: 4.6,
    imageUrl:
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800&auto=format&fit=crop&q=80',
    isFavorite: false,
  ),
  Product(
    id: 'prod_012',
    title: 'Lunettes de Soleil Aviator Polarized',
    description:
        'Monture en acier chirurgical ultra-léger avec verres minéraux polarisants UV400 antireflet. Confort visuel optimal et style vintage raffiné.',
    price: 19000,
    category: 'Accessoires',
    rating: 4.7,
    imageUrl:
        'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800&auto=format&fit=crop&q=80',
    isFavorite: true,
  ),
];
