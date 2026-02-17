import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AddressesRecord extends FirestoreRecord {
  AddressesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "updateTime" field.
  DateTime? _updateTime;
  DateTime? get updateTime => _updateTime;
  bool hasUpdateTime() => _updateTime != null;

  // "createdTime" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "isDefault" field.
  bool? _isDefault;
  bool get isDefault => _isDefault ?? false;
  bool hasIsDefault() => _isDefault != null;

  // "latLng" field.
  LatLng? _latLng;
  LatLng? get latLng => _latLng;
  bool hasLatLng() => _latLng != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _updateTime = snapshotData['updateTime'] as DateTime?;
    _createdTime = snapshotData['createdTime'] as DateTime?;
    _isDefault = snapshotData['isDefault'] as bool?;
    _latLng = snapshotData['latLng'] as LatLng?;
    _address = snapshotData['address'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('addresses')
          : FirebaseFirestore.instance.collectionGroup('addresses');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('addresses').doc(id);

  static Stream<AddressesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AddressesRecord.fromSnapshot(s));

  static Future<AddressesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AddressesRecord.fromSnapshot(s));

  static AddressesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AddressesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AddressesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AddressesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AddressesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AddressesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAddressesRecordData({
  DateTime? updateTime,
  DateTime? createdTime,
  bool? isDefault,
  LatLng? latLng,
  String? address,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'updateTime': updateTime,
      'createdTime': createdTime,
      'isDefault': isDefault,
      'latLng': latLng,
      'address': address,
    }.withoutNulls,
  );

  return firestoreData;
}

class AddressesRecordDocumentEquality implements Equality<AddressesRecord> {
  const AddressesRecordDocumentEquality();

  @override
  bool equals(AddressesRecord? e1, AddressesRecord? e2) {
    return e1?.updateTime == e2?.updateTime &&
        e1?.createdTime == e2?.createdTime &&
        e1?.isDefault == e2?.isDefault &&
        e1?.latLng == e2?.latLng &&
        e1?.address == e2?.address;
  }

  @override
  int hash(AddressesRecord? e) => const ListEquality().hash(
      [e?.updateTime, e?.createdTime, e?.isDefault, e?.latLng, e?.address]);

  @override
  bool isValidKey(Object? o) => o is AddressesRecord;
}
