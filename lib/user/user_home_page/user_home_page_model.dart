import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/user/components_user/card_products_section/card_products_section_widget.dart';
import '/user/components_user/carousel_user_component/carousel_user_component_widget.dart';
import '/user/components_user/user_drawer_component/user_drawer_component_widget.dart';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'user_home_page_widget.dart' show UserHomePageWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserHomePageModel extends FlutterFlowModel<UserHomePageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  // Model for carousel_user_component component.
  late CarouselUserComponentModel carouselUserComponentModel;
  // Model for card_products_section component.
  late CardProductsSectionModel cardProductsSectionModel;
  // Model for user_drawer_component component.
  late UserDrawerComponentModel userDrawerComponentModel;

  @override
  void initState(BuildContext context) {
    carouselUserComponentModel =
        createModel(context, () => CarouselUserComponentModel());
    cardProductsSectionModel =
        createModel(context, () => CardProductsSectionModel());
    userDrawerComponentModel =
        createModel(context, () => UserDrawerComponentModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    carouselUserComponentModel.dispose();
    cardProductsSectionModel.dispose();
    userDrawerComponentModel.dispose();
  }
}
