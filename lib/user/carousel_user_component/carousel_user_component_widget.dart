import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'carousel_user_component_model.dart';
export 'carousel_user_component_model.dart';

class CarouselUserComponentWidget extends StatefulWidget {
  const CarouselUserComponentWidget({super.key});

  @override
  State<CarouselUserComponentWidget> createState() =>
      _CarouselUserComponentWidgetState();
}

class _CarouselUserComponentWidgetState
    extends State<CarouselUserComponentWidget> {
  late CarouselUserComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CarouselUserComponentModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _addToCart(ProductsRecord product) async {
    if (currentUserReference == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please sign in before adding products to your cart.'),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('cart_items').add({
      'userRef': currentUserReference,
      'productRef': product.reference,
      'title': product.title,
      'description': product.description,
      'image': product.images,
      'price': product.price,
      'quantity': 1,
      'createdAt': getCurrentTimestamp,
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to cart.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
      child: StreamBuilder<List<ProductsRecord>>(
        stream: queryProductsRecord(),
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

          final products = snapshot.data!
              .where((product) => !product.hasIsActive() || product.isActive)
              .toList();

          if (products.isEmpty) {
            return _EmptyProductsMessage();
          }

          final featuredProducts = products.take(6).toList();
          final recentProducts = products.reversed.take(6).toList();
          final availableProducts = products
              .where((product) => product.stock > 0)
              .take(6)
              .toList();

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionTitle(title: 'Featured products'),
                _ProductCarousel(
                  controller: _model.carouselController1 ??=
                      CarouselSliderController(),
                  products: featuredProducts,
                  onAddToCart: _addToCart,
                  onPageChanged: (index) => _model.carouselCurrentIndex1 = index,
                ),
                _SectionTitle(title: 'New arrivals'),
                _ProductCarousel(
                  controller: _model.carouselController2 ??=
                      CarouselSliderController(),
                  products: recentProducts,
                  onAddToCart: _addToCart,
                  onPageChanged: (index) => _model.carouselCurrentIndex2 = index,
                ),
                _SectionTitle(title: 'Available now'),
                _ProductCarousel(
                  controller: _model.carouselController3 ??=
                      CarouselSliderController(),
                  products: availableProducts.isEmpty
                      ? featuredProducts
                      : availableProducts,
                  onAddToCart: _addToCart,
                  onPageChanged: (index) => _model.carouselCurrentIndex3 = index,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 18.0, 20.0, 12.0),
      child: Text(
        title,
        style: FlutterFlowTheme.of(context).titleMedium.override(
              font: GoogleFonts.interTight(
                fontWeight: FontWeight.w800,
                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
              ),
              fontSize: 22.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w800,
              fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
            ),
      ),
    );
  }
}

class _ProductCarousel extends StatelessWidget {
  const _ProductCarousel({
    required this.controller,
    required this.products,
    required this.onAddToCart,
    required this.onPageChanged,
  });

  final CarouselSliderController controller;
  final List<ProductsRecord> products;
  final Future<void> Function(ProductsRecord product) onAddToCart;
  final void Function(int index) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 285.0,
      child: CarouselSlider.builder(
        itemCount: products.length,
        carouselController: controller,
        itemBuilder: (context, index, realIndex) {
          return _ProductCard(
            product: products[index],
            onAddToCart: () => onAddToCart(products[index]),
          );
        },
        options: CarouselOptions(
          initialPage: products.length > 1 ? 1 : 0,
          viewportFraction: 0.72,
          disableCenter: true,
          enlargeCenterPage: true,
          enlargeFactor: 0.18,
          enableInfiniteScroll: products.length > 1,
          scrollDirection: Axis.horizontal,
          autoPlay: products.length > 1,
          autoPlayInterval: Duration(seconds: 4),
          onPageChanged: (index, _) => onPageChanged(index),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onAddToCart});

  final ProductsRecord product;
  final Future<void> Function() onAddToCart;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.images.isNotEmpty
        ? product.images
        : 'https://picsum.photos/seed/ecommerce/600';
    final priceText = formatNumber(
      product.price,
      formatType: FormatType.decimal,
      decimalType: DecimalType.periodDecimal,
      currency: 'S/ ',
    );

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 6.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(18.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: Color(0x1A000000),
              offset: Offset(0.0, 4.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0),
              ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 145.0,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 145.0,
                  color: FlutterFlowTheme.of(context).alternate,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 38.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(14.0, 12.0, 14.0, 0.0),
              child: Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FontWeight.w800,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w800,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleMedium.fontStyle,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(14.0, 4.0, 14.0, 0.0),
              child: Text(
                product.description.isNotEmpty
                    ? product.description
                    : 'Product available in store.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
            ),
            Spacer(),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 14.0, 14.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    priceText,
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w800,
                            fontStyle:
                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  FFButtonWidget(
                    onPressed: product.stock <= 0 ? null : onAddToCart,
                    text: product.stock <= 0 ? 'Sold' : 'Add',
                    options: FFButtonOptions(
                      height: 36.0,
                      padding: EdgeInsetsDirectional.fromSTEB(
                          14.0, 0.0, 14.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                                color: Colors.white,
                                fontSize: 13.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w700,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyProductsMessage extends StatelessWidget {
  const _EmptyProductsMessage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 40.0, 20.0, 40.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 42.0,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
              child: Text(
                'No products available yet',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FontWeight.w700,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
              child: Text(
                'Add products from the admin panel to start selling.',
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
