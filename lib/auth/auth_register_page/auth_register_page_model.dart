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

  final formKey = GlobalKey<FormState>();
  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  String? _emailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Email is required';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // State field(s) for name_C widget.
  FocusNode? nameCFocusNode;
  TextEditingController? nameCTextController;
  String? Function(BuildContext, String?)? nameCTextControllerValidator;
  String? _nameCTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Name is required';
    }

    if (!RegExp(kTextValidatorUsernameRegex).hasMatch(val)) {
      return 'Must start with a letter and can only contain letters, digits and - or _.';
    }
    return null;
  }

  // State field(s) for password_C widget.
  FocusNode? passwordCFocusNode;
  TextEditingController? passwordCTextController;
  late bool passwordCVisibility;
  String? Function(BuildContext, String?)? passwordCTextControllerValidator;
  String? _passwordCTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Password is required';
    }

    return null;
  }

  // State field(s) for Cpassword_C widget.
  FocusNode? cpasswordCFocusNode;
  TextEditingController? cpasswordCTextController;
  late bool cpasswordCVisibility;
  String? Function(BuildContext, String?)? cpasswordCTextControllerValidator;
  String? _cpasswordCTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Confirm password is required';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    emailTextControllerValidator = _emailTextControllerValidator;
    nameCTextControllerValidator = _nameCTextControllerValidator;
    passwordCVisibility = false;
    passwordCTextControllerValidator = _passwordCTextControllerValidator;
    cpasswordCVisibility = false;
    cpasswordCTextControllerValidator = _cpasswordCTextControllerValidator;
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
