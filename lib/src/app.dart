import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'controllers/app_controller.dart';
import 'core/app_role.dart';
import 'core/firebase_bootstrapper.dart';
import 'models/models.dart';

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key, required this.firebaseStatus});

  final FirebaseConnectionStatus firebaseStatus;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce Flutter V2',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F172A)),
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
      home: _ResponsiveShell(firebaseStatus: firebaseStatus),
    );
  }
}

class _ResponsiveShell extends StatefulWidget {
  const _ResponsiveShell({required this.firebaseStatus});

  final FirebaseConnectionStatus firebaseStatus;

  @override
  State<_ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<_ResponsiveShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final pages = [
      _CatalogPage(firebaseStatus: widget.firebaseStatus),
      const _CartPage(),
      const _ProfilePage(),
      const _RoleDashboardPage(),
      const _NotificationsPage(),
    ];

    final destinations = const [
      NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Tienda'),
      NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), selectedIcon: Icon(Icons.shopping_cart), label: 'Carrito'),
      NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
      NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Panel'),
      NavigationDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications), label: 'Avisos'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        return Scaffold(
          body: Row(
            children: [
              if (wide)
                NavigationRail(
                  selectedIndex: _index,
                  onDestinationSelected: (value) => setState(() => _index = value),
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CircleAvatar(child: Text(controller.currentUser.role.label[0])),
                  ),
                  destinations: destinations
                      .map((item) => NavigationRailDestination(
                            icon: item.icon,
                            selectedIcon: item.selectedIcon,
                            label: Text(item.label),
                          ))
                      .toList(),
                ),
              Expanded(child: pages[_index]),
            ],
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: _index,
                  onDestinationSelected: (value) => setState(() => _index = value),
                  destinations: destinations,
                ),
        );
      },
    );
  }
}

class _CatalogPage extends StatelessWidget {
  const _CatalogPage({required this.firebaseStatus});

  final FirebaseConnectionStatus firebaseStatus;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final theme = Theme.of(context);
    final products = controller.filteredProducts;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: controller.refresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(firebaseStatus: firebaseStatus),
                    const SizedBox(height: 16),
                    _RolePreviewBar(),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: controller.setQuery,
                      decoration: const InputDecoration(
                        filled: true,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Buscar productos, categorías o ofertas',
                        border: OutlineInputBorder(borderSide: BorderSide.none),
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
                    if (controller.errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(controller.errorMessage!, style: TextStyle(color: theme.colorScheme.error)),
                    ],
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
                padding: const EdgeInsets.all(20),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.crossAxisExtent;
                    final columns = width >= 1100 ? 4 : width >= 800 ? 3 : width >= 560 ? 2 : 1;
                    return SliverGrid.builder(
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: columns == 1 ? .82 : .72,
                      ),
                      itemBuilder: (context, index) => _ProductCard(product: products[index]),
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

class _Header extends StatelessWidget {
  const _Header({required this.firebaseStatus});

  final FirebaseConnectionStatus firebaseStatus;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.tertiary]),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 18,
        children: [
          SizedBox(
            width: 560,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ecommerce Flutter V2', style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(
                  'Web + Android, roles, CRUD, Storage, FCM-ready y pagos simulados.',
                  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Tag(text: firebaseStatus.label),
                    const _Tag(text: 'Cloud simulation'),
                    const _Tag(text: 'Google Sign-In ready'),
                    const _Tag(text: 'Responsive'),
                  ],
                ),
              ],
            ),
          ),
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(controller.currentUser.fullName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  Text(controller.currentUser.email),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: controller.signInWithGoogleSimulation,
                    icon: const Icon(Icons.login),
                    label: const Text('Google / demo'),
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

class _RolePreviewBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: AppRole.values.map((role) {
        final selected = controller.currentUser.role == role;
        return ChoiceChip(
          selected: selected,
          label: Text('Probar como ${role.label}'),
          onSelected: (_) => controller.switchDemoRole(role),
        );
      }).toList(),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              product.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => ColoredBox(
                color: theme.colorScheme.primaryContainer,
                child: const Center(child: Icon(Icons.image_not_supported_outlined)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text(product.category)),
                    if (product.discountRate > 0) Chip(label: Text('-${(product.discountRate * 100).round()}%')),
                    if (product.isLowStock) const Chip(label: Text('Stock bajo')),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Base: S/ ${product.price.toStringAsFixed(2)} · IGV: S/ ${product.taxAmount.toStringAsFixed(2)}'),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text('S/ ${product.finalPrice.toStringAsFixed(2)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                    ),
                    FilledButton.icon(
                      onPressed: product.hasStock ? () => controller.addToCart(product) : null,
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
    final controller = context.watch<AppController>();
    final totals = controller.totals;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: controller.cart.isEmpty
            ? const _EmptyState(icon: Icons.shopping_bag_outlined, title: 'Carrito vacío', message: 'Agrega productos para probar checkout.')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Carrito y checkout', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 14),
                  Expanded(
                    child: ListView.separated(
                      itemCount: controller.cart.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => _CartTile(item: controller.cart[index]),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          _MoneyRow('Subtotal', totals.subtotal),
                          _MoneyRow('Descuento', -totals.discount),
                          _MoneyRow('IGV', totals.tax),
                          _MoneyRow('Envío', totals.shipping),
                          const Divider(),
                          _MoneyRow('Total', totals.total, strong: true),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () async {
                                final order = await controller.checkout();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Pedido ${order.id} creado.')),
                                );
                              },
                              icon: const Icon(Icons.payments_outlined),
                              label: const Text('Pagar con simulación cloud'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
    final controller = context.read<AppController>();
    return Card(
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(item.product.imageUrl, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.inventory)),
        ),
        title: Text(item.product.name),
        subtitle: Text('${item.quantity} x S/ ${item.product.finalPrice.toStringAsFixed(2)}'),
        trailing: Wrap(
          children: [
            IconButton(onPressed: () => controller.decreaseQuantity(item.product), icon: const Icon(Icons.remove)),
            IconButton(onPressed: () => controller.addToCart(item.product), icon: const Icon(Icons.add)),
            IconButton(onPressed: () => controller.removeFromCart(item.product), icon: const Icon(Icons.delete_outline)),
          ],
        ),
      ),
    );
  }
}

class _ProfilePage extends StatefulWidget {
  const _ProfilePage();

  @override
  State<_ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<_ProfilePage> {
  late final TextEditingController name;
  late final TextEditingController phone;
  late final TextEditingController address;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppController>().currentUser;
    name = TextEditingController(text: user.fullName);
    phone = TextEditingController(text: user.phone);
    address = TextEditingController(text: user.address);
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final user = controller.currentUser;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Perfil, pagos y notificaciones', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Nombre completo')),
          const SizedBox(height: 10),
          TextField(controller: phone, decoration: const InputDecoration(labelText: 'Teléfono')),
          const SizedBox(height: 10),
          TextField(controller: address, decoration: const InputDecoration(labelText: 'Dirección')),
          const SizedBox(height: 16),
          Text('Métodos de pago simulados', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          ...user.paymentMethods.map((method) => ListTile(
                leading: const Icon(Icons.credit_card),
                title: Text(method.type),
                subtitle: Text('${method.holder} · **** ${method.last4}'),
                trailing: method.isDefault ? const Chip(label: Text('Default')) : null,
              )),
          const SizedBox(height: 16),
          _NotificationSwitches(user: user),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              controller.updateProfile(
                fullName: name.text.trim(),
                phone: phone.text.trim(),
                address: address.text.trim(),
                notifications: user.notifications,
              );
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil actualizado en simulación.')));
            },
            icon: const Icon(Icons.save_outlined),
            label: const Text('Guardar perfil'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _showRoleRequest(context),
            icon: const Icon(Icons.manage_accounts_outlined),
            label: const Text('Solicitar acceso a vendedor/admin'),
          ),
        ],
      ),
    );
  }

  void _showRoleRequest(BuildContext context) {
    final reason = TextEditingController(text: 'Quiero probar las funciones avanzadas del ecommerce.');
    AppRole selected = AppRole.seller;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Solicitud de rol'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<AppRole>(
                value: selected,
                items: AppRole.values.map((role) => DropdownMenuItem(value: role, child: Text(role.label))).toList(),
                onChanged: (value) => setState(() => selected = value ?? AppRole.seller),
              ),
              TextField(controller: reason, decoration: const InputDecoration(labelText: 'Motivo')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              context.read<AppController>().requestRole(selected, reason.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}

class _NotificationSwitches extends StatelessWidget {
  const _NotificationSwitches({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: const [
          SwitchListTile(value: true, onChanged: null, title: Text('Pedidos')),
          SwitchListTile(value: true, onChanged: null, title: Text('Promociones')),
          SwitchListTile(value: true, onChanged: null, title: Text('Stock bajo')),
          SwitchListTile(value: true, onChanged: null, title: Text('Recordatorios de ofertas')),
        ],
      ),
    );
  }
}

class _RoleDashboardPage extends StatelessWidget {
  const _RoleDashboardPage();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    switch (controller.currentUser.role) {
      case AppRole.customer:
        return const _CustomerPanel();
      case AppRole.seller:
        return const _SellerPanel();
      case AppRole.admin:
        return const _AdminPanel();
    }
  }
}

class _CustomerPanel extends StatelessWidget {
  const _CustomerPanel();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Panel de usuario', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          _MetricGrid(values: {
            'Pedidos': controller.orders.length.toString(),
            'Carrito': controller.cartCount.toString(),
            'Notificaciones': controller.notifications.length.toString(),
          }),
          const SizedBox(height: 16),
          ...controller.orders.map((order) => ListTile(
                leading: const Icon(Icons.receipt_long),
                title: Text(order.id),
                subtitle: Text(order.status),
                trailing: Text('S/ ${order.total.toStringAsFixed(2)}'),
              )),
        ],
      ),
    );
  }
}

class _SellerPanel extends StatelessWidget {
  const _SellerPanel();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final sellerProducts = controller.products.where((product) => product.sellerId == controller.currentUser.id || product.sellerId == 'demo-seller').toList();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Panel de vendedor', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          _MetricGrid(values: {
            'Productos': sellerProducts.length.toString(),
            'Stock bajo': sellerProducts.where((product) => product.isLowStock).length.toString(),
            'Ventas demo': controller.orders.length.toString(),
          }),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _ProductEditor.show(context),
            icon: const Icon(Icons.add_box_outlined),
            label: const Text('Crear producto'),
          ),
          const SizedBox(height: 16),
          ...sellerProducts.map((product) => ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(product.name),
                subtitle: Text('${product.category} · Stock ${product.stock}'),
                trailing: Wrap(
                  children: [
                    IconButton(onPressed: () => _ProductEditor.show(context, product: product), icon: const Icon(Icons.edit_outlined)),
                    IconButton(onPressed: () => controller.deleteProduct(product), icon: const Icon(Icons.delete_outline)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _AdminPanel extends StatelessWidget {
  const _AdminPanel();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Panel administrador', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          _MetricGrid(values: {
            'Usuarios': controller.users.length.toString(),
            'Productos': controller.products.length.toString(),
            'Categorías': controller.categoryModels.length.toString(),
            'Solicitudes': controller.roleRequests.length.toString(),
          }),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: controller.seedDemoData,
            icon: const Icon(Icons.cloud_upload_outlined),
            label: const Text('Sincronizar demo con Firebase'),
          ),
          const SizedBox(height: 16),
          Text('Solicitudes de acceso', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          ...controller.roleRequests.map((request) => ListTile(
                leading: const Icon(Icons.manage_accounts),
                title: Text('${request.email} → ${request.requestedRole.label}'),
                subtitle: Text(request.reason),
                trailing: request.status == 'pending'
                    ? FilledButton(
                        onPressed: () => controller.approveRoleRequest(request),
                        child: const Text('Aprobar'),
                      )
                    : Chip(label: Text(request.status)),
              )),
          const SizedBox(height: 16),
          Text('Usuarios', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          ...controller.users.map((user) => ListTile(
                leading: const Icon(Icons.person),
                title: Text(user.fullName),
                subtitle: Text(user.email),
                trailing: Chip(label: Text(user.role.label)),
              )),
        ],
      ),
    );
  }
}

class _ProductEditor {
  static void show(BuildContext context, {Product? product}) {
    final name = TextEditingController(text: product?.name ?? '');
    final description = TextEditingController(text: product?.description ?? '');
    final category = TextEditingController(text: product?.category ?? 'Accesorios');
    final price = TextEditingController(text: (product?.price ?? 99.90).toString());
    final stock = TextEditingController(text: (product?.stock ?? 10).toString());
    final image = TextEditingController(text: product?.imageUrl ?? 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=900&q=80');

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product == null ? 'Crear producto' : 'Editar producto'),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: name, decoration: const InputDecoration(labelText: 'Nombre')),
                TextField(controller: description, decoration: const InputDecoration(labelText: 'Descripción')),
                TextField(controller: category, decoration: const InputDecoration(labelText: 'Categoría')),
                TextField(controller: price, decoration: const InputDecoration(labelText: 'Precio')),
                TextField(controller: stock, decoration: const InputDecoration(labelText: 'Stock')),
                TextField(controller: image, decoration: const InputDecoration(labelText: 'URL de imagen o Storage')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              final controller = context.read<AppController>();
              final next = Product(
                id: product?.id ?? 'PROD-${DateTime.now().millisecondsSinceEpoch}',
                name: name.text.trim(),
                description: description.text.trim(),
                category: category.text.trim(),
                price: double.tryParse(price.text) ?? 0,
                stock: int.tryParse(stock.text) ?? 0,
                imageUrl: image.text.trim(),
                rating: product?.rating ?? 4.5,
                isFeatured: product?.isFeatured ?? false,
                sellerId: controller.currentUser.id,
              );
              controller.saveProduct(next);
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

class _NotificationsPage extends StatelessWidget {
  const _NotificationsPage();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Notificaciones', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          if (controller.notifications.isEmpty)
            const _EmptyState(icon: Icons.notifications_none, title: 'Sin notificaciones', message: 'Aquí aparecerán pedidos, promociones y alertas.')
          else
            ...controller.notifications.map((item) => ListTile(
                  leading: const Icon(Icons.notifications_active_outlined),
                  title: Text(item.title),
                  subtitle: Text(item.message),
                  trailing: Chip(label: Text(item.type)),
                )),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.values});

  final Map<String, String> values;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: values.entries
          .map((entry) => SizedBox(
                width: 180,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                        Text(entry.key),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow(this.label, this.value, {this.strong = false});

  final String label;
  final double value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final style = strong ? Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900) : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text('S/ ${value.toStringAsFixed(2)}', style: style),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(text));
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title, required this.message});

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 52),
              const SizedBox(height: 10),
              Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
