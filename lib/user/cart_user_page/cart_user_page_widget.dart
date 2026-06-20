import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Stream<QuerySnapshot> _cartStream() {
    return FirebaseFirestore.instance
        .collection('cart_items')
        .where('userRef', isEqualTo: currentUserReference)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  double _cartTotal(List<QueryDocumentSnapshot> docs) {
    return docs.fold<double>(0.0, (total, doc) {
      final data = doc.data() as Map<String, dynamic>;
      final price = castToType<double>(data['price']) ?? 0.0;
      final quantity = castToType<int>(data['quantity']) ?? 1;
      return total + (price * quantity);
    });
  }

  Future<void> _updateQuantity(DocumentReference ref, int current, int change) async {
    final nextValue = current + change;
    if (nextValue <= 0) {
      await ref.delete();
      return;
    }
    await ref.update({'quantity': nextValue});
  }

  Future<void> _removeItem(DocumentReference ref) async {
    await ref.delete();
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
          child: currentUserReference == null
              ? _LoginRequiredMessage()
              : StreamBuilder<QuerySnapshot>(
                  stream: _cartStream(),
                  builder: (context, snapshot) {
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

                    final cartDocs = snapshot.data!.docs;
                    final total = _cartTotal(cartDocs);

                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _CartHeader(onBack: () => context.safePop()),
                        Expanded(
                          child: cartDocs.isEmpty
                              ? _EmptyCartMessage()
                              : ListView.separated(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 8.0, 16.0, 16.0),
                                  itemCount: cartDocs.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 14.0),
                                  itemBuilder: (context, index) {
                                    final doc = cartDocs[index];
                                    final data =
                                        doc.data() as Map<String, dynamic>;
                                    return _CartItemCard(
                                      data: data,
                                      onRemove: () => _removeItem(doc.reference),
                                      onIncrement: () => _updateQuantity(
                                        doc.reference,
                                        castToType<int>(data['quantity']) ?? 1,
                                        1,
                                      ),
                                      onDecrement: () => _updateQuantity(
                                        doc.reference,
                                        castToType<int>(data['quantity']) ?? 1,
                                        -1,
                                      ),
                                    );
                                  },
                                ),
                        ),
                        _CartSummary(
                          itemCount: cartDocs.length,
                          total: total,
                          onCheckout: cartDocs.isEmpty
                              ? null
                              : () async {
                                  context.pushNamed('user_checkout_page');
                                },
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _CartHeader extends StatelessWidget {
  const _CartHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 20.0, 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          FlutterFlowIconButton(
            borderRadius: 12.0,
            buttonSize: 42.0,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 22.0,
            ),
            onPressed: onBack,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your cart',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w900,
                            fontStyle: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontStyle,
                          ),
                          fontSize: 34.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  Text(
                    'Review your selected products',
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
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.data,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  final Map<String, dynamic> data;
  final Future<void> Function() onRemove;
  final Future<void> Function() onIncrement;
  final Future<void> Function() onDecrement;

  @override
  Widget build(BuildContext context) {
    final title = valueOrDefault<String>(data['title'] as String?, 'Product');
    final description =
        valueOrDefault<String>(data['description'] as String?, 'Selected item');
    final image = valueOrDefault<String>(data['image'] as String?, '');
    final price = castToType<double>(data['price']) ?? 0.0;
    final quantity = castToType<int>(data['quantity']) ?? 1;
    final priceText = formatNumber(
      price,
      formatType: FormatType.decimal,
      decimalType: DecimalType.periodDecimal,
      currency: 'S/ ',
    );
    final subtotalText = formatNumber(
      price * quantity,
      formatType: FormatType.decimal,
      decimalType: DecimalType.periodDecimal,
      currency: 'S/ ',
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: Color(0x14000000),
            offset: Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: image.isNotEmpty
                ? Image.network(
                    image,
                    width: 90.0,
                    height: 90.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _ImageFallback(),
                  )
                : _ImageFallback(),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 8.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w800,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 6.0),
                    child: Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        priceText,
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.interTight(
                                fontWeight: FontWeight.w800,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Text(
                        subtotalText,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FlutterFlowIconButton(
                borderRadius: 10.0,
                buttonSize: 34.0,
                fillColor: Color(0x00FFFFFF),
                icon: Icon(
                  Icons.delete_outline,
                  color: FlutterFlowTheme.of(context).error,
                  size: 20.0,
                ),
                onPressed: onRemove,
              ),
              Container(
                margin: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: onDecrement,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            6.0, 6.0, 6.0, 6.0),
                        child: Icon(
                          Icons.remove_rounded,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 18.0,
                        ),
                      ),
                    ),
                    Text(
                      quantity.toString(),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w800,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    InkWell(
                      onTap: onIncrement,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            6.0, 6.0, 6.0, 6.0),
                        child: Icon(
                          Icons.add_rounded,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({
    required this.itemCount,
    required this.total,
    required this.onCheckout,
  });

  final int itemCount;
  final double total;
  final Future<void> Function()? onCheckout;

  @override
  Widget build(BuildContext context) {
    final totalText = formatNumber(
      total,
      formatType: FormatType.decimal,
      decimalType: DecimalType.periodDecimal,
      currency: 'S/ ',
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 20.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            color: Color(0x1A000000),
            offset: Offset(0.0, -4.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$itemCount item${itemCount == 1 ? '' : 's'}',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              Text(
                totalText,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FontWeight.w900,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primary,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 0.0),
            child: FFButtonWidget(
              onPressed: onCheckout,
              text: 'Continue to checkout',
              options: FFButtonOptions(
                width: double.infinity,
                height: 52.0,
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FontWeight.w800,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                      color: Colors.white,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w800,
                    ),
                elevation: 0.0,
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCartMessage extends StatelessWidget {
  const _EmptyCartMessage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(28.0, 40.0, 28.0, 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 54.0,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 0.0),
              child: Text(
                'Your cart is empty',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FontWeight.w800,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
              child: Text(
                'Add products from the home page to continue.',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginRequiredMessage extends StatelessWidget {
  const _LoginRequiredMessage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(28.0, 40.0, 28.0, 40.0),
        child: Text(
          'Please sign in to view your cart.',
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).titleMedium.override(
                font: GoogleFonts.interTight(
                  fontWeight: FontWeight.w800,
                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.0,
      height: 90.0,
      color: FlutterFlowTheme.of(context).alternate,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: FlutterFlowTheme.of(context).secondaryText,
        size: 28.0,
      ),
    );
  }
}
