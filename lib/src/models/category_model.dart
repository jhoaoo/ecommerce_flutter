import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
  });

  final String id;
  final String name;
  final String description;
  final bool active;

  CategoryModel copyWith({String? id, String? name, String? description, bool? active}) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      active: active ?? this.active,
    );
  }

  factory CategoryModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return CategoryModel(
      id: doc.id,
      name: data['name']?.toString() ?? 'Categoria',
      description: data['description']?.toString() ?? '',
      active: data['active'] != false,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'description': description,
        'active': active,
        'updatedAt': FieldValue.serverTimestamp(),
      };
}
