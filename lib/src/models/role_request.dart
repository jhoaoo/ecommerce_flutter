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
}
