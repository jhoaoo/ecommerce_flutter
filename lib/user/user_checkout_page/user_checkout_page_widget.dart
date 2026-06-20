import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'user_checkout_page_model.dart';
export 'user_checkout_page_model.dart';

class UserCheckoutPageWidget extends StatefulWidget {
  const UserCheckoutPageWidget({super.key});

  static String routeName = 'user_checkout_page';
  static String routePath = '/userCheckoutPage';

  @override
  State<UserCheckoutPageWidget> createState() => _UserCheckoutPageWidgetState();
}

class _UserCheckoutPageWidgetState extends State<UserCheckoutPageWidget> {
  late UserCheckoutPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserCheckoutPageModel());
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

  String _money(num value) => formatNumber(
        value,
        formatType: FormatType.decimal,
        decimalType: DecimalType.periodDecimal,
        currency: 'S/ ',
      );

  Future<void> _placeOrder(List<QueryDocumentSnapshot> docs) async {
    if (currentUserReference == null || docs.isEmpty) return;

    final items = docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'productRef': data['productRef'],
        'title': data['title'],
        'description': data['description'],
        'image': data['image'],
        'price': castToType<double>(data['price']) ?? 0.0,
        'quantity': castToType<int>(data['quantity']) ?? 1,
      };
    }).toList();

    await FirebaseFirestore.instance.collection('orders').add({
      'userRef': currentUserReference,
      'items': items,
      'total': _total(docs),
      'status': 'pending',
      'paymentMethod': 'cash_on_delivery',
      'createdAt': getCurrentTimestamp,
    });

    final batch = FirebaseFirestore.instance.batch();
    for (final doc in docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order created successfully.')),
    );
    context.pushNamed('order_user_page');
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
              ? _message(context, 'Please sign in to continue checkout.')
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

                    if (docs.isEmpty) {
                      return _message(
                        context,
                        'Your cart is empty. Add products before checkout.',
                      );
                    }

                    return Column(
                      children: [
                        _header(context),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                18.0, 8.0, 18.0, 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _section(
                                  context,
                                  'Contact information',
                                  Column(
                                    children: [
                                      _infoRow(
                                        context,
                                        Icons.person_outline,
                                        'Customer',
                                        currentUserDisplayName.isNotEmpty
                                            ? currentUserDisplayName
                                            : 'Registered user',
                                      ),
                                      _infoRow(
                                        context,
                                        Icons.email_outlined,
                                        'Email',
                                        currentUserEmail.isNotEmpty
                                            ? currentUserEmail
                                            : 'No email available',
                                      ),
                                    ],
                                  ),
                                ),
                                _section(context, 'Payment method', _paymentCard(context)),
                                _section(
                                  context,
                                  'Order summary',
                                  Column(
                                    children: docs.map((doc) {
                                      final data =
                                          doc.data() as Map<String, dynamic>;
                                      return _summaryItem(context, data);
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _footer(context, total, docs),
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
                    'Checkout',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.interTight(fontWeight: FontWeight.w900),
                          fontSize: 34.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  Text(
                    'Confirm your order details',
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

  Widget _section(BuildContext context, String title, Widget child) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
      child: Row(
        children: [
          Icon(icon, color: FlutterFlowTheme.of(context).primary, size: 22.0),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                  Text(
                    value,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w700,
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

  Widget _paymentCard(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(14.0, 14.0, 14.0, 14.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.payments_outlined,
            color: FlutterFlowTheme.of(context).primary,
            size: 26.0,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cash on delivery',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w800),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  Text(
                    'Payment gateway can be connected later.',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ),
          ),
          Icon(
            Icons.check_circle,
            color: FlutterFlowTheme.of(context).primary,
            size: 22.0,
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(BuildContext context, Map<String, dynamic> data) {
    final title = valueOrDefault<String>(data['title'] as String?, 'Product');
    final price = castToType<double>(data['price']) ?? 0.0;
    final qty = castToType<int>(data['quantity']) ?? 1;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
      child: Row(
        children: [
          Container(
            width: 34.0,
            height: 34.0,
            alignment: AlignmentDirectional(0.0, 0.0),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              qty.toString(),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w800),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(),
                      letterSpacing: 0.0,
                    ),
              ),
            ),
          ),
          Text(
            _money(price * qty),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w800),
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context, double total, List<QueryDocumentSnapshot> docs) {
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
                Text(
                  _money(total),
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        font: GoogleFonts.interTight(fontWeight: FontWeight.w900),
                        color: FlutterFlowTheme.of(context).primary,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
          ),
          FFButtonWidget(
            onPressed: () async => _placeOrder(docs),
            text: 'Place order',
            options: FFButtonOptions(
              height: 52.0,
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
        ],
      ),
    );
  }

  Widget _message(BuildContext context, String message) {
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
