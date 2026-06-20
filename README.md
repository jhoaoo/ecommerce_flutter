# Ecommerce Flutter

Aplicación móvil de comercio electrónico desarrollada con **Flutter / FlutterFlow** e integrada con **Firebase**. El proyecto implementa una experiencia tipo ecommerce con autenticación, navegación por módulos, flujo de usuario, carrito, checkout y panel administrativo.

> **Estado:** Proyecto académico / portafolio en desarrollo activo.

---

## Descripción

Este proyecto tiene como objetivo construir una aplicación ecommerce funcional, organizada y escalable, aplicando desarrollo móvil con Flutter, autenticación con Firebase y una estructura de pantallas separada por roles de usuario y administración.

El repositorio funciona como evidencia técnica de aprendizaje en:

- Desarrollo móvil multiplataforma.
- Integración con Firebase.
- Autenticación de usuarios.
- Navegación con rutas protegidas.
- Diseño de interfaces con FlutterFlow.
- Organización de un proyecto mobile para portafolio.

---

## Funcionalidades principales

### Módulo de usuario

- Pantalla principal de usuario.
- Registro e inicio de sesión.
- Carrito de compras.
- Página de pedidos.
- Flujo de checkout.

### Módulo administrativo

- Dashboard de administración.
- Gestión de compras.
- Gestión de categorías.
- Gestión de órdenes.
- Gestión de clientes.
- Gestión de pagos.
- Gestión de envíos.

---

## Stack técnico

| Área | Tecnología |
|---|---|
| Framework móvil | Flutter |
| Generación visual | FlutterFlow |
| Lenguaje | Dart |
| Backend | Firebase |
| Autenticación | Firebase Auth · Google Sign-In · Apple Sign-In |
| Base de datos | Cloud Firestore |
| Almacenamiento | Firebase Storage |
| Navegación | GoRouter |
| Estado / streams | Provider · RxDart |
| Persistencia local | SharedPreferences · sqflite |
| Multimedia / archivos | Image Picker · File Picker · Video Player |

---

## Estructura general

```text
lib/
├── auth/                 # Autenticación y utilidades de usuario
├── backend/              # Configuración e integración con Firebase
├── flutter_flow/         # Componentes, tema, navegación y utilidades FlutterFlow
├── user/                 # Pantallas del flujo de usuario
├── admin/                # Pantallas del panel administrativo
├── index.dart            # Exportación de pantallas principales
└── main.dart             # Inicialización de Firebase, rutas y app principal
```

---

## Pantallas principales

| Tipo | Pantallas |
|---|---|
| Autenticación | Login, registro e inicio inicial |
| Usuario | Home, carrito, pedidos, checkout |
| Administración | Dashboard, compras, categorías, órdenes, clientes, pagos y envíos |

---

## Decisiones técnicas

### Firebase como backend principal

La aplicación inicializa Firebase al arrancar y lo usa como base para autenticación, almacenamiento y conexión con servicios backend.

### Navegación con GoRouter

El proyecto utiliza navegación declarativa mediante GoRouter, lo que permite organizar rutas y controlar el flujo entre pantallas.

### Separación por módulos

Las pantallas están separadas en módulos de usuario, autenticación y administración, facilitando el mantenimiento y la evolución del proyecto.

### FlutterFlow + Flutter

El proyecto aprovecha FlutterFlow para acelerar la construcción visual, pero mantiene una base exportada en Flutter/Dart que puede revisarse, versionarse y mejorarse desde código.

---

## Instalación local

```bash
git clone https://github.com/jhoaoo/ecommerce_flutter.git
cd ecommerce_flutter
flutter pub get
flutter run
```

> Requiere Flutter SDK compatible con Dart `>=3.0.0 <4.0.0` y configuración propia de Firebase.

---

## Configuración necesaria

Para ejecutar correctamente el proyecto se requiere configurar Firebase en el entorno local. Por seguridad, los archivos sensibles de configuración no deben exponerse públicamente.

Archivos típicos a revisar según plataforma:

```text
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
lib/firebase_options.dart
```

---

## Roadmap

- Mejorar documentación técnica por módulo.
- Agregar capturas de pantalla de la app.
- Documentar el modelo de datos de Firestore.
- Validar flujos completos de compra y administración.
- Agregar pruebas básicas.
- Preparar una demo visual para portafolio.

---

## Valor para portafolio

Este proyecto demuestra experiencia práctica con Flutter, FlutterFlow, Firebase, autenticación, navegación, organización modular y desarrollo de una aplicación móvil con flujo de usuario y administración.

---

## Autor

**Jhoaoo Sebastián Llerena Quispe**  
Estudiante de Ingeniería de Sistemas · UCSM  
Arequipa, Perú

[GitHub](https://github.com/jhoaoo) · [LinkedIn](https://www.linkedin.com/in/jhoaoo-llerena-quispe-78a602331/)