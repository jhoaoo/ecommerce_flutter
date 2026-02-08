import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/user/components_user/user_drawer_component/user_drawer_component_widget.dart';
import 'dart:ui';
import 'user_checkout_page_widget.dart' show UserCheckoutPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserCheckoutPageModel extends FlutterFlowModel<UserCheckoutPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for user_drawer_component component.
  late UserDrawerComponentModel userDrawerComponentModel;

  @override
  void initState(BuildContext context) {
    userDrawerComponentModel =
        createModel(context, () => UserDrawerComponentModel());
  }

  @override
  void dispose() {
    userDrawerComponentModel.dispose();
  }
}
