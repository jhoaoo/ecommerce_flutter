import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Stream<QuerySnapshot> get _cartStream => FirebaseFirestore.instance
      .collection('cart_items')
      .where('userRef', isEqualTo: currentUserReference)
      .orderBy('createdAt', descending: true)
      .snapshots();

  double _total(List<QueryDocumentSnapshot> docs) {
    return docs.fold<double>(0.0, (sum, doc) {
      final data = doc.data() as Map<String, dynamic>;
      final price = castToType<double>(data['price']) ?? 0.0;
      final qty = castToType<int>(data['quantity']) ?? 1;
      return sum + (price * qty);
    });
  }

  Future<void> _changeQuantity(DocumentReference ref, int current, int change) async {
    final next = current + change;
    if (next <= 0) {
      await ref.delete();
    } else {
      await ref.update({'quantity': next});
    }
  }

  String _money(num value) => formatNumber(
        value,
        formatType: FormatType.decimal,
        decimalType: DecimalType.periodDecimal,
        currency: 'S/ ',
      );

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
              ? _centerMessage(context, 'Please sign in to view your cart.')
              : StreamBuilder<QuerySnapshot>(
                  stream: _cartStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      );
                    }

                    final docs = snapshot.data!.docs;
                    final total = _total(docs);

                    return Column(
                      children: [
                        _header(context),
                        Expanded(
                          child: docs.isEmpty
                              ? _centerMessage(
                                  context,
                                  'Your cart is empty. Add products from the home page.',
                                )
                              : ListView.separated(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 8.0, 16.0, 16.0),
                                  itemCount: docs.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 14.0),
                                  itemBuilder: (context, index) {
                                    final doc = docs[index];
                                    final data =
                                        doc.data() as Map<String, dynamic>;
                                    return _cartItem(context, doc.reference, data);
                                  },
                                ),
                        ),
                        _footer(context, docs.length, total),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 20.0, 12.0),
      child: Row(
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
            onPressed: () async => context.safePop(),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your cart',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.interTight(fontWeight: FontWeight.w900),
                          fontSize: 34.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  Text(
                    'Review your selected products',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(),
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

  Widget _cartItem(
    BuildContext context,
    DocumentReference ref,
    Map<String, dynamic> data,
  ) {
    final title = valueOrDefault<String>(data['title'] as String?, 'Product');
    final description =
        valueOrDefault<String>(data['description'] as String?, 'Selected item');
    final image = valueOrDefault<String>(data['image'] as String?, '');
    final price = castToType<double>(data['price']) ?? 0.0;
    final qty = castToType<int>(data['quantity']) ?? 1;

    return Container(
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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: image.isEmpty
                ? Container(
                    width: 90.0,
                    height: 90.0,
                    color: FlutterFlowTheme.of(context).alternate,
                    child: Icon(Icons.image_not_supported_outlined),
                  )
                : Image.network(
                    image,
                    width: 90.0,
                    height: 90.0,
                    fit: BoxFit.cover,
                  ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 8.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 8.0),
                    child: Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _money(price),
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Text(
                        _money(price * qty),
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(fontWeight: FontWeight.w700),
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
                onPressed: () async => ref.delete(),
              ),
              Container(
                margin: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _changeQuantity(ref, qty, -1),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 6.0),
                        child: Icon(Icons.remove_rounded, size: 18.0),
                      ),
                    ),
                    Text(
                      qty.toString(),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.w800),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    InkWell(
                      onTap: () => _changeQuantity(ref, qty, 1),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 6.0),
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

  Widget _footer(BuildContext context, int itemCount, double total) {
    return Container(
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$itemCount item${itemCount == 1 ? '' : 's'}',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              Text(
                _money(total),
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.interTight(fontWeight: FontWeight.w900),
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
              onPressed: itemCount == 0
                  ? null
                  : () async => context.pushNamed('user_checkout_page'),
              text: 'Continue to checkout',
              options: FFButtonOptions(
                width: double.infinity,
                height: 52.0,
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
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

  Widget _centerMessage(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(28.0, 40.0, 28.0, 40.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).titleMedium.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                letterSpacing: 0.0,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}
