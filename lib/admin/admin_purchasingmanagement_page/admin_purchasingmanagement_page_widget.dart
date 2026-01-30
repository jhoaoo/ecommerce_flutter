import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_purchasingmanagement_page_model.dart';
export 'admin_purchasingmanagement_page_model.dart';

class AdminPurchasingmanagementPageWidget extends StatefulWidget {
  const AdminPurchasingmanagementPageWidget({super.key});

  static String routeName = 'admin_purchasingmanagement_page';
  static String routePath = '/adminPurchasingmanagementPage';

  @override
  State<AdminPurchasingmanagementPageWidget> createState() =>
      _AdminPurchasingmanagementPageWidgetState();
}

class _AdminPurchasingmanagementPageWidgetState
    extends State<AdminPurchasingmanagementPageWidget> {
  late AdminPurchasingmanagementPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminPurchasingmanagementPageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [],
          ),
        ),
      ),
    );
  }
}
