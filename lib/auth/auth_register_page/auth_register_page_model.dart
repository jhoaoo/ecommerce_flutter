import '/auth/component_auth/auth_verification_page/auth_verification_page_widget.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'auth_register_page_widget.dart' show AuthRegisterPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthRegisterPageModel extends FlutterFlowModel<AuthRegisterPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  // State field(s) for name_C widget.
  FocusNode? nameCFocusNode;
  TextEditingController? nameCTextController;
  String? Function(BuildContext, String?)? nameCTextControllerValidator;
  // State field(s) for password_C widget.
  FocusNode? passwordCFocusNode;
  TextEditingController? passwordCTextController;
  late bool passwordCVisibility;
  String? Function(BuildContext, String?)? passwordCTextControllerValidator;
  // State field(s) for Cpassword_C widget.
  FocusNode? cpasswordCFocusNode;
  TextEditingController? cpasswordCTextController;
  late bool cpasswordCVisibility;
  String? Function(BuildContext, String?)? cpasswordCTextControllerValidator;

  @override
  void initState(BuildContext context) {
    passwordCVisibility = false;
    cpasswordCVisibility = false;
  }

  @override
  void dispose() {
    emailFocusNode?.dispose();
    emailTextController?.dispose();

    nameCFocusNode?.dispose();
    nameCTextController?.dispose();

    passwordCFocusNode?.dispose();
    passwordCTextController?.dispose();

    cpasswordCFocusNode?.dispose();
    cpasswordCTextController?.dispose();
  }
}
