import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/seller/components_seller/cards_component/cards_component_widget.dart';
import 'dart:ui';
import 'dashboard_seller_widget.dart' show DashboardSellerWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardSellerModel extends FlutterFlowModel<DashboardSellerWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for cards_component component.
  late CardsComponentModel cardsComponentModel;

  @override
  void initState(BuildContext context) {
    cardsComponentModel = createModel(context, () => CardsComponentModel());
  }

  @override
  void dispose() {
    cardsComponentModel.dispose();
  }
}
