import '/backend/backend.dart';
import '/components/test_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'cart_user_page_model.dart';
export 'cart_user_page_model.dart';

class CartUserPageWidget extends StatefulWidget {
  const CartUserPageWidget({super.key});

  static String routeName = 'cart_user_page';
  static String routePath = '/cartUserPage';

  @override
  State<CartUserPageWidget> createState() => _CartUserPageWidgetState();
}

class _CartUserPageWidgetState extends State<CartUserPageWidget> {
  late CartUserPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CartUserPageModel());
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

            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        5.0,
                        0.0,
                        0.0,
                        0.0,
                      ),
                      child: FlutterFlowIconButton(
                        borderRadius: 8.0,

                        buttonSize: 40.0,
                        fillColor: Color(0x004E3F78),

                        icon: Icon(
                          Icons.dehaze,
                          color: Color(0xFF57636C),
                          size: 24.0,
                        ),

                        onPressed: () async {
                          scaffoldKey.currentState!.openDrawer();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      20.0,
                      20.0,
                      0.0,
                      30.0,
                    ),
                    child: Text(
                      'Your product',

                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontStyle: FlutterFlowTheme.of(
                            context,
                          ).bodyMedium.fontStyle,
                        ),

                        fontSize: 40.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w900,
                        fontStyle: FlutterFlowTheme.of(
                          context,
                        ).bodyMedium.fontStyle,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder<List<ProductsRecord>>(
                  stream: queryProductsRecord(),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      );
                    }
                    List<ProductsRecord> listViewProductsRecordList =
                        snapshot.data!;

                    return ListView.separated(
                      padding: EdgeInsets.zero,

                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: listViewProductsRecordList.length,
                      separatorBuilder: (_, __) => SizedBox(height: 11.0),
                      itemBuilder: (context, listViewIndex) {
                        final listViewProductsRecord =
                            listViewProductsRecordList[listViewIndex];
                        return Container(
                          width: 100.0,
                          height: 100.0,

                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(
                              context,
                            ).secondaryBackground,
                          ),

                          child: Stack(
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-0.83, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    listViewProductsRecord.images,
                                    width: 98.5,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, -0.81),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    0.0,
                                    0.0,
                                    20.0,
                                  ),
                                  child: Text(
                                    listViewProductsRecord.title,

                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontStyle,
                                          ),

                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontStyle,
                                        ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.3),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    20.0,
                                    0.0,
                                    0.0,
                                  ),
                                  child: Text(
                                    'Hello World',

                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontStyle,
                                          ),

                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontStyle,
                                        ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, -0.37),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    20.0,
                                    0.0,
                                    20.0,
                                  ),
                                  child: Text(
                                    'Hello World',

                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.fontStyle,
                                          ),

                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontStyle,
                                        ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.81, 0.0),
                                child: TestWidget(
                                  key: Key(
                                    'Keymlp_${listViewIndex}_of_${listViewProductsRecordList.length}',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
