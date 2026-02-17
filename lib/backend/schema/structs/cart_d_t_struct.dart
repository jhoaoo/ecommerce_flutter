// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CartDTStruct extends FFFirebaseStruct {
  CartDTStruct({
    int? quantity,
    DocumentReference? productRef,
    String? image,
    String? productName,
    double? price,
    DocumentReference? cartRef,
    DateTime? time,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _quantity = quantity,
        _productRef = productRef,
        _image = image,
        _productName = productName,
        _price = price,
        _cartRef = cartRef,
        _time = time,
        super(firestoreUtilData);

  // "quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  set quantity(int? val) => _quantity = val;

  void incrementQuantity(int amount) => quantity = quantity + amount;

  bool hasQuantity() => _quantity != null;

  // "productRef" field.
  DocumentReference? _productRef;
  DocumentReference? get productRef => _productRef;
  set productRef(DocumentReference? val) => _productRef = val;

  bool hasProductRef() => _productRef != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  set image(String? val) => _image = val;

  bool hasImage() => _image != null;

  // "productName" field.
  String? _productName;
  String get productName => _productName ?? '';
  set productName(String? val) => _productName = val;

  bool hasProductName() => _productName != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  set price(double? val) => _price = val;

  void incrementPrice(double amount) => price = price + amount;

  bool hasPrice() => _price != null;

  // "cartRef" field.
  DocumentReference? _cartRef;
  DocumentReference? get cartRef => _cartRef;
  set cartRef(DocumentReference? val) => _cartRef = val;

  bool hasCartRef() => _cartRef != null;

  // "time" field.
  DateTime? _time;
  DateTime? get time => _time;
  set time(DateTime? val) => _time = val;

  bool hasTime() => _time != null;

  static CartDTStruct fromMap(Map<String, dynamic> data) => CartDTStruct(
        quantity: castToType<int>(data['quantity']),
        productRef: data['productRef'] as DocumentReference?,
        image: data['image'] as String?,
        productName: data['productName'] as String?,
        price: castToType<double>(data['price']),
        cartRef: data['cartRef'] as DocumentReference?,
        time: data['time'] as DateTime?,
      );

  static CartDTStruct? maybeFromMap(dynamic data) =>
      data is Map ? CartDTStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'quantity': _quantity,
        'productRef': _productRef,
        'image': _image,
        'productName': _productName,
        'price': _price,
        'cartRef': _cartRef,
        'time': _time,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'quantity': serializeParam(
          _quantity,
          ParamType.int,
        ),
        'productRef': serializeParam(
          _productRef,
          ParamType.DocumentReference,
        ),
        'image': serializeParam(
          _image,
          ParamType.String,
        ),
        'productName': serializeParam(
          _productName,
          ParamType.String,
        ),
        'price': serializeParam(
          _price,
          ParamType.double,
        ),
        'cartRef': serializeParam(
          _cartRef,
          ParamType.DocumentReference,
        ),
        'time': serializeParam(
          _time,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static CartDTStruct fromSerializableMap(Map<String, dynamic> data) =>
      CartDTStruct(
        quantity: deserializeParam(
          data['quantity'],
          ParamType.int,
          false,
        ),
        productRef: deserializeParam(
          data['productRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['products'],
        ),
        image: deserializeParam(
          data['image'],
          ParamType.String,
          false,
        ),
        productName: deserializeParam(
          data['productName'],
          ParamType.String,
          false,
        ),
        price: deserializeParam(
          data['price'],
          ParamType.double,
          false,
        ),
        cartRef: deserializeParam(
          data['cartRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['user', 'carts'],
        ),
        time: deserializeParam(
          data['time'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'CartDTStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CartDTStruct &&
        quantity == other.quantity &&
        productRef == other.productRef &&
        image == other.image &&
        productName == other.productName &&
        price == other.price &&
        cartRef == other.cartRef &&
        time == other.time;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([quantity, productRef, image, productName, price, cartRef, time]);
}

CartDTStruct createCartDTStruct({
  int? quantity,
  DocumentReference? productRef,
  String? image,
  String? productName,
  double? price,
  DocumentReference? cartRef,
  DateTime? time,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CartDTStruct(
      quantity: quantity,
      productRef: productRef,
      image: image,
      productName: productName,
      price: price,
      cartRef: cartRef,
      time: time,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CartDTStruct? updateCartDTStruct(
  CartDTStruct? cartDT, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    cartDT
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCartDTStructData(
  Map<String, dynamic> firestoreData,
  CartDTStruct? cartDT,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (cartDT == null) {
    return;
  }
  if (cartDT.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && cartDT.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final cartDTData = getCartDTFirestoreData(cartDT, forFieldValue);
  final nestedData = cartDTData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = cartDT.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCartDTFirestoreData(
  CartDTStruct? cartDT, [
  bool forFieldValue = false,
]) {
  if (cartDT == null) {
    return {};
  }
  final firestoreData = mapToFirestore(cartDT.toMap());

  // Add any Firestore field values
  cartDT.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCartDTListFirestoreData(
  List<CartDTStruct>? cartDTs,
) =>
    cartDTs?.map((e) => getCartDTFirestoreData(e, true)).toList() ?? [];
