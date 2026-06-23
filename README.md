# Ecommerce Flutter

Aplicación ecommerce desarrollada con **Flutter + Firebase** para portafolio. La versión actual ya funciona como base con catálogo, carrito, checkout, Firestore y panel administrativo básico. La rama `portfolio-ecommerce-refactor` queda orientada a una V2 más completa, escalable y realista.

## Objetivo V2

Construir un ecommerce responsive para **Web y Android** con:

- Firebase Authentication.
- Inicio con email y Google.
- Cierre de sesión y recuperación de acceso.
- Solicitud de acceso a roles: usuario, vendedor y admin.
- Paneles diferenciados por rol.
- CRUD de productos, categorías, usuarios y pedidos.
- Perfil editable con datos personales, métodos de pago simulados y preferencias de notificación.
- Firebase Storage para imágenes/documentos, guardando en Firestore solo URL, ruta y metadata.
- Cálculos de subtotal, impuestos, descuentos, envío, total y stock.
- Firebase Cloud Messaging preparado para pedidos, promociones, stock bajo y ofertas.
- Modo cloud simulation para que reclutadores/profesores puedan probar los tres roles sin configuración manual.

## Arquitectura objetivo

```text
lib/
├── main.dart
└── src/
    ├── core/
    │   ├── constants/
    │   ├── routing/
    │   ├── theme/
    │   └── utils/
    ├── models/
    │   ├── app_user.dart
    │   ├── category.dart
    │   ├── product.dart
    │   ├── order.dart
    │   ├── payment_method.dart
    │   └── notification_item.dart
    ├── services/
    │   ├── auth_service.dart
    │   ├── firestore_service.dart
    │   ├── storage_service.dart
    │   ├── messaging_service.dart
    │   └── role_access_service.dart
    ├── repositories/
    │   ├── auth_repository.dart
    │   ├── product_repository.dart
    │   ├── category_repository.dart
    │   ├── user_repository.dart
    │   └── order_repository.dart
    ├── controllers/
    │   ├── auth_controller.dart
    │   ├── catalog_controller.dart
    │   ├── cart_controller.dart
    │   ├── profile_controller.dart
    │   └── admin_controller.dart
    ├── features/
    │   ├── auth/
    │   ├── customer/
    │   ├── seller/
    │   ├── admin/
    │   ├── profile/
    │   └── checkout/
    └── shared/
        ├── widgets/
        └── layout/
```

## Funcionalidades actuales

- Catálogo responsive con búsqueda y filtro por categoría.
- Carrito de compras con incremento, reducción, eliminación y total automático.
- Checkout con validación de formulario.
- Creación de órdenes en Cloud Firestore cuando Firebase está disponible.
- Panel administrativo con métricas básicas y sincronización de productos demo a Firestore.
- Fallback local para que la app no falle si el entorno no tiene credenciales Firebase configuradas.

## Stack técnico

| Área | Tecnología |
|---|---|
| Framework | Flutter |
| Lenguaje | Dart |
| Estado | Provider + ChangeNotifier |
| Backend | Firebase |
| Base de datos | Cloud Firestore |
| Autenticación | Firebase Auth |
| Archivos | Firebase Storage |
| Notificaciones | Firebase Cloud Messaging ready |
| UI | Material 3 responsive |

## Colecciones Firestore objetivo

```text
users
roleRequests
categories
products
orders
notifications
promotions
```

## Buenas prácticas Storage

Las imágenes y documentos no deben guardarse como bytes/base64 en Firestore. La app debe subirlos a Storage y guardar en Firestore solamente:

```text
fileUrl
filePath
contentType
uploadedBy
createdAt
```

Rutas recomendadas:

```text
users/{uid}/profile
products/{sellerId}/{productId}/images
products/{sellerId}/{productId}/documents
orders/{orderId}/documents
```

## Modo cloud simulation

El proyecto debe permitir probar el sistema completo sin depender de cuentas manuales:

- Entrar como usuario demo.
- Entrar como vendedor demo.
- Entrar como admin demo.
- Solicitar cambio de rol.
- Crear productos, categorías y pedidos demo.
- Simular pagos.
- Simular notificaciones.

## Cálculos de compra

```text
subtotal = precio * cantidad
descuento = subtotal * porcentajeDescuento
base = subtotal - descuento
impuesto = base * porcentajeImpuesto
total = base + impuesto + envío
```

## Instalación local

```bash
git clone https://github.com/jhoaoo/ecommerce_flutter.git
cd ecommerce_flutter
flutter pub get
flutter run
```

## Autor

**Jhoaoo Sebastián Llerena Quispe**  
Estudiante de Ingeniería de Sistemas · UCSM  
Arequipa, Perú
