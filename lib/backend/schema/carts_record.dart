import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CartsRecord extends FirestoreRecord {
  CartsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "productsCard" field.
  String? _productsCard;
  String get productsCard => _productsCard ?? '';
  bool hasProductsCard() => _productsCard != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  bool hasPrice() => _price != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  bool hasQuantity() => _quantity != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _productsCard = snapshotData['productsCard'] as String?;
    _price = castToType<double>(snapshotData['price']);
    _image = snapshotData['image'] as String?;
    _quantity = castToType<int>(snapshotData['quantity']);
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('carts')
          : FirebaseFirestore.instance.collectionGroup('carts');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('carts').doc(id);

  static Stream<CartsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CartsRecord.fromSnapshot(s));

  static Future<CartsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CartsRecord.fromSnapshot(s));

  static CartsRecord fromSnapshot(DocumentSnapshot snapshot) => CartsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CartsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CartsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CartsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CartsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCartsRecordData({
  String? productsCard,
  double? price,
  String? image,
  int? quantity,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'productsCard': productsCard,
      'price': price,
      'image': image,
      'quantity': quantity,
    }.withoutNulls,
  );

  return firestoreData;
}

class CartsRecordDocumentEquality implements Equality<CartsRecord> {
  const CartsRecordDocumentEquality();

  @override
  bool equals(CartsRecord? e1, CartsRecord? e2) {
    return e1?.productsCard == e2?.productsCard &&
        e1?.price == e2?.price &&
        e1?.image == e2?.image &&
        e1?.quantity == e2?.quantity;
  }

  @override
  int hash(CartsRecord? e) => const ListEquality()
      .hash([e?.productsCard, e?.price, e?.image, e?.quantity]);

  @override
  bool isValidKey(Object? o) => o is CartsRecord;
}
