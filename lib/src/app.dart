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
    final controller = context.watch<AppController>();
    const seed = Color(0xFF0F172A);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NovaMarket',
      themeMode: controller.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: controller.isLoading
          ? const _LoadingPage()
          : controller.isAuthenticated
              ? const _ResponsiveShell()
              : const _AuthPage(),
    );
  }
}

class _LoadingPage extends StatelessWidget {
  const _LoadingPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _AuthPage extends StatefulWidget {
  const _AuthPage();

  @override
  State<_AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<_AuthPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool registerMode = false;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                if (MediaQuery.sizeOf(context).width > 760)
                  Expanded(
                    child: Container(
                      height: 520,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.tertiary]),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('NovaMarket', style: theme.textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 12),
                          Text('Compra tecnología, vende productos y gestiona pedidos desde una sola plataforma.', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
                          const SizedBox(height: 18),
                          const Wrap(spacing: 8, runSpacing: 8, children: [_Tag(text: 'Compra segura'), _Tag(text: 'Panel vendedor'), _Tag(text: 'Panel admin')]),
                        ],
                      ),
                    ),
                  ),
                if (MediaQuery.sizeOf(context).width > 760) const SizedBox(width: 20),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(26),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(registerMode ? 'Crear cuenta' : 'Iniciar sesión', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 6),
                          Text(registerMode ? 'Regístrate para comprar y solicitar acceso de vendedor.' : 'Ingresa para continuar con tus compras y paneles.'),
                          const SizedBox(height: 18),
                          if (registerMode) ...[
                            TextField(controller: name, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Nombre completo')),
                            const SizedBox(height: 12),
                          ],
                          TextField(controller: email, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Correo electrónico')),
                          const SizedBox(height: 12),
                          TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña')),
                          if (controller.errorMessage != null) ...[
                            const SizedBox(height: 12),
                            Text(controller.errorMessage!, style: TextStyle(color: theme.colorScheme.error)),
                          ],
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () {
                                if (registerMode) {
                                  controller.registerWithEmail(name.text, email.text, password.text);
                                } else {
                                  controller.signInWithEmail(email.text, password.text);
                                }
                              },
                              icon: Icon(registerMode ? Icons.person_add_alt : Icons.login),
                              label: Text(registerMode ? 'Registrarme' : 'Ingresar'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(onPressed: controller.signInWithGoogle, icon: const Icon(Icons.g_mobiledata), label: const Text('Continuar con Google')),
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            TextButton(onPressed: () => setState(() => registerMode = !registerMode), child: Text(registerMode ? 'Ya tengo cuenta' : 'Crear cuenta')),
                            TextButton(onPressed: () => controller.resetPassword(email.text), child: const Text('Olvidé mi contraseña')),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResponsiveShell extends StatefulWidget {
  const _ResponsiveShell();

  @override
  State<_ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<_ResponsiveShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final pages = [const _CatalogPage(), const _CartPage(), const _ProfilePage(), const _RoleDashboardPage(), const _NotificationsPage()];
    const destinations = [
      NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Tienda'),
      NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), selectedIcon: Icon(Icons.shopping_cart), label: 'Carrito'),
      NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
      NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Panel'),
      NavigationDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications), label: 'Avisos'),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 900;
      return Scaffold(
        body: Row(children: [
          if (wide)
            NavigationRail(
              selectedIndex: index,
              onDestinationSelected: (value) => setState(() => index = value),
              labelType: NavigationRailLabelType.all,
              leading: Padding(padding: const EdgeInsets.all(12), child: CircleAvatar(child: Text(controller.currentUser.role.label[0]))),
              destinations: destinations.map((item) => NavigationRailDestination(icon: item.icon, selectedIcon: item.selectedIcon, label: Text(item.label))).toList(),
            ),
          Expanded(child: pages[index]),
        ]),
        bottomNavigationBar: wide ? null : NavigationBar(selectedIndex: index, onDestinationSelected: (value) => setState(() => index = value), destinations: destinations),
      );
    });
  }
}

class _CatalogPage extends StatelessWidget {
  const _CatalogPage();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final theme = Theme.of(context);
    final products = controller.filteredProducts;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: controller.refresh,
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const _Header(),
                const SizedBox(height: 16),
                TextField(onChanged: controller.setQuery, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Buscar productos, categorías u ofertas')),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: controller.categories.map((category) {
                    final selected = category == controller.selectedCategory;
                    return Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(category), selected: selected, onSelected: (_) => controller.setCategory(category)));
                  }).toList()),
                ),
                if (controller.errorMessage != null) ...[const SizedBox(height: 10), Text(controller.errorMessage!, style: TextStyle(color: theme.colorScheme.error))],
              ]),
            ),
          ),
          if (products.isEmpty)
            const SliverFillRemaining(child: _EmptyState(icon: Icons.storefront_outlined, title: 'No hay productos publicados', message: 'Cuando un administrador apruebe productos, aparecerán aquí.'))
          else
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverLayoutBuilder(builder: (context, constraints) {
                final width = constraints.crossAxisExtent;
                final columns = width >= 1100 ? 4 : width >= 800 ? 3 : width >= 560 ? 2 : 1;
                return SliverGrid.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: columns == 1 ? .82 : .72),
                  itemBuilder: (context, itemIndex) => _ProductCard(product: products[itemIndex]),
                );
              }),
            ),
        ]),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.tertiary]), borderRadius: BorderRadius.circular(28)),
      child: Wrap(alignment: WrapAlignment.spaceBetween, runSpacing: 18, children: [
        SizedBox(
          width: 560,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('NovaMarket', style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text('Compra tecnología, gestiona pedidos y vende productos desde una sola plataforma.', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white)),
            const SizedBox(height: 12),
            const Wrap(spacing: 8, runSpacing: 8, children: [_Tag(text: 'Compra segura'), _Tag(text: 'Ofertas'), _Tag(text: 'Envíos'), _Tag(text: 'Soporte')]),
          ]),
        ),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(controller.currentUser.fullName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              Text(controller.currentUser.email),
              const SizedBox(height: 8),
              Chip(label: Text(controller.currentUser.role.label)),
            ]),
          ),
        ),
      ]),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Image.network(product.imageUrl, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => ColoredBox(color: theme.colorScheme.primaryContainer, child: const Center(child: Icon(Icons.image_not_supported_outlined))))),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [Chip(label: Text(product.category)), if (product.discountRate > 0) Chip(label: Text('-${(product.discountRate * 100).round()}%')), if (product.isLowStock) const Chip(label: Text('Últimas unidades'))]),
            const SizedBox(height: 8),
            Text('Incluye IGV: S/ ${product.taxAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 6),
            Row(children: [
              Expanded(child: Text('S/ ${product.finalPrice.toStringAsFixed(2)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900))),
              FilledButton.icon(onPressed: product.hasStock ? () => controller.addToCart(product) : null, icon: const Icon(Icons.add_shopping_cart), label: const Text('Agregar')),
            ]),
          ]),
        ),
      ]),
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
            ? const _EmptyState(icon: Icons.shopping_bag_outlined, title: 'Carrito vacío', message: 'Agrega productos para continuar con la compra.')
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Carrito y pago', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 14),
                Expanded(child: ListView.separated(itemCount: controller.cart.length, separatorBuilder: (_, __) => const SizedBox(height: 10), itemBuilder: (context, itemIndex) => _CartTile(item: controller.cart[itemIndex]))),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(children: [
                      _MoneyRow('Subtotal', totals.subtotal),
                      _MoneyRow('Descuento', -totals.discount),
                      _MoneyRow('IGV', totals.tax),
                      _MoneyRow('Envío', totals.shipping),
                      const Divider(),
                      _MoneyRow('Total', totals.total, strong: true),
                      const SizedBox(height: 12),
                      SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () async { final order = await controller.checkout(); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pedido ${order.id} creado.'))); }, icon: const Icon(Icons.payments_outlined), label: const Text('Confirmar compra'))),
                    ]),
                  ),
                ),
              ]),
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
        leading: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(item.product.imageUrl, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.inventory))),
        title: Text(item.product.name),
        subtitle: Text('${item.quantity} x S/ ${item.product.finalPrice.toStringAsFixed(2)}'),
        trailing: Wrap(children: [IconButton(onPressed: () => controller.decreaseQuantity(item.product), icon: const Icon(Icons.remove)), IconButton(onPressed: () => controller.addToCart(item.product), icon: const Icon(Icons.add)), IconButton(onPressed: () => controller.removeFromCart(item.product), icon: const Icon(Icons.delete_outline))]),
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
      child: ListView(padding: const EdgeInsets.all(20), children: [
        Text('Perfil y configuración', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Nombre completo')),
        const SizedBox(height: 10),
        TextField(controller: phone, decoration: const InputDecoration(labelText: 'Teléfono')),
        const SizedBox(height: 10),
        TextField(controller: address, decoration: const InputDecoration(labelText: 'Dirección')),
        const SizedBox(height: 16),
        Card(child: Column(children: [
          SwitchListTile(value: controller.darkMode, onChanged: controller.setDarkMode, title: const Text('Modo oscuro')),
          ListTile(title: const Text('Idioma'), trailing: DropdownButton<String>(value: controller.language, items: const ['Español', 'English'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) => controller.setLanguage(value ?? 'Español'))),
        ])),
        const SizedBox(height: 16),
        Row(children: [Expanded(child: Text('Métodos de pago', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))), TextButton.icon(onPressed: () => _PaymentEditor.show(context), icon: const Icon(Icons.add_card), label: const Text('Agregar'))]),
        if (user.paymentMethods.isEmpty) const ListTile(leading: Icon(Icons.credit_card_off), title: Text('No hay métodos registrados.')),
        ...user.paymentMethods.map((method) => ListTile(leading: const Icon(Icons.credit_card), title: Text(method.type), subtitle: Text('${method.holder} · **** ${method.last4}'), trailing: IconButton(onPressed: () => controller.deletePaymentMethod(method), icon: const Icon(Icons.delete_outline)))),
        const SizedBox(height: 16),
        _NotificationSwitches(user: user),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: () { controller.updateProfile(fullName: name.text.trim(), phone: phone.text.trim(), address: address.text.trim(), notifications: user.notifications); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil actualizado.'))); }, icon: const Icon(Icons.save_outlined), label: const Text('Guardar perfil')),
        const SizedBox(height: 10),
        OutlinedButton.icon(onPressed: () => _showRoleRequest(context), icon: const Icon(Icons.manage_accounts_outlined), label: const Text('Solicitar acceso avanzado')),
        const SizedBox(height: 10),
        OutlinedButton.icon(onPressed: controller.signOut, icon: const Icon(Icons.logout), label: const Text('Cerrar sesión')),
      ]),
    );
  }

  void _showRoleRequest(BuildContext context) {
    final reason = TextEditingController(text: 'Quiero vender productos en la plataforma.');
    AppRole selected = AppRole.seller;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Solicitud de acceso'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<AppRole>(value: selected, items: AppRole.values.where((role) => role != AppRole.customer).map((role) => DropdownMenuItem(value: role, child: Text(role.label))).toList(), onChanged: (value) => setState(() => selected = value ?? AppRole.seller)),
            TextField(controller: reason, decoration: const InputDecoration(labelText: 'Motivo')),
          ]),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')), FilledButton(onPressed: () { context.read<AppController>().requestRole(selected, reason.text.trim()); Navigator.pop(context); }, child: const Text('Enviar'))],
      ),
    );
  }
}

class _PaymentEditor {
  static void show(BuildContext context) {
    final type = TextEditingController(text: 'Tarjeta');
    final holder = TextEditingController(text: context.read<AppController>().currentUser.fullName);
    final last4 = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar método de pago'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: type, decoration: const InputDecoration(labelText: 'Tipo')),
          TextField(controller: holder, decoration: const InputDecoration(labelText: 'Titular')),
          TextField(controller: last4, decoration: const InputDecoration(labelText: 'Últimos 4 dígitos')),
        ]),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')), FilledButton(onPressed: () { final controller = context.read<AppController>(); controller.addPaymentMethod(PaymentMethodProfile(id: 'PM-${DateTime.now().millisecondsSinceEpoch}', type: type.text.trim(), holder: holder.text.trim(), last4: last4.text.trim().padLeft(4, '0'), isDefault: controller.currentUser.paymentMethods.isEmpty)); Navigator.pop(context); }, child: const Text('Guardar'))],
      ),
    );
  }
}

class _NotificationSwitches extends StatelessWidget {
  const _NotificationSwitches({required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();
    void update(NotificationPreferences preferences) => controller.updateProfile(fullName: user.fullName, phone: user.phone, address: user.address, notifications: preferences);
    return Card(child: Column(children: [
      SwitchListTile(value: user.notifications.orderUpdates, onChanged: (value) => update(user.notifications.copyWith(orderUpdates: value)), title: const Text('Actualizaciones de pedidos')),
      SwitchListTile(value: user.notifications.promotions, onChanged: (value) => update(user.notifications.copyWith(promotions: value)), title: const Text('Promociones')),
      SwitchListTile(value: user.notifications.stockAlerts, onChanged: (value) => update(user.notifications.copyWith(stockAlerts: value)), title: const Text('Alertas de stock')),
      SwitchListTile(value: user.notifications.offerReminders, onChanged: (value) => update(user.notifications.copyWith(offerReminders: value)), title: const Text('Recordatorios de ofertas')),
    ]));
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
    return SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      Text('Panel de usuario', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
      const SizedBox(height: 10),
      _MetricGrid(values: {'Pedidos': controller.visibleOrders.length.toString(), 'Carrito': controller.cartCount.toString(), 'Avisos': controller.notifications.length.toString()}),
      const SizedBox(height: 16),
      ...controller.visibleOrders.map((order) => ListTile(leading: const Icon(Icons.receipt_long), title: Text(order.id), subtitle: Text(order.status), trailing: Text('S/ ${order.total.toStringAsFixed(2)}'))),
    ]));
  }
}

class _SellerPanel extends StatelessWidget {
  const _SellerPanel();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final sellerProducts = controller.sellerProducts;
    return SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      Text('Panel de vendedor', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
      const SizedBox(height: 10),
      _MetricGrid(values: {'Productos': sellerProducts.length.toString(), 'Publicados': sellerProducts.where((product) => product.isApproved).length.toString(), 'En revisión': sellerProducts.where((product) => product.isPending).length.toString(), 'Stock bajo': sellerProducts.where((product) => product.isLowStock).length.toString(), 'Vendidos': controller.sellerUnitsSold.toString(), 'Ganancias': 'S/ ${controller.sellerRevenue.toStringAsFixed(0)}'}),
      const SizedBox(height: 16),
      FilledButton.icon(onPressed: () => _ProductEditor.show(context), icon: const Icon(Icons.add_box_outlined), label: const Text('Crear producto')),
      const SizedBox(height: 16),
      ...sellerProducts.map((product) => ListTile(leading: const Icon(Icons.inventory_2_outlined), title: Text(product.name), subtitle: Text('${product.category} · Stock ${product.stock}'), trailing: Wrap(children: [_StatusChip(product: product), IconButton(onPressed: () => _ProductEditor.show(context, product: product), icon: const Icon(Icons.edit_outlined)), IconButton(onPressed: () => controller.deleteProduct(product), icon: const Icon(Icons.delete_outline))]))),
    ]));
  }
}

class _AdminPanel extends StatelessWidget {
  const _AdminPanel();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      Text('Panel administrador', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
      const SizedBox(height: 10),
      _MetricGrid(values: {'Usuarios': controller.users.length.toString(), 'Productos': controller.products.length.toString(), 'Categorías': controller.categoryModels.length.toString(), 'Pendientes': controller.pendingProducts.length.toString(), 'Solicitudes': controller.roleRequests.length.toString()}),
      const SizedBox(height: 16),
      FilledButton.icon(onPressed: controller.seedDemoData, icon: const Icon(Icons.inventory_outlined), label: const Text('Cargar catálogo inicial')),
      const SizedBox(height: 16),
      Text('Productos pendientes de aprobación', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
      if (controller.pendingProducts.isEmpty) const ListTile(leading: Icon(Icons.check_circle_outline), title: Text('No hay productos pendientes.')),
      ...controller.pendingProducts.map((product) => ListTile(leading: const Icon(Icons.pending_actions), title: Text(product.name), subtitle: Text('${product.category} · Vendedor ${product.sellerId}'), trailing: Wrap(children: [FilledButton(onPressed: () => controller.approveProduct(product), child: const Text('Aprobar')), const SizedBox(width: 8), OutlinedButton(onPressed: () => controller.rejectProduct(product), child: const Text('Rechazar'))]))),
      const SizedBox(height: 16),
      Text('Solicitudes de acceso', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
      ...controller.roleRequests.map((request) => ListTile(leading: const Icon(Icons.manage_accounts), title: Text('${request.email} → ${request.requestedRole.label}'), subtitle: Text(request.reason), trailing: request.status == 'pending' ? FilledButton(onPressed: () => controller.approveRoleRequest(request), child: const Text('Aprobar')) : Chip(label: Text(request.status)))),
      const SizedBox(height: 16),
      Text('Productos de la tienda', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
      ...controller.products.map((product) => ListTile(leading: const Icon(Icons.inventory_2_outlined), title: Text(product.name), subtitle: Text('${product.category} · Stock ${product.stock}'), trailing: Wrap(children: [_StatusChip(product: product), IconButton(onPressed: () => _ProductEditor.show(context, product: product), icon: const Icon(Icons.edit_outlined)), IconButton(onPressed: () => controller.deleteProduct(product), icon: const Icon(Icons.delete_outline))]))),
      const SizedBox(height: 16),
      Text('Usuarios', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
      ...controller.users.map((user) => ListTile(leading: const Icon(Icons.person), title: Text(user.fullName), subtitle: Text(user.email), trailing: Chip(label: Text(user.role.label)))),
    ]));
  }
}

class _ProductEditor {
  static void show(BuildContext context, {Product? product}) {
    final name = TextEditingController(text: product?.name ?? '');
    final description = TextEditingController(text: product?.description ?? '');
    final category = TextEditingController(text: product?.category ?? 'Accesorios');
    final price = TextEditingController(text: (product?.price ?? 99.90).toString());
    final stock = TextEditingController(text: (product?.stock ?? 10).toString());
    final discount = TextEditingController(text: ((product?.discountRate ?? 0) * 100).toStringAsFixed(0));
    final threshold = TextEditingController(text: (product?.lowStockThreshold ?? 5).toString());
    final image = TextEditingController(text: product?.imageUrl ?? 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=900&q=80');
    final document = TextEditingController(text: product?.documentUrl ?? '');
    showDialog<void>(context: context, builder: (context) => AlertDialog(
      title: Text(product == null ? 'Crear producto' : 'Editar producto'),
      content: SizedBox(width: 520, child: SingleChildScrollView(child: Column(children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Nombre')),
        TextField(controller: description, decoration: const InputDecoration(labelText: 'Descripción')),
        TextField(controller: category, decoration: const InputDecoration(labelText: 'Categoría')),
        TextField(controller: price, decoration: const InputDecoration(labelText: 'Precio')),
        TextField(controller: stock, decoration: const InputDecoration(labelText: 'Stock')),
        TextField(controller: discount, decoration: const InputDecoration(labelText: 'Descuento (%)')),
        TextField(controller: threshold, decoration: const InputDecoration(labelText: 'Alerta de stock bajo')),
        TextField(controller: image, decoration: const InputDecoration(labelText: 'URL de imagen')),
        TextField(controller: document, decoration: const InputDecoration(labelText: 'URL de documento')),
        const SizedBox(height: 8),
        const Text('Los productos creados por vendedores pasan a revisión antes de publicarse.'),
      ]))),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')), FilledButton(onPressed: () { final controller = context.read<AppController>(); final next = Product(id: product?.id ?? 'PROD-${DateTime.now().millisecondsSinceEpoch}', name: name.text.trim(), description: description.text.trim(), category: category.text.trim(), price: double.tryParse(price.text) ?? 0, stock: int.tryParse(stock.text) ?? 0, imageUrl: image.text.trim(), rating: product?.rating ?? 4.5, isFeatured: product?.isFeatured ?? false, sellerId: product?.sellerId ?? controller.currentUser.id, discountRate: (double.tryParse(discount.text) ?? 0) / 100, lowStockThreshold: int.tryParse(threshold.text) ?? 5, documentUrl: document.text.trim(), approvalStatus: product?.approvalStatus ?? 'pending'); controller.saveProduct(next); Navigator.pop(context); }, child: const Text('Guardar'))],
    ));
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) {
    if (product.isApproved) return const Chip(label: Text('Publicado'));
    if (product.isPending) return const Chip(label: Text('En revisión'));
    return const Chip(label: Text('Rechazado'));
  }
}

class _NotificationsPage extends StatelessWidget {
  const _NotificationsPage();
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      Text('Avisos', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
      const SizedBox(height: 10),
      if (controller.notifications.isEmpty) const _EmptyState(icon: Icons.notifications_none, title: 'Sin avisos', message: 'Aquí aparecerán pedidos, promociones y alertas.') else ...controller.notifications.map((item) => ListTile(leading: const Icon(Icons.notifications_active_outlined), title: Text(item.title), subtitle: Text(item.message), trailing: Chip(label: Text(item.type)))),
    ]));
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.values});
  final Map<String, String> values;
  @override
  Widget build(BuildContext context) => Wrap(spacing: 12, runSpacing: 12, children: values.entries.map((entry) => SizedBox(width: 180, child: Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(entry.value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)), Text(entry.key)]))))).toList());
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow(this.label, this.value, {this.strong = false});
  final String label;
  final double value;
  final bool strong;
  @override
  Widget build(BuildContext context) { final style = strong ? Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900) : null; return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: style), Text('S/ ${value.toStringAsFixed(2)}', style: style)]); }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Chip(label: Text(text));
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title, required this.message});
  final IconData icon;
  final String title;
  final String message;
  @override
  Widget build(BuildContext context) => Center(child: Card(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 52), const SizedBox(height: 10), Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(message, textAlign: TextAlign.center)]))));
}
