import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/user/components_user/product_cart_item/product_cart_item_widget.dart';
import '/user/components_user/user_drawer_component/user_drawer_component_widget.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'user_cart_page_model.dart';
export 'user_cart_page_model.dart';

class UserCartPageWidget extends StatefulWidget {
  const UserCartPageWidget({super.key});

  static String routeName = 'user_cart_page';
  static String routePath = '/userCartPage';

  @override
  State<UserCartPageWidget> createState() => _UserCartPageWidgetState();
}

class _UserCartPageWidgetState extends State<UserCartPageWidget> {
  late UserCartPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserCartPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.cartsRead = await queryCartsRecordOnce(
        parent: currentUserReference,
      );
      for (int loop1Index = 0;
          loop1Index < _model.cartsRead!.length;
          loop1Index++) {
        final currentLoop1Item = _model.cartsRead![loop1Index];
        _model.addToLocalCards(CartDTStruct(
          quantity: currentLoop1Item.quantity,
          productRef: currentLoop1Item.productRef,
          image: currentLoop1Item.image,
          productCards: currentLoop1Item.productsCard,
          price: currentLoop1Item.price,
          cartRef: currentLoop1Item.reference,
        ));
        safeSetState(() {});
      }
    });
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
        drawer: Container(
          width: MediaQuery.sizeOf(context).width * 0.7,
          child: Drawer(
            elevation: 16.0,
            child: wrapWithModel(
              model: _model.userDrawerComponentModel,
              updateCallback: () => safeSetState(() {}),
              child: UserDrawerComponentWidget(),
            ),
          ),
        ),
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
                    Padding(
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
              Builder(
                builder: (context) {
                  final cartsItem = _model.localCards.toList();

                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(cartsItem.length, (cartsItemIndex) {
                      final cartsItemItem = cartsItem[cartsItemIndex];
                      return ProductCartItemWidget(
                        key: Key(
                            'Key7t8_${cartsItemIndex}_of_${cartsItem.length}'),
                        cartDT: cartsItemItem,
                        updateCartAction: (newQuantity) async {
                          _model.updateLocalCardsAtIndex(
                            cartsItemIndex,
                            (e) => e..quantity = newQuantity,
                          );
                          safeSetState(() {});
                        },
                      );
                    }).divide(SizedBox(height: 8.0)),
                  );
                },
              ),
              FFButtonWidget(
                onPressed: () async {
                  for (int loop1Index = 0;
                      loop1Index < _model.localCards.length;
                      loop1Index++) {
                    final currentLoop1Item = _model.localCards[loop1Index];

                    await currentLoop1Item.cartRef!
                        .update(createCartsRecordData(
                      quantity: currentLoop1Item.quantity,
                    ));
                  }
                },
                text: 'save',
                options: FFButtonOptions(
                  height: 40.0,
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: Colors.white,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ].addToStart(SizedBox(height: 8.0)).addToEnd(SizedBox(height: 8.0)),
          ),
        ),
      ),
    );
  }
}
