# Ecommerce Flutter V2

Sistema ecommerce multifuncional creado con **Flutter + Firebase** para portafolio profesional.

## Funciones principales

- Web + Android.
- Diseño responsive con NavigationRail en escritorio/tablet y NavigationBar en móvil.
- Firebase Auth con email/password y Google Sign-In preparado.
- Cloud simulation para probar como usuario, vendedor o admin sin cuentas manuales.
- Solicitud de acceso a roles.
- Panel de usuario, vendedor y admin.
- CRUD funcional de productos en modo vendedor/admin.
- CRUD preparado para categorías, usuarios y pedidos.
- Perfil editable con métodos de pago simulados y preferencias de notificaciones.
- Firebase Storage preparado para imágenes y documentos.
- Firestore guarda solo URL/ruta/metadata de archivos, nunca base64 o bytes.
- Cálculos automáticos de subtotal, descuentos, IGV, envío y total.
- Stock bajo, actualización de stock y checkout.
- FCM-ready para tokens, pedidos, promociones, stock y ofertas.

## Arquitectura

```text
lib/
├── main.dart
└── src/
    ├── app.dart
    ├── core/
    ├── controllers/
    ├── models/
    ├── repositories/
    └── services/
```

## Capas

- `core`: roles, colecciones, Firebase bootstrap.
- `models`: entidades del dominio.
- `services`: Firebase Auth, Firestore, Storage, Messaging y roles.
- `repositories`: capa de acceso a datos y fallback demo.
- `controllers`: estado global y casos de uso.
- `app.dart`: UI responsive y paneles.

## Ejecución

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Para Android:

```bash
flutter run -d android
```

## Notas Firebase

Para una demo real completa debes activar en Firebase Console:

1. Authentication: Email/Password y Google.
2. Firestore Database.
3. Firebase Storage.
4. Cloud Messaging.
5. Reglas de seguridad por rol.

El proyecto mantiene cloud simulation para que siempre se pueda probar aunque Firebase no esté configurado localmente.

## Autor

Jhoaoo Sebastián Llerena Quispe  
Ingeniería de Sistemas · UCSM · Arequipa, Perú
