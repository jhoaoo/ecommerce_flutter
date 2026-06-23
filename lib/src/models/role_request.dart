import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/app_role.dart';

class RoleRequest {
  const RoleRequest({
    required this.id,
    required this.userId,
    required this.email,
    required this.requestedRole,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String email;
  final AppRole requestedRole;
  final String reason;
  final String status;
  final DateTime createdAt;

  factory RoleRequest.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return RoleRequest(
      id: doc.id,
      userId: data['userId']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      requestedRole: appRoleFromKey(data['requestedRole']?.toString()),
      reason: data['reason']?.toString() ?? '',
      status: data['status']?.toString() ?? 'pending',
      createdAt: _readDate(data['createdAt']),
    );
  }

  RoleRequest copyWith({String? status}) {
    return RoleRequest(
      id: id,
      userId: userId,
      email: email,
      requestedRole: requestedRole,
      reason: reason,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }

  static DateTime _readDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
