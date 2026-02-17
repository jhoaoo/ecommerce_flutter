import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  int _countPrice = 0;
  int get countPrice => _countPrice;
  set countPrice(int value) {
    _countPrice = value;
  }

  DocumentReference? _initialCategory =
      FirebaseFirestore.instance.doc('/categories/M47lsoKS1bhGVytlP4yk');
  DocumentReference? get initialCategory => _initialCategory;
  set initialCategory(DocumentReference? value) {
    _initialCategory = value;
  }
}
