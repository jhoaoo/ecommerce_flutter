# NovaMarket Ecommerce

Aplicación ecommerce desarrollada con Flutter y Firebase para portafolio profesional. La app está organizada por capas y módulos, con experiencia responsive para Web y Android.

## Experiencia por rol

### Usuario

- Compra productos publicados.
- Usa carrito y checkout con pagos simulados.
- Revisa pedidos y avisos.
- Edita perfil.
- Configura idioma y modo claro/oscuro.
- Administra preferencias de notificación.
- Solicita acceso como vendedor o administrador para pruebas.

### Vendedor

Incluye todo lo del usuario y además:

- Crear productos.
- Editar precio, stock, descuento, categoría, imagen y documento.
- Eliminar productos propios.
- Ver dashboard de ventas, unidades vendidas, ganancias, stock bajo y productos en revisión.
- Los productos nuevos quedan en revisión hasta que un administrador los apruebe.

### Administrador

- Control total de usuarios, productos, categorías y solicitudes.
- Aprobar o rechazar productos antes de que aparezcan en la tienda.
- Aprobar solicitudes de acceso.
- Editar o eliminar cualquier producto.
- Cargar catálogo inicial para pruebas.

## Arquitectura

```text
lib/
└── src/
    ├── controllers/
    ├── core/
    ├── models/
    ├── repositories/
    └── services/
```

## Buenas prácticas implementadas

- La interfaz no muestra nombres técnicos del backend.
- Las imágenes y documentos se manejan como URL/ruta/metadata, no como base64 en base de datos.
- El catálogo del comprador solo muestra productos activos y aprobados.
- Los productos creados por vendedores requieren aprobación.
- Los cálculos incluyen subtotal, descuento, IGV, envío y total.
- El proyecto funciona con datos de prueba y queda preparado para servicios reales.

## Ejecutar

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

## Autor

Jhoaoo Sebastián Llerena Quispe  
Ingeniería de Sistemas · UCSM · Arequipa, Perú
