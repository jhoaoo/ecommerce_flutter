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
    this.sellerId = 'demo-seller',
    this.taxRate = .18,
    this.discountRate = 0,
    this.lowStockThreshold = 5,
    this.documentUrl = '',
    this.active = true,
    this.approvalStatus = 'approved',
    this.rejectionReason = '',
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
  final String sellerId;
  final double taxRate;
  final double discountRate;
  final int lowStockThreshold;
  final String documentUrl;
  final bool active;
  final String approvalStatus;
  final String rejectionReason;

  bool get hasStock => stock > 0;
  bool get isLowStock => stock <= lowStockThreshold;
  bool get isApproved => approvalStatus == 'approved';
  bool get isPending => approvalStatus == 'pending';
  bool get isRejected => approvalStatus == 'rejected';
  double get discountAmount => price * discountRate;
  double get priceAfterDiscount => price - discountAmount;
  double get taxAmount => priceAfterDiscount * taxRate;
  double get finalPrice => priceAfterDiscount + taxAmount;

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? price,
    int? stock,
    String? imageUrl,
    double? rating,
    bool? isFeatured,
    String? sellerId,
    double? taxRate,
    double? discountRate,
    int? lowStockThreshold,
    String? documentUrl,
    bool? active,
    String? approvalStatus,
    String? rejectionReason,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      isFeatured: isFeatured ?? this.isFeatured,
      sellerId: sellerId ?? this.sellerId,
      taxRate: taxRate ?? this.taxRate,
      discountRate: discountRate ?? this.discountRate,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      documentUrl: documentUrl ?? this.documentUrl,
      active: active ?? this.active,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Product(
      id: doc.id,
      name: _readString(data['name'], 'Producto sin nombre'),
      description: _readString(data['description'], 'Sin descripcion'),
      category: _readString(data['category'], _readString(data['categoryName'], 'General')),
      price: _readDouble(data['price']),
      stock: _readInt(data['stock']),
      imageUrl: _readString(data['imageUrl'], ''),
      rating: _readDouble(data['rating'], fallback: 4.5),
      isFeatured: data['isFeatured'] == true || data['featured'] == true,
      sellerId: _readString(data['sellerId'], 'demo-seller'),
      taxRate: _readDouble(data['taxRate'], fallback: .18),
      discountRate: _readDouble(data['discountRate']),
      lowStockThreshold: _readInt(data['lowStockThreshold'], fallback: 5),
      documentUrl: _readString(data['documentUrl'], ''),
      active: data['active'] != false,
      approvalStatus: _readString(data['approvalStatus'], 'approved'),
      rejectionReason: _readString(data['rejectionReason'], ''),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'description': description,
        'category': category,
        'categoryName': category,
        'sellerId': sellerId,
        'price': price,
        'stock': stock,
        'imageUrl': imageUrl,
        'rating': rating,
        'isFeatured': isFeatured,
        'taxRate': taxRate,
        'discountRate': discountRate,
        'lowStockThreshold': lowStockThreshold,
        'documentUrl': documentUrl,
        'active': active,
        'approvalStatus': approvalStatus,
        'rejectionReason': rejectionReason,
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
