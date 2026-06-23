import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/app_role.dart';
import 'notification_preferences.dart';
import 'payment_method.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.phone,
    required this.address,
    required this.photoUrl,
    required this.paymentMethods,
    required this.notifications,
    required this.createdAt,
    required this.demo,
    this.language = 'Español',
    this.darkMode = false,
  });

  final String id;
  final String email;
  final String fullName;
  final AppRole role;
  final String phone;
  final String address;
  final String photoUrl;
  final List<PaymentMethodProfile> paymentMethods;
  final NotificationPreferences notifications;
  final DateTime createdAt;
  final bool demo;
  final String language;
  final bool darkMode;

  AppUser copyWith({
    String? id,
    String? email,
    String? fullName,
    AppRole? role,
    String? phone,
    String? address,
    String? photoUrl,
    List<PaymentMethodProfile>? paymentMethods,
    NotificationPreferences? notifications,
    DateTime? createdAt,
    bool? demo,
    String? language,
    bool? darkMode,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      notifications: notifications ?? this.notifications,
      createdAt: createdAt ?? this.createdAt,
      demo: demo ?? this.demo,
      language: language ?? this.language,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final methods = (data['paymentMethods'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((entry) => PaymentMethodProfile.fromMap(Map<String, dynamic>.from(entry)))
        .toList();

    return AppUser(
      id: doc.id,
      email: data['email']?.toString() ?? '',
      fullName: data['fullName']?.toString() ?? 'Usuario ecommerce',
      role: appRoleFromKey(data['role']?.toString()),
      phone: data['phone']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      photoUrl: data['photoUrl']?.toString() ?? '',
      paymentMethods: methods,
      notifications: NotificationPreferences.fromMap(
        Map<String, dynamic>.from(data['notifications'] as Map? ?? {}),
      ),
      createdAt: _readDate(data['createdAt']),
      demo: data['demo'] == true,
      language: data['language']?.toString() ?? 'Español',
      darkMode: data['darkMode'] == true,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'email': email,
        'fullName': fullName,
        'role': role.key,
        'phone': phone,
        'address': address,
        'photoUrl': photoUrl,
        'paymentMethods': paymentMethods.map((method) => method.toMap()).toList(),
        'notifications': notifications.toMap(),
        'demo': demo,
        'language': language,
        'darkMode': darkMode,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  static DateTime _readDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
