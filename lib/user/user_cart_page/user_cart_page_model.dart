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
import 'user_cart_page_widget.dart' show UserCartPageWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserCartPageModel extends FlutterFlowModel<UserCartPageWidget> {
  ///  Local state fields for this page.

  List<CartDTStruct> localCards = [];
  void addToLocalCards(CartDTStruct item) => localCards.add(item);
  void removeFromLocalCards(CartDTStruct item) => localCards.remove(item);
  void removeAtIndexFromLocalCards(int index) => localCards.removeAt(index);
  void insertAtIndexInLocalCards(int index, CartDTStruct item) =>
      localCards.insert(index, item);
  void updateLocalCardsAtIndex(int index, Function(CartDTStruct) updateFn) =>
      localCards[index] = updateFn(localCards[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in user_cart_page widget.
  List<CartsRecord>? cartsRead;
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
