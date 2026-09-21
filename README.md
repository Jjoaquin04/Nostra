# 💰 Nostra

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?style=for-the-badge&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-lightgrey?style=for-the-badge)

Una aplicación multiplataforma de gestión de gastos e ingresos construida con Flutter, que utiliza arquitectura limpia y BLoC para la gestión de estado.

[Características](#-características) • [Instalación](#-instalación) • [Uso](#-uso) • [Arquitectura](#-arquitectura) • [Contribuir](#-contribuir)

</div>

---

## 📸 Capturas de Pantalla

<div align="center">
  <img src="screenshots/welcome_screen.jpg" width="250" alt="Pantalla Principal"/>
  <img src="screenshots/expense_screen.jpg" width="250" alt="Agregar Gasto"/>
  <img src="screenshots/previous_month_screen.jpg" width="250" alt="Vista Mensual"/>
  <img src="screenshots/home_widgets.jpg" width="250" alt="Widget de Inicio"/>
</div>

## ✨ Características

### 📊 Gestión Completa
- ✅ **Registro de Gastos e Ingresos**: Añade, edita y elimina transacciones fácilmente
- ✅ **Categorización**: Organiza tus movimientos por categorías personalizables
- ✅ **Vista Mensual**: Visualiza tus gastos e ingresos mes a mes
- ✅ **Resumen por Tipo**: Agrupa automáticamente los gastos e ingresos por categoría

### 🎯 Funcionalidades Avanzadas
- ✅ **Modo de Selección Múltiple**: Elimina varios gastos a la vez
- ✅ **Gastos Fijos**: Marca gastos recurrentes para mejor seguimiento
- ✅ **Widget de Inicio**: Visualiza tus gastos directamente desde la pantalla de inicio (Android)
- ✅ **Actualización en Tiempo Real**: Los cambios se reflejan instantáneamente
- ✅ **Persistencia Local**: Almacenamiento offline con Hive

### 🎨 Interfaz de Usuario
- ✅ **Diseño Material**: Interfaz moderna y limpia
- ✅ **Animaciones Fluidas**: Transiciones suaves entre pantallas
- ✅ **Modo Responsive**: Adaptable a diferentes tamaños de pantalla
- ✅ **Feedback Visual**: Snackbars y animaciones para confirmar acciones

## 🚀 Instalación

### Requisitos Previos

- Flutter SDK (>=3.9.2)
- Dart SDK (>=3.9.2)
- Android Studio / VS Code con extensiones de Flutter
- Git

### Pasos de Instalación

1. **Clona el repositorio**
   ```bash
   git clone https://github.com/Jjoaquin04/track_expenses.git
   cd track_expenses
   ```

2. **Instala las dependencias**
   ```bash
   flutter pub get
   ```

3. **Genera los archivos necesarios**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Ejecuta la aplicación**
   ```bash
   flutter run
   ```

### Configuración del Widget de Inicio (Android)

Para habilitar el widget de la pantalla de inicio en Android:

1. Agrega el widget a tu pantalla de inicio desde la lista de widgets
2. El widget mostrará automáticamente tus gastos del mes actual
3. Toca el widget para abrir la aplicación directamente

## 📱 Uso

### Agregar un Gasto/Ingreso

1. Toca el botón **+** en la parte inferior derecha
2. Completa el formulario:
   - **Nombre**: Descripción del movimiento
   - **Categoría**: Selecciona o crea una categoría
   - **Monto**: Cantidad en euros
   - **Fecha**: Selecciona la fecha del movimiento
   - **Tipo**: Gasto o Ingreso
   - **Gasto Fijo**: Marca si es un gasto recurrente
3. Presiona **Guardar**

### Ver Meses Anteriores

1. Toca el botón del **calendario** en la parte inferior izquierda
2. Desliza entre las tarjetas para ver diferentes meses
3. Cada tarjeta muestra:
   - Total de gastos e ingresos del mes
   - Desglose por categoría
   - Montos acumulados por tipo

### Eliminar Gastos

**Eliminar uno a la vez:**
- Mantén presionado un gasto y selecciona el botón de eliminar

**Eliminar múltiples:**
1. Mantén presionado un gasto para activar el modo de selección
2. Toca los gastos que deseas eliminar
3. Presiona el botón **Eliminar**
4. Confirma la acción

## 🏗 Arquitectura

Este proyecto sigue los principios de **Clean Architecture** y utiliza el patrón **BLoC** para la gestión de estado.

### Estructura del Proyecto

```
lib/
├── core/
│   ├── constant/        # Constantes de la aplicación
│   ├── dependency_injection/  # Configuración de Get It
│   ├── errors/          # Manejo de errores
│   ├── themes/          # Temas y estilos
│   ├── usecases/        # Casos de uso base
│   └── utils/           # Utilidades generales
│
├── featured/
│   └── 
│       ├── data/
│       │   ├── datasources/     # Fuente de datos (Hive)
│       │   ├── expense_model.dart   # Modelo de datos
│       │   └── expense_repository_impl.dart
│       │
│       ├── domain/
│       │   ├── entity/          # Entidades de dominio
│       │   ├── repository/      # Interfaces de repositorio
│       │   └── usecases/        # Casos de uso
│       │
│       └── presentation/
│           ├── bloc/            # Lógica de negocio (BLoC)
│           ├── pages/           # Pantallas principales
│           └── widgets/         # Widgets reutilizables
│               ├── expenses_screen/
│               └── previous_months_screen/
│
└── main.dart
```

### Capas de la Arquitectura

#### 📦 Data Layer
- **Modelos**: Conversión entre JSON y objetos Dart
- **Datasources**: Interacción con Hive DB
- **Repository Implementation**: Implementación concreta del repositorio

#### 🎯 Domain Layer
- **Entities**: Objetos de negocio puros
- **Repository Interfaces**: Contratos para acceso a datos
- **Use Cases**: Lógica de negocio específica

#### 🎨 Presentation Layer
- **BLoC**: Gestión de estado y eventos
- **Pages**: Pantallas principales (solo Scaffold)
- **Widgets**: Componentes UI reutilizables

### Tecnologías Utilizadas

| Tecnología | Propósito |
|------------|-----------|
| **Flutter** | Framework multiplataforma |
| **Hive** | Base de datos NoSQL local |
| **BLoC** | Gestión de estado |
| **Get It** | Inyección de dependencias |
| **Equatable** | Comparación de objetos |
| **Dartz** | Programación funcional (Either) |
| **Home Widget** | Widget de pantalla de inicio |

## 🤝 Contribuir (Política de Proyecto Estático)

Este proyecto está liberado bajo la **Licencia MIT**, lo que significa que tienes **total libertad para hacer un 'fork' (copia), usar, modificar y distribuir el código** para tu propio uso.

**IMPORTANTE: Este repositorio original no está aceptando Pull Requests ni se ofrece soporte activo de mantenimiento por parte del autor.**

Si deseas mejorar, corregir un bug o añadir funcionalidades:
1.  Haz un **Fork** del proyecto.
2.  Realiza tus cambios en tu propio repositorio (el 'fork').
3.  Recomendamos crear 'Issues' en tu propio fork o en el repositorio original solo para dejar constancia de los bugs o ideas, pero **el autor original no garantiza una respuesta ni una implementación**.

Si necesitas ayuda para la implementación, el autor sugiere buscar asistencia en la comunidad de Flutter. ¡Gracias por usar el código!

## 📋 Roadmap

- [ ] Gráficos y estadísticas avanzadas
- [ ] Exportar datos a CSV/PDF
- [ ] Sincronización en la nube
- [ ] Modo oscuro
- [ ] Múltiples monedas
- [ ] Presupuestos mensuales
- [ ] Notificaciones de gastos recurrentes
- [ ] Soporte multiidioma
- [ ] Autenticación de usuario

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

```
MIT License

Copyright (c) 2025 Joaquín

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 👨‍💻 Autor

**Joaquín**

- GitHub: [@Jjoaquin04](https://github.com/Jjoaquin04)

## ⭐ Dale una Estrella

Si este proyecto te ha sido útil, ¡considera darle una estrella en GitHub! ⭐

## 🙏 Agradecimientos

- Gracias a la comunidad de Flutter por el increíble framework
- A todos los contribuidores que ayudan a mejorar este proyecto
- A los usuarios que reportan bugs y sugieren mejoras

---

<div align="center">

**¿Te ha gustado este proyecto? ¡Compártelo!**

[![GitHub](https://img.shields.io/badge/GitHub-Comparte-181717?style=for-the-badge&logo=github)](https://github.com/Jjoaquin04/track_expenses)

Hecho con ❤️ usando Flutter

</div>
