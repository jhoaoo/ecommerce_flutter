import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/user/components_user/user_drawer_component/user_drawer_component_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'user_checkout_page_widget.dart' show UserCheckoutPageWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserCheckoutPageModel extends FlutterFlowModel<UserCheckoutPageWidget> {
  ///  Local state fields for this page.

  List<double> priceCH = [];
  void addToPriceCH(double item) => priceCH.add(item);
  void removeFromPriceCH(double item) => priceCH.remove(item);
  void removeAtIndexFromPriceCH(int index) => priceCH.removeAt(index);
  void insertAtIndexInPriceCH(int index, double item) =>
      priceCH.insert(index, item);
  void updatePriceCHAtIndex(int index, Function(double) updateFn) =>
      priceCH[index] = updateFn(priceCH[index]);

  List<CartDTStruct> cartsDT = [];
  void addToCartsDT(CartDTStruct item) => cartsDT.add(item);
  void removeFromCartsDT(CartDTStruct item) => cartsDT.remove(item);
  void removeAtIndexFromCartsDT(int index) => cartsDT.removeAt(index);
  void insertAtIndexInCartsDT(int index, CartDTStruct item) =>
      cartsDT.insert(index, item);
  void updateCartsDTAtIndex(int index, Function(CartDTStruct) updateFn) =>
      cartsDT[index] = updateFn(cartsDT[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for stripe widget.
  bool? stripeValue;
  // State field(s) for yape widget.
  bool? yapeValue;
  // State field(s) for mercadoPago widget.
  bool? mercadoPagoValue;
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
