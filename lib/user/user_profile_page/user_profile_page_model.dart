import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/user/components_user/user_drawer_component/user_drawer_component_widget.dart';
import 'dart:ui';
import 'user_profile_page_widget.dart' show UserProfilePageWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserProfilePageModel extends FlutterFlowModel<UserProfilePageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading_uploadDataZpv = false;
  FFUploadedFile uploadedLocalFile_uploadDataZpv =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataZpv = '';

  // State field(s) for nameEdit widget.
  FocusNode? nameEditFocusNode;
  TextEditingController? nameEditTextController;
  String? Function(BuildContext, String?)? nameEditTextControllerValidator;
  // State field(s) for NumberEdit widget.
  FocusNode? numberEditFocusNode;
  TextEditingController? numberEditTextController;
  String? Function(BuildContext, String?)? numberEditTextControllerValidator;
  // State field(s) for birthdateEdit widget.
  FocusNode? birthdateEditFocusNode;
  TextEditingController? birthdateEditTextController;
  String? Function(BuildContext, String?)? birthdateEditTextControllerValidator;
  // Model for user_drawer_component component.
  late UserDrawerComponentModel userDrawerComponentModel;

  @override
  void initState(BuildContext context) {
    userDrawerComponentModel =
        createModel(context, () => UserDrawerComponentModel());
  }

  @override
  void dispose() {
    nameEditFocusNode?.dispose();
    nameEditTextController?.dispose();

    numberEditFocusNode?.dispose();
    numberEditTextController?.dispose();

    birthdateEditFocusNode?.dispose();
    birthdateEditTextController?.dispose();

    userDrawerComponentModel.dispose();
  }
}
