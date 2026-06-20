import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
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

  Future<void> _placeOrder(List<QueryDocumentSnapshot> cartDocs) async {
    if (currentUserReference == null || cartDocs.isEmpty) {
      return;
    }

    final total = _cartTotal(cartDocs);
    final items = cartDocs.map((doc) {
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
      'total': total,
      'status': 'pending',
      'paymentMethod': 'cash_on_delivery',
      'createdAt': getCurrentTimestamp,
    });

    final batch = FirebaseFirestore.instance.batch();
    for (final doc in cartDocs) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order created successfully.'),
      ),
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
              ? _CheckoutMessage(message: 'Please sign in to continue checkout.')
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

                    if (cartDocs.isEmpty) {
                      return _CheckoutMessage(
                        message: 'Your cart is empty. Add products before checkout.',
                      );
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _CheckoutHeader(onBack: () => context.safePop()),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                18.0, 8.0, 18.0, 20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _CheckoutSection(
                                  title: 'Contact information',
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _InfoRow(
                                        icon: Icons.person_outline,
                                        label: 'Customer',
                                        value: currentUserDisplayName.isNotEmpty
                                            ? currentUserDisplayName
                                            : 'Registered user',
                                      ),
                                      _InfoRow(
                                        icon: Icons.email_outlined,
                                        label: 'Email',
                                        value: currentUserEmail.isNotEmpty
                                            ? currentUserEmail
                                            : 'No email available',
                                      ),
                                    ],
                                  ),
                                ),
                                _CheckoutSection(
                                  title: 'Payment method',
                                  child: _PaymentMethodCard(),
                                ),
                                _CheckoutSection(
                                  title: 'Order summary',
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: cartDocs.map((doc) {
                                      final data =
                                          doc.data() as Map<String, dynamic>;
                                      return _SummaryItem(data: data);
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _CheckoutFooter(
                          total: total,
                          onPlaceOrder: () => _placeOrder(cartDocs),
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

class _CheckoutHeader extends StatelessWidget {
  const _CheckoutHeader({required this.onBack});

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
                    'Checkout',
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
                    'Confirm your order details',
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

class _CheckoutSection extends StatelessWidget {
  const _CheckoutSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Container(
        width: double.infinity,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon, color: FlutterFlowTheme.of(context).primary, size: 22.0),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
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
                  Text(
                    value,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
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
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(14.0, 14.0, 14.0, 14.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cash on delivery',
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
                  Text(
                    'Payment gateway can be connected later.',
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
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final title = valueOrDefault<String>(data['title'] as String?, 'Product');
    final price = castToType<double>(data['price']) ?? 0.0;
    final quantity = castToType<int>(data['quantity']) ?? 1;
    final subtotal = formatNumber(
      price * quantity,
      formatType: FormatType.decimal,
      decimalType: DecimalType.periodDecimal,
      currency: 'S/ ',
    );

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
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
              quantity.toString(),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.w800,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
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
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                    ),
              ),
            ),
          ),
          Text(
            subtotal,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.w800,
                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutFooter extends StatelessWidget {
  const _CheckoutFooter({required this.total, required this.onPlaceOrder});

  final double total;
  final Future<void> Function() onPlaceOrder;

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
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(
                          fontWeight:
                              FlutterFlowTheme.of(context).bodySmall.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodySmall.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
                Text(
                  totalText,
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FontWeight.w900,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleLarge.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primary,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
          ),
          FFButtonWidget(
            onPressed: onPlaceOrder,
            text: 'Place order',
            options: FFButtonOptions(
              height: 52.0,
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
        ],
      ),
    );
  }
}

class _CheckoutMessage extends StatelessWidget {
  const _CheckoutMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(28.0, 40.0, 28.0, 40.0),
        child: Text(
          message,
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
