# Ecommerce Flutter

Aplicación ecommerce desarrollada con **Flutter + Firebase** para portafolio. El proyecto presenta una arquitectura más limpia, separada por capas, con catálogo de productos, carrito, checkout, creación de órdenes y panel administrativo básico.

> Estado: versión portfolio funcional. Puede ejecutarse con Firebase conectado o en modo demo con fallback local.

## Funcionalidades

- Catálogo responsive con búsqueda y filtro por categoría.
- Carrito de compras con incremento, reducción, eliminación y total automático.
- Checkout con validación de formulario.
- Creación de órdenes en **Cloud Firestore** cuando Firebase está disponible.
- Autenticación anónima con **Firebase Auth** para identificar sesiones demo.
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
| Autenticación | Firebase Auth anónimo |
| UI | Material 3 |

## Arquitectura

```text
lib/
├── main.dart
└── src/
    ├── app.dart                 # MaterialApp, navegación y pantallas
    ├── firebase_bootstrapper.dart # Inicialización segura de Firebase
    ├── models.dart              # Entidades de dominio y datos demo
    ├── repositories.dart        # Contratos e implementación Firebase
    └── shop_controller.dart     # Estado global de tienda
```

## Colecciones Firestore usadas

### `products`

```json
{
  "name": "Keyboard Pro X",
  "description": "Teclado mecánico compacto",
  "category": "Accesorios",
  "price": 249.90,
  "stock": 18,
  "imageUrl": "https://...",
  "rating": 4.8,
  "isFeatured": true,
  "updatedAt": "serverTimestamp"
}
```

### `orders`

```json
{
  "userId": "firebase-auth-uid",
  "customerName": "Cliente Demo",
  "customerEmail": "cliente@email.com",
  "status": "pending",
  "paymentMethod": "demo_checkout",
  "total": 249.90,
  "items": [
    {
      "productId": "keyboard-pro",
      "name": "Keyboard Pro X",
      "price": 249.90,
      "quantity": 1,
      "subtotal": 249.90
    }
  ],
  "createdAt": "serverTimestamp"
}
```

## Instalación local

```bash
git clone https://github.com/jhoaoo/ecommerce_flutter.git
cd ecommerce_flutter
flutter pub get
flutter run
```

## Firebase

El proyecto mantiene Firebase como parte central para demostrar uso real de base de datos. La app intenta inicializar Firebase al arrancar:

- En Web usa las opciones configuradas del proyecto `ecommerce-7ea77`.
- En Android usa `android/app/google-services.json`.
- Si Firebase no está disponible, activa modo demo local para evitar fallos de ejecución.

Para probar Firestore:

1. Ejecuta la app.
2. Entra al módulo **Admin**.
3. Presiona **Sincronizar productos demo**.
4. Revisa la colección `products` en Firebase.
5. Crea una compra desde el checkout y revisa la colección `orders`.

## Valor para portafolio

Este repositorio demuestra:

- Diseño de arquitectura por capas.
- Separación entre UI, estado, repositorios y modelos.
- Integración real con Firebase Auth y Cloud Firestore.
- Flujo ecommerce completo: catálogo → carrito → checkout → orden.
- Manejo defensivo de errores para que el proyecto sea presentable y ejecutable en diferentes entornos.

## Autor

**Jhoaoo Sebastián Llerena Quispe**  
Estudiante de Ingeniería de Sistemas · UCSM  
Arequipa, Perú
