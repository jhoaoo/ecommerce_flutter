import '../core/app_role.dart';

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.targetRole,
    this.read = false,
  });

  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime createdAt;
  final AppRole? targetRole;
  final bool read;
}
