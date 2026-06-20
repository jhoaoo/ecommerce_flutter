# Ecommerce Flutter

Aplicación de comercio electrónico desarrollada en **Flutter** como proyecto de lógica de negocio, arquitectura móvil y conexión con backend. Implementa un flujo de compra con catálogo, detalle de producto, carrito persistente, autenticación y soporte offline utilizando Firebase como backend principal.

> **Estado:** En desarrollo activo.

## Descripción

Este proyecto busca simular una aplicación de ecommerce moderna, priorizando una estructura clara, separación de responsabilidades y una experiencia de usuario fluida. Además de la interfaz, el proyecto trabaja conceptos importantes como persistencia local, autenticación, sincronización con Firestore y organización por capas.

## Stack

| Capa | Tecnología |
|---|---|
| UI | Flutter · Dart |
| Animaciones | flutter_animate · carousel_slider |
| Navegación | go_router |
| Estado | Provider · RxDart |
| Autenticación | Firebase Auth · Google Sign-In |
| Base de datos | Firebase Firestore |
| Almacenamiento | Firebase Storage |
| Persistencia local | sqflite · SharedPreferences |

## Arquitectura

```text
lib/
├── core/
│   ├── router/          # Rutas, navegación y guards
│   └── utils/           # Constantes, helpers y utilidades
├── data/
│   ├── local/           # Persistencia local con sqflite
│   ├── remote/          # Firebase Firestore / Storage
│   └── repositories/    # Abstracción de fuentes de datos
├── domain/
│   ├── models/          # Entidades principales
│   └── providers/       # Estado y lógica de presentación
└── presentation/
    ├── screens/         # Pantallas principales
    └── widgets/         # Componentes reutilizables
```

## Decisiones técnicas

### Carrito offline-first

El carrito se guarda localmente para mantener la experiencia incluso sin conexión. La sincronización con Firestore puede ampliarse para conservar consistencia entre dispositivos.

### Estado con Provider + RxDart

Provider permite actualizar la interfaz de forma sencilla, mientras que RxDart facilita el manejo de streams y datos reactivos.

### Repository pattern

La lógica de negocio no depende directamente de la fuente de datos. La capa de repositorio decide si obtener información desde almacenamiento local o remoto.

## Funcionalidades implementadas

- Autenticación con email y Google Sign-In.
- Catálogo de productos desde Firestore.
- Carrito de compras con persistencia entre sesiones.
- Detalle de producto con galería de imágenes.
- Gestión de favoritos.
- Navegación declarativa con control de autenticación.

## En desarrollo

- Flujo de checkout y pagos.
- Historial de pedidos.
- Filtros y búsqueda avanzada.
- Panel de administración.
- Mejoras de testing y documentación técnica.

## Instalación local

```bash
git clone https://github.com/jhoaoo/ecommerce_flutter.git
cd ecommerce_flutter
flutter pub get
flutter run
```

> Requiere Flutter 3.x y configuración propia de Firebase. Archivos sensibles como `google-services.json` no deben subirse al repositorio.

## Valor para portafolio

Este proyecto demuestra manejo de Flutter, Firebase, persistencia local, arquitectura por capas y buenas prácticas de organización para aplicaciones móviles.

## Autor

**Jhoaoo Sebastián Llerena Quispe**  
Estudiante de Ingeniería de Sistemas · UCSM  
Arequipa, Perú

[GitHub](https://github.com/jhoaoo) · [LinkedIn](https://www.linkedin.com/in/jhoaoo-llerena-quispe-78a602331/)