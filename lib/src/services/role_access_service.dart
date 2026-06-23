import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/app_collections.dart';
import '../core/app_role.dart';
import '../models/models.dart';
import 'firestore_service.dart';

class RoleAccessService {
  RoleAccessService({required this.firestoreService});

  final FirestoreService firestoreService;

  Future<RoleRequest> requestRole({
    required AppUser user,
    required AppRole requestedRole,
    required String reason,
  }) async {
    final request = RoleRequest(
      id: 'REQ-${DateTime.now().millisecondsSinceEpoch}',
      userId: user.id,
      email: user.email,
      requestedRole: requestedRole,
      reason: reason,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    await firestoreService.setDocument(AppCollections.roleRequests, request.id, {
      'userId': request.userId,
      'email': request.email,
      'requestedRole': request.requestedRole.key,
      'reason': request.reason,
      'status': request.status,
      'createdAt': Timestamp.fromDate(request.createdAt),
    });

    return request;
  }
}
