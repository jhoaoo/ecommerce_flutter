// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CategoriesDTStruct extends FFFirebaseStruct {
  CategoriesDTStruct({
    String? categoryName,
    DocumentReference? categoryRef,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _categoryName = categoryName,
        _categoryRef = categoryRef,
        super(firestoreUtilData);

  // "categoryName" field.
  String? _categoryName;
  String get categoryName => _categoryName ?? 'electro';
  set categoryName(String? val) => _categoryName = val;

  bool hasCategoryName() => _categoryName != null;

  // "categoryRef" field.
  DocumentReference? _categoryRef;
  DocumentReference? get categoryRef => _categoryRef;
  set categoryRef(DocumentReference? val) => _categoryRef = val;

  bool hasCategoryRef() => _categoryRef != null;

  static CategoriesDTStruct fromMap(Map<String, dynamic> data) =>
      CategoriesDTStruct(
        categoryName: data['categoryName'] as String?,
        categoryRef: data['categoryRef'] as DocumentReference?,
      );

  static CategoriesDTStruct? maybeFromMap(dynamic data) => data is Map
      ? CategoriesDTStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'categoryName': _categoryName,
        'categoryRef': _categoryRef,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'categoryName': serializeParam(
          _categoryName,
          ParamType.String,
        ),
        'categoryRef': serializeParam(
          _categoryRef,
          ParamType.DocumentReference,
        ),
      }.withoutNulls;

  static CategoriesDTStruct fromSerializableMap(Map<String, dynamic> data) =>
      CategoriesDTStruct(
        categoryName: deserializeParam(
          data['categoryName'],
          ParamType.String,
          false,
        ),
        categoryRef: deserializeParam(
          data['categoryRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['categories'],
        ),
      );

  @override
  String toString() => 'CategoriesDTStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CategoriesDTStruct &&
        categoryName == other.categoryName &&
        categoryRef == other.categoryRef;
  }

  @override
  int get hashCode => const ListEquality().hash([categoryName, categoryRef]);
}

CategoriesDTStruct createCategoriesDTStruct({
  String? categoryName,
  DocumentReference? categoryRef,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CategoriesDTStruct(
      categoryName: categoryName,
      categoryRef: categoryRef,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CategoriesDTStruct? updateCategoriesDTStruct(
  CategoriesDTStruct? categoriesDT, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    categoriesDT
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCategoriesDTStructData(
  Map<String, dynamic> firestoreData,
  CategoriesDTStruct? categoriesDT,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (categoriesDT == null) {
    return;
  }
  if (categoriesDT.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && categoriesDT.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final categoriesDTData =
      getCategoriesDTFirestoreData(categoriesDT, forFieldValue);
  final nestedData =
      categoriesDTData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = categoriesDT.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCategoriesDTFirestoreData(
  CategoriesDTStruct? categoriesDT, [
  bool forFieldValue = false,
]) {
  if (categoriesDT == null) {
    return {};
  }
  final firestoreData = mapToFirestore(categoriesDT.toMap());

  // Add any Firestore field values
  categoriesDT.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCategoriesDTListFirestoreData(
  List<CategoriesDTStruct>? categoriesDTs,
) =>
    categoriesDTs?.map((e) => getCategoriesDTFirestoreData(e, true)).toList() ??
    [];
