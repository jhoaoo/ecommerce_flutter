import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:math';
import 'dart:ui';
import 'post_product_widget.dart' show PostProductWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PostProductModel extends FlutterFlowModel<PostProductWidget> {
  ///  Local state fields for this component.

  List<CategoriesDTStruct> localCategories = [];
  void addToLocalCategories(CategoriesDTStruct item) =>
      localCategories.add(item);
  void removeFromLocalCategories(CategoriesDTStruct item) =>
      localCategories.remove(item);
  void removeAtIndexFromLocalCategories(int index) =>
      localCategories.removeAt(index);
  void insertAtIndexInLocalCategories(int index, CategoriesDTStruct item) =>
      localCategories.insert(index, item);
  void updateLocalCategoriesAtIndex(
          int index, Function(CategoriesDTStruct) updateFn) =>
      localCategories[index] = updateFn(localCategories[index]);

  List<DocumentReference> documentLocalC = [];
  void addToDocumentLocalC(DocumentReference item) => documentLocalC.add(item);
  void removeFromDocumentLocalC(DocumentReference item) =>
      documentLocalC.remove(item);
  void removeAtIndexFromDocumentLocalC(int index) =>
      documentLocalC.removeAt(index);
  void insertAtIndexInDocumentLocalC(int index, DocumentReference item) =>
      documentLocalC.insert(index, item);
  void updateDocumentLocalCAtIndex(
          int index, Function(DocumentReference) updateFn) =>
      documentLocalC[index] = updateFn(documentLocalC[index]);

  bool buttonOneAction = false;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading_uploadDataHqn = false;
  FFUploadedFile uploadedLocalFile_uploadDataHqn =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // State field(s) for tittle_post_product widget.
  FocusNode? tittlePostProductFocusNode;
  TextEditingController? tittlePostProductTextController;
  String? Function(BuildContext, String?)?
      tittlePostProductTextControllerValidator;
  String? _tittlePostProductTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Enter product tittle is required';
    }

    return null;
  }

  // State field(s) for description_post_product widget.
  FocusNode? descriptionPostProductFocusNode;
  TextEditingController? descriptionPostProductTextController;
  String? Function(BuildContext, String?)?
      descriptionPostProductTextControllerValidator;
  String? _descriptionPostProductTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Enter product  description  is required';
    }

    return null;
  }

  // State field(s) for stock_p widget.
  FocusNode? stockPFocusNode;
  TextEditingController? stockPTextController;
  String? Function(BuildContext, String?)? stockPTextControllerValidator;
  String? _stockPTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Enter stock quantity is required';
    }

    return null;
  }

  // State field(s) for product_condition_p widget.
  FocusNode? productConditionPFocusNode;
  TextEditingController? productConditionPTextController;
  String? Function(BuildContext, String?)?
      productConditionPTextControllerValidator;
  String? _productConditionPTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Enter variant tittle  is required';
    }

    return null;
  }

  // State field(s) for price_p widget.
  FocusNode? pricePFocusNode;
  TextEditingController? pricePTextController;
  String? Function(BuildContext, String?)? pricePTextControllerValidator;
  String? _pricePTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return '\$ 0.0 is required';
    }

    return null;
  }

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  bool isDataUploading_uploadDataX30 = false;
  FFUploadedFile uploadedLocalFile_uploadDataX30 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataX30 = '';

  @override
  void initState(BuildContext context) {
    tittlePostProductTextControllerValidator =
        _tittlePostProductTextControllerValidator;
    descriptionPostProductTextControllerValidator =
        _descriptionPostProductTextControllerValidator;
    stockPTextControllerValidator = _stockPTextControllerValidator;
    productConditionPTextControllerValidator =
        _productConditionPTextControllerValidator;
    pricePTextControllerValidator = _pricePTextControllerValidator;
  }

  @override
  void dispose() {
    tittlePostProductFocusNode?.dispose();
    tittlePostProductTextController?.dispose();

    descriptionPostProductFocusNode?.dispose();
    descriptionPostProductTextController?.dispose();

    stockPFocusNode?.dispose();
    stockPTextController?.dispose();

    productConditionPFocusNode?.dispose();
    productConditionPTextController?.dispose();

    pricePFocusNode?.dispose();
    pricePTextController?.dispose();
  }
}
