import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/user/components_user/sales_history/sales_history_widget.dart';
import '/user/components_user/user_drawer_component/user_drawer_component_widget.dart';
import 'dart:ui';
import 'user_order_page_widget.dart' show UserOrderPageWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserOrderPageModel extends FlutterFlowModel<UserOrderPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for sales_history component.
  late SalesHistoryModel salesHistoryModel;
  // Model for user_drawer_component component.
  late UserDrawerComponentModel userDrawerComponentModel;

  @override
  void initState(BuildContext context) {
    salesHistoryModel = createModel(context, () => SalesHistoryModel());
    userDrawerComponentModel =
        createModel(context, () => UserDrawerComponentModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    salesHistoryModel.dispose();
    userDrawerComponentModel.dispose();
  }
}
