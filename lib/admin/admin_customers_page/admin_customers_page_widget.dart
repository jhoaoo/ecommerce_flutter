import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_customers_page_model.dart';
export 'admin_customers_page_model.dart';

class AdminCustomersPageWidget extends StatefulWidget {
  const AdminCustomersPageWidget({super.key});

  static String routeName = 'admin_customers_page';
  static String routePath = '/adminCustomersPage';

  @override
  State<AdminCustomersPageWidget> createState() =>
      _AdminCustomersPageWidgetState();
}

class _AdminCustomersPageWidgetState extends State<AdminCustomersPageWidget> {
  late AdminCustomersPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminCustomersPageModel());
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
          child: Column(mainAxisSize: MainAxisSize.max, children: []),
        ),
      ),
    );
  }
}
