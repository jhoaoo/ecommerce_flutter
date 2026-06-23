import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_bootstrapper.dart';
import 'models.dart';
import 'shop_controller.dart';

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key, required this.firebaseStatus});

  final FirebaseConnectionStatus firebaseStatus;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce Flutter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F172A)),
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: _MainShell(firebaseStatus: firebaseStatus),
    );
  }
}

class _MainShell extends StatefulWidget {
  const _MainShell({required this.firebaseStatus});

  final FirebaseConnectionStatus firebaseStatus;

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _CatalogPage(firebaseStatus: widget.firebaseStatus),
      const _CartPage(),
      const _AdminDashboardPage(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Tienda',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Carrito',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Admin',
          ),
        ],
      ),
    );
  }
}

class _CatalogPage extends StatelessWidget {
  const _CatalogPage({required this.firebaseStatus});

  final FirebaseConnectionStatus firebaseStatus;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ShopController>();
    final products = controller.filteredProducts;
    final theme = Theme.of(context);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: controller.loadProducts,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ecommerce Flutter',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Catálogo, carrito, checkout y Firestore listos para portafolio.',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Badge(
                          label: Text(controller.cartCount.toString()),
                          child: const Icon(Icons.shopping_bag_outlined),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
                        ),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Demo profesional con Firebase',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            firebaseStatus.label,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(.92),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _HeroTag(text: 'Firestore'),
                              _HeroTag(text: 'Auth anónimo'),
                              _HeroTag(text: 'Fallback local'),
                              _HeroTag(text: 'Checkout'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      onChanged: controller.setQuery,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Buscar productos o categorías',
                      ),
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: controller.categories.map((category) {
                          final selected = category == controller.selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: selected,
                              onSelected: (_) => controller.setCategory(category),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.isLoading)
              const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
            else if (products.isEmpty)
              const SliverFillRemaining(child: Center(child: Text('No hay productos disponibles.')))
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.crossAxisExtent;
                    final columns = width >= 1000 ? 3 : width >= 650 ? 2 : 1;
                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = products[index];
                          return _ProductCard(
                            product: product,
                            onAdd: () {
                              context.read<ShopController>().addToCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${product.name} agregado al carrito.')),
                              );
                            },
                          );
                        },
                        childCount: products.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: columns == 1 ? .82 : .76,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onAdd});

  final Product product;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: product.imageUrl.isEmpty
                ? Container(
                    color: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 46,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : Image.network(
                    product.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF59E0B)),
                    Text(product.rating.toStringAsFixed(1)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Chip(label: Text(product.category)),
                    Text('Stock: ${product.stock}', style: theme.textTheme.labelMedium),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'S/ ${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: product.hasStock ? onAdd : null,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Agregar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartPage extends StatelessWidget {
  const _CartPage();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ShopController>();
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Carrito de compras',
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text('${controller.cartCount} producto(s) seleccionados', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 20),
            Expanded(
              child: controller.cart.isEmpty
                  ? const _EmptyCart()
                  : ListView.separated(
                      itemCount: controller.cart.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _CartTile(item: controller.cart[index]),
                    ),
            ),
            if (controller.cart.isNotEmpty) _CartSummary(total: controller.cartTotal),
          ],
        ),
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  const _CartTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ShopController>();
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                item.product.imageUrl,
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 76,
                  height: 76,
                  color: theme.colorScheme.primaryContainer,
                  child: const Icon(Icons.inventory_2_outlined),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  Text('S/ ${item.product.price.toStringAsFixed(2)} c/u', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => controller.decreaseQuantity(item.product),
                        icon: const Icon(Icons.remove),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${item.quantity}',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      IconButton.filledTonal(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => controller.addToCart(item.product),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'S/ ${item.subtotal.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
                IconButton(
                  onPressed: () => controller.removeFromCart(item.product),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _SummaryRow(label: 'Subtotal', value: 'S/ ${total.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            const _SummaryRow(label: 'Envío', value: 'Gratis'),
            const Divider(height: 28),
            _SummaryRow(label: 'Total', value: 'S/ ${total.toStringAsFixed(2)}', isStrong: true),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const _CheckoutPage()),
                ),
                icon: const Icon(Icons.lock_outline),
                label: const Text('Continuar al checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutPage extends StatefulWidget {
  const _CheckoutPage();

  @override
  State<_CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<_CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Jhoaoo Llerena');
  final _emailController = TextEditingController(text: 'jhoaoollerena@gmail.com');
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ShopController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout seguro')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Finalizar compra',
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text('Este checkout registra la orden en Firestore cuando Firebase está disponible.'),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del cliente',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) => value == null || value.trim().length < 3
                        ? 'Ingresa un nombre válido.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || !value.contains('@')
                        ? 'Ingresa un correo válido.'
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen de orden',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 12),
                    ...controller.cart.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(child: Text('${item.quantity} x ${item.product.name}')),
                            Text('S/ ${item.subtotal.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 28),
                    _SummaryRow(
                      label: 'Total',
                      value: 'S/ ${controller.cartTotal.toStringAsFixed(2)}',
                      isStrong: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isSubmitting || controller.cart.isEmpty ? null : () => _submit(context),
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: const Text('Crear orden'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final order = await context.read<ShopController>().checkout(
            customerName: _nameController.text.trim(),
            customerEmail: _emailController.text.trim(),
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Orden ${order.id} creada correctamente.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo crear la orden: $error')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

class _AdminDashboardPage extends StatelessWidget {
  const _AdminDashboardPage();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ShopController>();
    final theme = Theme.of(context);
    final revenue = controller.orders.fold<double>(0, (sum, order) => sum + order.total);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Panel administrativo',
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text('Dashboard básico para demostrar métricas, productos y órdenes.'),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _MetricCard(
                title: 'Productos',
                value: '${controller.products.length}',
                icon: Icons.inventory_2_outlined,
              ),
              _MetricCard(
                title: 'Órdenes',
                value: '${controller.orders.length}',
                icon: Icons.receipt_long_outlined,
              ),
              _MetricCard(
                title: 'Ingresos demo',
                value: 'S/ ${revenue.toStringAsFixed(2)}',
                icon: Icons.payments_outlined,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Firestore demo',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Carga productos demo en la colección products para evidenciar uso de base de datos.',
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: () async {
                      await context.read<ShopController>().seedDemoProducts();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Productos demo sincronizados con Firestore si Firebase está disponible.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.cloud_upload_outlined),
                    label: const Text('Sincronizar productos demo'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Últimas órdenes', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          if (controller.orders.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text('Aún no hay órdenes. Crea una compra desde el checkout.'),
              ),
            )
          else
            ...controller.orders.map(
              (order) => Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.receipt_long_outlined)),
                  title: Text(order.customerName),
                  subtitle: Text('${order.items.length} item(s) · Estado: ${order.status}'),
                  trailing: Text(
                    'S/ ${order.total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value, required this.icon});

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(height: 18),
              Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.isStrong = false});

  final String label;
  final String value;
  final bool isStrong;

  @override
  Widget build(BuildContext context) {
    final style = isStrong
        ? Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)
        : Theme.of(context).textTheme.bodyLarge;
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 72, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            'Tu carrito está vacío',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text('Agrega productos desde la tienda para probar el flujo completo.'),
        ],
      ),
    );
  }
}

class _HeroTag extends StatelessWidget {
  const _HeroTag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.16),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
