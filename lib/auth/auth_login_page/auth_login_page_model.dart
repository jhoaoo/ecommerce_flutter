import '/auth/component_auth/auth_verification_page/auth_verification_page_widget.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'auth_login_page_widget.dart' show AuthLoginPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthLoginPageModel extends FlutterFlowModel<AuthLoginPageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for email_L widget.
  FocusNode? emailLFocusNode;
  TextEditingController? emailLTextController;
  String? Function(BuildContext, String?)? emailLTextControllerValidator;
  String? _emailLTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'email is required';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // State field(s) for password_L widget.
  FocusNode? passwordLFocusNode;
  TextEditingController? passwordLTextController;
  late bool passwordLVisibility;
  String? Function(BuildContext, String?)? passwordLTextControllerValidator;
  String? _passwordLTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Password is required';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    emailLTextControllerValidator = _emailLTextControllerValidator;
    passwordLVisibility = false;
    passwordLTextControllerValidator = _passwordLTextControllerValidator;
  }

  @override
  void dispose() {
    emailLFocusNode?.dispose();
    emailLTextController?.dispose();

    passwordLFocusNode?.dispose();
    passwordLTextController?.dispose();
  }
}
