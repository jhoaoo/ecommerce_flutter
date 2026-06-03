# Ecommerce Flutter

Aplicación de comercio electrónico construida en Flutter como desafío de lógica de negocio. Implementa el flujo completo de compra — catálogo, detalle de producto, carrito persistente y autenticación — con soporte offline y Firebase como backend.

> **Estado:** En desarrollo activo.

---

## Stack

| Capa | Tecnología |
|---|---|
| UI | Flutter · Dart |
| Animaciones | flutter_animate · carousel_slider |
| Navegación | go_router |
| Estado | Provider · RxDart |
| Auth | Firebase Auth · Google Sign-In |
| Base de datos | Firebase Firestore |
| Almacenamiento | Firebase Storage |
| Persistencia local | sqflite · SharedPreferences |

---

## Arquitectura

```
lib/
├── core/
│   ├── router/          # go_router — rutas y guards
│   └── utils/           # helpers, constantes
├── data/
│   ├── local/           # sqflite — carrito offline
│   ├── remote/          # Firestore + Storage
│   └── repositories/    # abstracción fuente de datos
├── domain/
│   ├── models/          # Product, CartItem, User
│   └── providers/       # CartProvider, AuthProvider
└── presentation/
    ├── screens/         # Home, Detalle, Carrito, Auth
    └── widgets/         # ProductCard, CartTile, etc.
```

---

## Decisiones técnicas

**Carrito offline-first** — El carrito se guarda en sqflite localmente. Cuando el usuario recupera conexión, se sincroniza con Firestore automáticamente sin pérdida de datos.

**Estado con Provider + RxDart** — `CartProvider` extiende `ChangeNotifier` para la UI y usa `BehaviorSubject` para streams de productos desde Firestore.

**Repository pattern** — La lógica de negocio no conoce si los datos vienen de sqflite o Firestore. La capa de repositorio decide la fuente según conectividad.

---

## Funcionalidades implementadas

- Autenticación con Email y Google Sign-In
- Catálogo de productos desde Firestore en tiempo real
- Carrito de compras con persistencia entre sesiones
- Detalle de producto con galería de imágenes
- Gestión de favoritos
- Navegación declarativa con guards de autenticación

## En desarrollo

- Flujo de checkout y pagos
- Historial de pedidos
- Filtros y búsqueda avanzada
- Panel de administración

---

## Instalación local

```bash
git clone https://github.com/jhoaoo/ecommerce_flutter.git
cd ecommerce_flutter

flutter pub get
flutter run
```

> Requiere Flutter 3.x y Firebase configurado. El archivo `google-services.json` no está incluido por razones de seguridad.

---

## Autor

**Jhoaoo Sebastian Llerena Quispe**
Estudiante de Ingeniería de Sistemas

[LinkedIn](https://www.linkedin.com/in/jhoaoo-llerena-quispe-78a602331/) · [GitHub](https://github.com/jhoaoo) · [jhoaoollerena@gmail.com](mailto:jhoaoollerena@gmail.com)
