import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
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
  ///  State fields for stateful widgets in this component.

  bool isDataUploading_uploadDataHqn = false;
  FFUploadedFile uploadedLocalFile_uploadDataHqn =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // State field(s) for tittle_post_product widget.
  FocusNode? tittlePostProductFocusNode;
  TextEditingController? tittlePostProductTextController;
  String? Function(BuildContext, String?)?
      tittlePostProductTextControllerValidator;
  // State field(s) for description_post_product widget.
  FocusNode? descriptionPostProductFocusNode;
  TextEditingController? descriptionPostProductTextController;
  String? Function(BuildContext, String?)?
      descriptionPostProductTextControllerValidator;
  // State field(s) for stock_p widget.
  FocusNode? stockPFocusNode;
  TextEditingController? stockPTextController;
  String? Function(BuildContext, String?)? stockPTextControllerValidator;
  // State field(s) for product_condition_p widget.
  FocusNode? productConditionPFocusNode;
  TextEditingController? productConditionPTextController;
  String? Function(BuildContext, String?)?
      productConditionPTextControllerValidator;
  // State field(s) for price_p widget.
  FocusNode? pricePFocusNode;
  TextEditingController? pricePTextController;
  String? Function(BuildContext, String?)? pricePTextControllerValidator;
  bool isDataUploading_uploadDataX30 = false;
  FFUploadedFile uploadedLocalFile_uploadDataX30 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataX30 = '';

  @override
  void initState(BuildContext context) {}

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
