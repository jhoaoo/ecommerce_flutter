import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrdersRecord extends FirestoreRecord {
  OrdersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "userRef" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "createdAT" field.
  DateTime? _createdAT;
  DateTime? get createdAT => _createdAT;
  bool hasCreatedAT() => _createdAT != null;

  // "items" field.
  List<CartDTStruct>? _items;
  List<CartDTStruct> get items => _items ?? const [];
  bool hasItems() => _items != null;

  // "displayName" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "number" field.
  int? _number;
  int get number => _number ?? 0;
  bool hasNumber() => _number != null;

  // "paymentType" field.
  String? _paymentType;
  String get paymentType => _paymentType ?? '';
  bool hasPaymentType() => _paymentType != null;

  // "status" field.
  OrderStatus? _status;
  OrderStatus? get status => _status;
  bool hasStatus() => _status != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  void _initializeFields() {
    _userRef = snapshotData['userRef'] as DocumentReference?;
    _createdAT = snapshotData['createdAT'] as DateTime?;
    _items = getStructList(
      snapshotData['items'],
      CartDTStruct.fromMap,
    );
    _displayName = snapshotData['displayName'] as String?;
    _number = castToType<int>(snapshotData['number']);
    _paymentType = snapshotData['paymentType'] as String?;
    _status = snapshotData['status'] is OrderStatus
        ? snapshotData['status']
        : deserializeEnum<OrderStatus>(snapshotData['status']);
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('orders');

  static Stream<OrdersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OrdersRecord.fromSnapshot(s));

  static Future<OrdersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OrdersRecord.fromSnapshot(s));

  static OrdersRecord fromSnapshot(DocumentSnapshot snapshot) => OrdersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OrdersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OrdersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OrdersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OrdersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOrdersRecordData({
  DocumentReference? userRef,
  DateTime? createdAT,
  String? displayName,
  int? number,
  String? paymentType,
  OrderStatus? status,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'userRef': userRef,
      'createdAT': createdAT,
      'displayName': displayName,
      'number': number,
      'paymentType': paymentType,
      'status': status,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
    }.withoutNulls,
  );

  return firestoreData;
}

class OrdersRecordDocumentEquality implements Equality<OrdersRecord> {
  const OrdersRecordDocumentEquality();

  @override
  bool equals(OrdersRecord? e1, OrdersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.userRef == e2?.userRef &&
        e1?.createdAT == e2?.createdAT &&
        listEquality.equals(e1?.items, e2?.items) &&
        e1?.displayName == e2?.displayName &&
        e1?.number == e2?.number &&
        e1?.paymentType == e2?.paymentType &&
        e1?.status == e2?.status &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber;
  }

  @override
  int hash(OrdersRecord? e) => const ListEquality().hash([
        e?.userRef,
        e?.createdAT,
        e?.items,
        e?.displayName,
        e?.number,
        e?.paymentType,
        e?.status,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber
      ]);

  @override
  bool isValidKey(Object? o) => o is OrdersRecord;
}
