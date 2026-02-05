import '/backend/backend.dart';
import '/components/test_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'card_products_component_widget.dart' show CardProductsComponentWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CardProductsComponentModel
    extends FlutterFlowModel<CardProductsComponentWidget> {
  ///  State fields for stateful widgets in this component.

  // Models for test dynamic component.
  late FlutterFlowDynamicModels<TestModel> testModels;

  @override
  void initState(BuildContext context) {
    testModels = FlutterFlowDynamicModels(() => TestModel());
  }

  @override
  void dispose() {
    testModels.dispose();
  }
}
