import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.rating,
    required this.isFeatured,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int stock;
  final String imageUrl;
  final double rating;
  final bool isFeatured;

  bool get hasStock => stock > 0;

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Product(
      id: doc.id,
      name: _readString(data['name'], 'Producto sin nombre'),
      description: _readString(data['description'], 'Sin descripción'),
      category: _readString(data['category'], 'General'),
      price: _readDouble(data['price']),
      stock: _readInt(data['stock']),
      imageUrl: _readString(data['imageUrl'], ''),
      rating: _readDouble(data['rating'], fallback: 4.5),
      isFeatured: data['isFeatured'] == true,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'description': description,
        'category': category,
        'price': price,
        'stock': stock,
        'imageUrl': imageUrl,
        'rating': rating,
        'isFeatured': isFeatured,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  static String _readString(Object? value, String fallback) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  static double _readDouble(Object? value, {double fallback = 0}) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static int _readInt(Object? value, {int fallback = 0}) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class CartItem {
  const CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  double get subtotal => product.price * quantity;

  CartItem copyWith({Product? product, int? quantity}) => CartItem(
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
      );
}

class CustomerOrder {
  const CustomerOrder({
    required this.id,
    required this.items,
    required this.total,
    required this.customerName,
    required this.customerEmail,
    required this.createdAt,
    required this.status,
  });

  final String id;
  final List<CartItem> items;
  final double total;
  final String customerName;
  final String customerEmail;
  final DateTime createdAt;
  final String status;
}

const demoProducts = <Product>[
  Product(
    id: 'keyboard-pro',
    name: 'Keyboard Pro X',
    description: 'Teclado mecánico compacto con switches táctiles y RGB sobrio.',
    category: 'Accesorios',
    price: 249.90,
    stock: 18,
    imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=900&q=80',
    rating: 4.8,
    isFeatured: true,
  ),
  Product(
    id: 'headset-air',
    name: 'Headset Air Studio',
    description: 'Audífonos inalámbricos con cancelación de ruido para estudio y gaming.',
    category: 'Audio',
    price: 319.00,
    stock: 12,
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=80',
    rating: 4.7,
    isFeatured: true,
  ),
  Product(
    id: 'smartwatch-fit',
    name: 'Smartwatch Fit 2',
    description: 'Reloj inteligente para entrenamiento, sueño y productividad diaria.',
    category: 'Wearables',
    price: 399.90,
    stock: 9,
    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=900&q=80',
    rating: 4.6,
    isFeatured: false,
  ),
  Product(
    id: 'backpack-tech',
    name: 'Backpack Tech Shield',
    description: 'Mochila urbana resistente al agua con compartimento para laptop.',
    category: 'Lifestyle',
    price: 189.50,
    stock: 21,
    imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=900&q=80',
    rating: 4.5,
    isFeatured: false,
  ),
  Product(
    id: 'mouse-precision',
    name: 'Mouse Precision 8K',
    description: 'Mouse ergonómico de alta precisión para trabajo, diseño y videojuegos.',
    category: 'Accesorios',
    price: 159.90,
    stock: 30,
    imageUrl: 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=900&q=80',
    rating: 4.9,
    isFeatured: true,
  ),
];
