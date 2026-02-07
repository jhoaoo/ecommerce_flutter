import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/user/components_user/product_cart_item/product_cart_item_widget.dart';
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
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
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
                    Text(
                      'shopping cart',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 22.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    Text(
                      'items',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
              ),
              StreamBuilder<List<CartsRecord>>(
                stream: queryCartsRecord(
                  parent: currentUserReference,
                ),
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
                  List<CartsRecord> columnCartsRecordList = snapshot.data!;

                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(columnCartsRecordList.length,
                        (columnIndex) {
                      final columnCartsRecord =
                          columnCartsRecordList[columnIndex];
                      return ProductCartItemWidget(
                        key: Key(
                            'Key7t8_${columnIndex}_of_${columnCartsRecordList.length}'),
                        parameter1: columnCartsRecord.image,
                        parameter2: columnCartsRecord.productsCard,
                        parameter3: valueOrDefault<String>(
                          formatNumber(
                            columnCartsRecord.price,
                            formatType: FormatType.decimal,
                            decimalType: DecimalType.automatic,
                            currency: '/S',
                          ),
                          '0',
                        ),
                        parameter4: valueOrDefault<String>(
                          formatNumber(
                            columnCartsRecord.price,
                            formatType: FormatType.decimal,
                            decimalType: DecimalType.automatic,
                            currency: '/s',
                          ),
                          '0',
                        ),
                      );
                    }).divide(SizedBox(height: 8.0)),
                  );
                },
              ),
            ].addToStart(SizedBox(height: 8.0)).addToEnd(SizedBox(height: 8.0)),
          ),
        ),
      ),
    );
  }
}
