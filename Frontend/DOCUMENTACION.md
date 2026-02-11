# Documentación del Proyecto - Biblioteca Infantil (Frontend Flutter)

## Estructura del Proyecto

```
lib/
├── main.dart                                    → Punto de entrada de la app
├── data/
│   └── datos_simulados.dart                     → Datos de prueba (libros, solicitudes, préstamos)
├── models/
│   ├── ejemplar.dart                            → Modelo de un ejemplar físico de un libro
│   ├── libro.dart                               → Modelo de un libro (con lista de ejemplares)
│   ├── solicitud.dart                           → Modelo de una solicitud de préstamo
│   └── prestamo.dart                            → Modelo de un préstamo activo
├── screens/
│   └── dashboard_screen.dart                    → Pantalla principal (layout general con estado)
├── views/
│   ├── libros/
│   │   └── libro_detalle.dart                   → Detalle del libro con lista de ejemplares
│   ├── gestor/
│   │   └── bandeja_solicitudes_page.dart         → Panel del bibliotecario (aprobar/rechazar)
│   └── prestamos/
│       └── mis_prestamos.dart                    → Préstamos activos con devolución
└── widgets/
    ├── sidebar_left.dart                        → Menú de navegación lateral izquierdo
    ├── header.dart                              → Barra superior (logo, búsqueda, perfil)
    ├── content_section.dart                     → Banner promocional y filtros
    ├── item_grip.dart                           → Grid de tarjetas de libros
    └── sidebar_right.dart                       → Panel lateral derecho (usuarios activos)
```

---

## Flujo general de la aplicación

```
Usuario abre la app
    → main.dart carga BibliotecaApp
    → Se muestra DashboardScreen (pantalla principal)
        → SidebarLeft (navegación)
        → Header (logo + búsqueda)
        → ContentSection (banner + filtros)
        → ItemsGrid (tarjetas de libros)
        → SidebarRight (usuarios activos, solo en pantallas >1200px)

Usuario busca un libro
    → Escribe en el Header → filtra en ItemsGrid por título/autor/área
    → Toca un filtro en ContentSection → filtra por disponibilidad

Usuario toca "Ver Detalles"
    → Navega a LibroDetallePage
    → Ve la lista de ejemplares con condición y disponibilidad
    → Toca "Solicitar" → Se crea una Solicitud en la lista simulada

Bibliotecario toca "Solicitudes" en el sidebar
    → Navega a BandejaSolicitudesPage
    → Ve solicitudes pendientes
    → "Aprobar" → Crea un Préstamo + marca ejemplar como no disponible
    → "Rechazar" → Cambia estado de la solicitud

Bibliotecario toca "Prestamos" en el sidebar
    → Navega a MisPrestamosPage
    → Ve préstamos activos
    → "Registrar Devolución" → Diálogo pide condición + observaciones
    → Marca el préstamo como inactivo y el ejemplar como disponible
```

---

## 1. main.dart

```dart
import 'package:flutter/material.dart';       // Línea 1: Importa los widgets de Material Design de Flutter
import 'screens/dashboard_screen.dart';        // Línea 2: Importa la pantalla principal del dashboard

void main() {                                  // Línea 4: Función principal, punto de entrada de la app
  runApp(const BibliotecaApp());               // Línea 5: Ejecuta la aplicación con el widget raíz BibliotecaApp
}

class BibliotecaApp extends StatelessWidget{   // Línea 9: Define el widget raíz, StatelessWidget porque no cambia de estado
  const BibliotecaApp({super.key});            // Línea 10: Constructor constante con key opcional

  @override
  Widget build(BuildContext context){          // Línea 13: Método que construye la interfaz visual
    return MaterialApp(                        // Línea 14: Widget raíz de una app Material Design
      title: 'Biblioteca Escolar',             // Línea 15: Título de la app (aparece en el task manager)
      debugShowCheckedModeBanner: false,        // Línea 16: Oculta la franja "DEBUG" de la esquina superior derecha
      theme: ThemeData(                        // Línea 17: Define el tema visual global de la app
        primarySwatch: Colors.blue,            // Línea 18: Color primario de la app (azul)
        brightness: Brightness.dark,           // Línea 19: Tema oscuro para toda la app
        scaffoldBackgroundColor: const Color(0xFF18181B),  // Línea 20: Color de fondo del scaffold (gris muy oscuro)
      ),
      home: const DashboardScreen(),           // Línea 22: La primera pantalla que se muestra al abrir la app
    );
  }
}
```

**¿Qué hace este archivo?**
Es el punto de entrada. Configura el tema oscuro global y establece `DashboardScreen` como la pantalla inicial.

---

## 2. models/ejemplar.dart

```dart
class Ejemplar {                               // Línea 1: Clase que representa un ejemplar físico de un libro
  final String id;                             // Línea 2: Identificador único del ejemplar (ej: "E1-1")
  String condicion;                            // Línea 3: Estado físico del ejemplar ("Bueno", "Regular", "Malo")
                                               //          Es mutable (String, no final) porque cambia al devolver
  bool disponible;                             // Línea 4: Si el ejemplar está disponible para préstamo

  Ejemplar({                                   // Línea 6: Constructor con parámetros nombrados
    required this.id,                          // Línea 7: id es obligatorio
    required this.condicion,                   // Línea 8: condicion es obligatoria
    this.disponible = true,                    // Línea 9: disponible es true por defecto (nuevo = disponible)
  });
}
```

**¿Qué hace este archivo?**
Define la estructura de un ejemplar físico. Un libro puede tener múltiples ejemplares, cada uno con su propia condición y disponibilidad.

---

## 3. models/libro.dart

```dart
import 'ejemplar.dart';                        // Línea 1: Importa el modelo Ejemplar

class Libro {                                  // Línea 3: Clase que representa un libro en la biblioteca
  final String id;                             // Línea 4: Identificador único del libro
  final String titulo;                         // Línea 5: Título del libro
  final String autor;                          // Línea 6: Nombre del autor
  final String area;                           // Línea 7: Área temática ("Literatura", "Infantil", "Ciencias")
  final String imagen;                         // Línea 8: Ruta de la imagen (URL o ruta local de asset)
  final List<Ejemplar> ejemplares;             // Línea 9: Lista de ejemplares físicos de este libro

  Libro({                                      // Línea 11: Constructor con todos los campos obligatorios
    required this.id,
    required this.titulo,
    required this.autor,
    required this.area,
    required this.imagen,
    required this.ejemplares,
  });

  int get totalEjemplares => ejemplares.length;                        // Línea 20: Getter que devuelve el total de ejemplares
  int get disponibles => ejemplares.where((e) => e.disponible).length; // Línea 21: Getter que cuenta solo los disponibles
  // .where() filtra la lista, .length cuenta los resultados
}
```

**¿Qué hace este archivo?**
Define la estructura de un libro con sus datos y su lista de ejemplares. Los getters `totalEjemplares` y `disponibles` calculan automáticamente cuántos ejemplares hay y cuántos están disponibles.

---

## 4. models/solicitud.dart

```dart
import 'libro.dart';                           // Línea 1: Importa el modelo Libro
import 'ejemplar.dart';                        // Línea 2: Importa el modelo Ejemplar

class Solicitud {                              // Línea 4: Representa una solicitud de préstamo hecha por un usuario
  final String id;                             // Línea 5: Identificador único de la solicitud
  final String nombreUsuario;                  // Línea 6: Nombre del usuario que solicita
  final Libro libro;                           // Línea 7: Referencia al libro solicitado
  final Ejemplar ejemplar;                     // Línea 8: Referencia al ejemplar específico solicitado
  String estado;                               // Línea 9: Estado actual: "pendiente", "aprobada" o "rechazada"
                                               //          Es mutable porque el bibliotecario lo cambia

  Solicitud({                                  // Línea 11: Constructor
    required this.id,
    required this.nombreUsuario,
    required this.libro,
    required this.ejemplar,
    this.estado = 'pendiente',                 // Línea 16: Por defecto toda solicitud nueva es "pendiente"
  });
}
```

**¿Qué hace este archivo?**
Define la estructura de una solicitud de préstamo. Cuando un usuario toca "Solicitar" en un ejemplar, se crea una Solicitud con estado "pendiente" que aparece en la bandeja del bibliotecario.

---

## 5. models/prestamo.dart

```dart
import 'libro.dart';                           // Línea 1: Importa el modelo Libro
import 'ejemplar.dart';                        // Línea 2: Importa el modelo Ejemplar

class Prestamo {                               // Línea 4: Representa un préstamo activo o finalizado
  final String id;                             // Línea 5: Identificador único del préstamo
  final String nombreUsuario;                  // Línea 6: Usuario que tiene el préstamo
  final Libro libro;                           // Línea 7: Libro prestado
  final Ejemplar ejemplar;                     // Línea 8: Ejemplar específico prestado
  final DateTime fechaPrestamo;                // Línea 9: Fecha en que se creó el préstamo
  bool activo;                                 // Línea 10: true = activo, false = devuelto
  String? condicionDevolucion;                 // Línea 11: Condición al devolver ("Bueno"/"Regular"/"Malo")
                                               //           String? = puede ser null (antes de devolver)
  String? observaciones;                       // Línea 12: Notas del bibliotecario al recibir la devolución

  Prestamo({                                   // Línea 14: Constructor
    required this.id,
    required this.nombreUsuario,
    required this.libro,
    required this.ejemplar,
    required this.fechaPrestamo,
    this.activo = true,                        // Línea 20: Por defecto un préstamo nuevo está activo
    this.condicionDevolucion,                  // Línea 21: null hasta que se devuelve
    this.observaciones,                        // Línea 22: null hasta que se devuelve
  });
}
```

**¿Qué hace este archivo?**
Define la estructura de un préstamo. Se crea cuando el bibliotecario aprueba una solicitud. Al registrar devolución, se marcan la condición y observaciones.

---

## 6. data/datos_simulados.dart

```dart
import '../models/libro.dart';                 // Línea 1: Importa modelos necesarios
import '../models/ejemplar.dart';              // Línea 2
import '../models/solicitud.dart';             // Línea 3
import '../models/prestamo.dart';              // Línea 4

// Línea 6: Lista global de libros con datos de prueba
final List<Libro> librosSimulados = [
  Libro(
    id: '1',
    titulo: 'Cien Años de Soledad',
    autor: 'Gabriel García Márquez',
    area: 'Literatura',                        // Área temática para filtros
    imagen: 'https://...',                     // Imagen cargada desde internet
    ejemplares: [
      Ejemplar(id: 'E1-1', condicion: 'Bueno', disponible: true),   // Ejemplar disponible
      Ejemplar(id: 'E1-2', condicion: 'Regular', disponible: false), // Ejemplar prestado
      Ejemplar(id: 'E1-3', condicion: 'Bueno', disponible: true),   // Ejemplar disponible
    ],
  ),
  // ... más libros con áreas: "Literatura", "Infantil", "Ciencias"
  Libro(
    id: '3',
    titulo: 'Siete Habitaciones a Oscuras',
    imagen: 'assets/image/Siete habitaciones...', // Imagen cargada desde assets locales
    // ...
  ),
];

// Línea 63: Lista global de solicitudes (empieza vacía, se llena al solicitar)
final List<Solicitud> solicitudesSimuladas = [];

// Línea 64: Lista global de préstamos (empieza vacía, se llena al aprobar)
final List<Prestamo> prestamosSimulados = [];
```

**¿Qué hace este archivo?**
Contiene los datos de prueba que simulan una base de datos. Hay 5 libros precargados con distintas áreas y ejemplares. Las listas de solicitudes y préstamos empiezan vacías y se llenan cuando el usuario interactúa con la app.

---

## 7. screens/dashboard_screen.dart

```dart
import 'package:flutter/material.dart';         // Línea 1: Importa Material Design
import '../widgets/sidebar_left.dart';          // Línea 2: Importa todos los widgets que componen la pantalla
import '../widgets/header.dart';
import '../widgets/content_section.dart';
import '../widgets/item_grip.dart';
import '../widgets/sidebar_right.dart';

class DashboardScreen extends StatefulWidget {  // Línea 8: StatefulWidget porque maneja estado (filtro y búsqueda)
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();  // Línea 12: Crea el estado asociado
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _filtroActivo = 'Todos';              // Línea 16: Estado del filtro seleccionado (Todos/Disponibles/Prestados/Reservados)
  String _busqueda = '';                       // Línea 17: Estado del texto de búsqueda

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF18181B),
      body: Row(                               // Línea 23: Layout horizontal de 3 columnas
        children: [
          const SidebarLeft(),                  // Línea 25: Columna 1 - menú lateral

          Expanded(                             // Línea 26: Columna 2 - contenido central (ocupa espacio restante)
            child: Column(
              children: [
                Header(
                  onBusqueda: (valor) {         // Línea 30: Callback que recibe el texto de búsqueda del Header
                    setState(() {              // Línea 31: setState() redibuja la pantalla con los nuevos datos
                      _busqueda = valor;        // Línea 32: Actualiza el texto de búsqueda
                    });
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ContentSection(
                          filtroActivo: _filtroActivo,       // Línea 41: Pasa el filtro actual a ContentSection
                          onFiltroChanged: (filtro) {       // Línea 42: Callback cuando se toca un filtro
                            setState(() {
                              _filtroActivo = filtro;       // Línea 44: Actualiza el filtro activo
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: ItemsGrid(
                            filtro: _filtroActivo,          // Línea 51: Pasa filtro al grid
                            busqueda: _busqueda,            // Línea 52: Pasa búsqueda al grid
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Línea 62-64: Sidebar derecho solo si la pantalla es mayor a 1200px
          MediaQuery.of(context).size.width > 1200
              ? const SidebarRight()
              : Container(),
        ],
      ),
    );
  }
}
```

**¿Qué hace este archivo?**
Es la pantalla principal. Ahora es StatefulWidget para manejar el estado del filtro y la búsqueda. Cuando el usuario escribe en el Header o toca un filtro, se llama `setState()` que redibuja el ItemsGrid con los resultados filtrados.

---

## 8. widgets/header.dart

```dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Header extends StatelessWidget {
  final Function(String) onBusqueda;           // Línea 5: Callback que se ejecuta cada vez que el usuario escribe
                                               //          Recibe el texto escrito como parámetro String

  const Header({super.key, required this.onBusqueda});  // Línea 7: onBusqueda es obligatorio

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF18181B),
      child: Row(                              // Línea 14: 3 secciones en fila
        children: [

          // ===== SECCIÓN 1: LOGO (flex: 1) =====
          Expanded(
            flex: 1,                           // Línea 17: Ocupa 1/4 del espacio
            child: Row(
              children: [
                Container(                     // Línea 20-40: Círculo con degradado fucsia-violeta y letra "B"
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC026D3), Color(0xFF7C3AED)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(child: Text('B', ...)),
                ),
                const Text('BIBLIOTECA', ...),  // Línea 43: Texto del logo
              ],
            ),
          ),

          // ===== SECCIÓN 2: BÚSQUEDA (flex: 2) =====
          Expanded(
            flex: 2,                           // Línea 55: Ocupa 2/4 del espacio (el doble que el logo)
            child: Container(
              child: TextField(
                onChanged: onBusqueda,         // Línea 59: CLAVE - cada tecla que se presiona ejecuta onBusqueda
                                               //          Esto envía el texto al DashboardScreen que filtra el grid
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar por título, autor o área...',  // Línea 62: Placeholder actualizado
                  prefixIcon: const Icon(Iconsax.search_normal, ...), // Línea 70: Ícono de lupa
                ),
              ),
            ),
          ),

          // ===== SECCIÓN 3: NOTIFICACIÓN + PERFIL (flex: 1) =====
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(                         // Stack superpone el punto rojo sobre la campana
                  children: [
                    IconButton(icon: const Icon(Iconsax.notification, ...)),  // Campana
                    Positioned(                // Punto rojo de notificación
                      right: 8, top: 8,
                      child: Container(width: 12, height: 12, ...),
                    ),
                  ],
                ),
                const CircleAvatar(radius: 20, backgroundImage: NetworkImage(...)),  // Foto perfil
                IconButton(icon: const Icon(Iconsax.arrow_down, ...)),  // Flecha desplegable
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

**¿Qué hace este archivo?**
Barra superior con logo, búsqueda funcional y perfil. La búsqueda ahora usa `onChanged` que envía cada tecla al `DashboardScreen`, que a su vez filtra el `ItemsGrid` en tiempo real por título, autor o área.

---

## 9. widgets/content_section.dart

```dart
import 'package:flutter/material.dart';

class ContentSection extends StatelessWidget {
  final String filtroActivo;                   // Línea 4: Qué filtro está seleccionado actualmente
  final Function(String) onFiltroChanged;      // Línea 5: Callback cuando se toca un filtro

  const ContentSection({
    super.key,
    required this.filtroActivo,                // Línea 9: Obligatorio recibir el filtro activo
    required this.onFiltroChanged,             // Línea 10: Obligatorio recibir la función callback
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard', ...),         // Línea 20: Título
          const Text('Gestiona y busca libros...', ...),  // Línea 29: Subtítulo

          // ===== BANNER PROMOCIONAL =====
          Container(                           // Línea 35-81: Banner con imagen de fondo + botón "Explorar Ahora"
            width: double.infinity,
            height: 176,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage('https://...'), fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                const Text('Encuentra la mejor colección\nde libros aquí', ...),
                ElevatedButton(child: const Text('Explorar Ahora'), ...),
              ],
            ),
          ),

          // ===== BARRA DE FILTROS =====
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Libros Populares', ...),   // Línea 87: Título de sección
                Row(
                  children: [
                    _buildFilterButton('Todos'),        // Línea 97: Filtros funcionales
                    _buildFilterButton('Disponibles'),
                    _buildFilterButton('Prestados'),
                    _buildFilterButton('Reservados'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Línea 111: Construye cada botón de filtro
  Widget _buildFilterButton(String text) {
    final isActive = text == filtroActivo;      // Línea 112: Compara con el filtro activo actual
    return Container(
      margin: const EdgeInsets.only(left: 12),
      child: TextButton(
        onPressed: () => onFiltroChanged(text), // Línea 116: CLAVE - al tocar, llama onFiltroChanged
                                                //          Esto notifica al DashboardScreen para actualizar el grid
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? const Color(0xFFC026D3) : const Color(0xFF71717A),  // Fucsia si activo, gris si no
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
```

**¿Qué hace este archivo?**
Muestra el banner promocional y los filtros funcionales. Ahora recibe `filtroActivo` para saber cuál resaltar y `onFiltroChanged` para notificar al DashboardScreen cuando el usuario toca un filtro.

---

## 10. widgets/item_grip.dart

```dart
import 'package:flutter/material.dart';
import '../models/libro.dart';                 // Línea 2: Importa el modelo Libro
import '../data/datos_simulados.dart';         // Línea 3: Importa los datos de prueba
import '../views/libros/libro_detalle.dart';   // Línea 4: Importa la pantalla de detalle

class ItemsGrid extends StatelessWidget {
  final String filtro;                         // Línea 7: Filtro activo ("Todos", "Disponibles", etc.)
  final String busqueda;                       // Línea 8: Texto de búsqueda

  const ItemsGrid({super.key, this.filtro = 'Todos', this.busqueda = ''});  // Línea 10: Valores por defecto

  @override
  Widget build(BuildContext context) {
    // Líneas 14-28: FILTRADO DE LIBROS
    List<Libro> librosFiltrados = librosSimulados.where((libro) {
      // Líneas 15-22: Filtro por búsqueda (título, autor o área)
      if (busqueda.isNotEmpty) {
        final query = busqueda.toLowerCase();  // Convierte a minúsculas para comparar sin importar mayúsculas
        if (!libro.titulo.toLowerCase().contains(query) &&
            !libro.autor.toLowerCase().contains(query) &&
            !libro.area.toLowerCase().contains(query)) {
          return false;                        // No coincide con ningún campo → excluir
        }
      }

      // Líneas 24-27: Filtro por disponibilidad
      if (filtro == 'Disponibles') return libro.disponibles > 0;          // Al menos 1 disponible
      if (filtro == 'Prestados') return libro.disponibles == 0;            // Ninguno disponible
      if (filtro == 'Reservados') return libro.disponibles < libro.totalEjemplares;  // Algunos prestados
      return true;                             // "Todos" → incluir todos
    }).toList();

    return GridView.builder(                   // Línea 30: Grid de 2 columnas
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,                     // Línea 34: 2 tarjetas por fila
        childAspectRatio: 0.75,                // Línea 35: Proporción de la tarjeta
      ),
      itemCount: librosFiltrados.length,        // Línea 39: Usa la lista filtrada
      itemBuilder: (context, index) {
        return _buildBookCard(context, librosFiltrados[index]);
      },
    );
  }

  Widget _buildBookCard(BuildContext context, Libro libro) {  // Línea 46: Recibe un Libro en vez de Map
    return Card(
      color: const Color(0xFF27272A),
      child: Column(
        children: [
          // ===== IMAGEN CON OVERLAY DE ÁREA Y DISPONIBILIDAD =====
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  // Líneas 62-64: Detecta si es URL o imagen local
                  image: libro.imagen.startsWith('http')
                      ? NetworkImage(libro.imagen)
                      : AssetImage(libro.imagen) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 8, left: 8, right: 8,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.6),  // Línea 77: Fondo negro semi-transparente
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(libro.area, ...),                   // Línea 84: Muestra el área del libro
                          Container(
                            child: Text(
                              '${libro.disponibles}/${libro.totalEjemplares}',  // Línea 100: Ej: "2/3"
                              style: TextStyle(
                                color: libro.disponibles > 0 ? Colors.green[300] : Colors.red[300],
                                // Verde si hay disponibles, rojo si no
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== INFO DEL LIBRO + BOTÓN =====
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(libro.titulo, ...),                         // Línea 122: Título del libro
                Text(libro.autor, ...),                          // Línea 133: Autor del libro
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Líneas 146-151: NAVEGACIÓN al detalle del libro
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LibroDetallePage(libro: libro),
                          // Pasa el objeto Libro completo a la pantalla de detalle
                        ),
                      );
                    },
                    child: const Text('Ver Detalles'),           // Línea 160: Botón "Ver Detalles"
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

**¿Qué hace este archivo?**
Genera la cuadrícula de libros. Ahora usa el modelo `Libro` en vez de Maps, filtra por búsqueda y categoría, muestra el área y la disponibilidad (ej: "2/3"), y navega a la pantalla de detalle al tocar "Ver Detalles".

---

## 11. widgets/sidebar_left.dart

```dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../views/gestor/bandeja_solicitudes_page.dart';  // Línea 3: Importa la bandeja de solicitudes
import '../views/prestamos/mis_prestamos.dart';          // Línea 4: Importa la vista de préstamos

class SidebarLeft extends StatelessWidget {
  const SidebarLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 192,
      color: const Color(0xFF18181B),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 96),
            child: Column(
              children: [
                // Líneas 21-27: Items de navegación (ahora reciben context para navegar)
                _buildNavItem(context, Iconsax.shop, 'Biblioteca', 0, true),
                _buildNavItem(context, Iconsax.home, 'Inicio', 1),
                _buildNavItem(context, Iconsax.heart, 'Favoritos', 2),
                _buildNavItem(context, Iconsax.trend_up, 'Prestamos', 3),
                _buildNavItem(context, Iconsax.book, 'Coleccion', 4),
                _buildNavItem(context, Iconsax.document, 'Solicitudes', 5),  // Línea 26: NUEVO - opción Solicitudes
                _buildNavItem(context, Iconsax.setting, 'Configuracion', 6),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildNavItem(context, Iconsax.logout, 'Cerrar Sesion', 7),
          ),
        ],
      ),
    );
  }

  // Línea 40: Ahora recibe BuildContext para poder navegar
  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index, [bool isSelected = false]) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFC026D3) : const Color(0xFF27272A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(label, style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFFA1A1AA),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        )),
        onTap: () {
          // Líneas 67-77: NAVEGACIÓN FUNCIONAL
          if (label == 'Solicitudes') {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BandejaSolicitudesPage()),
            );
          } else if (label == 'Prestamos') {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MisPrestamosPage()),
            );
          }
        },
      ),
    );
  }
}
```

**¿Qué hace este archivo?**
Menú lateral con navegación funcional. Ahora al tocar "Solicitudes" navega a la bandeja del bibliotecario, y al tocar "Prestamos" navega a la vista de préstamos activos. Se agregó la opción "Solicitudes" con ícono de documento.

---

## 12. widgets/sidebar_right.dart

```dart
import 'package:flutter/material.dart';

class SidebarRight extends StatelessWidget {    // Línea 4: Panel lateral derecho (solo visible en pantallas >1200px)
  const SidebarRight({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 288,                               // Línea 10: Ancho fijo
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF18181B),
      child: Column(
        children: [
          const Text('Usuarios Activos', ...),   // Línea 16: Título

          // ===== LISTA DE USUARIOS =====
          Expanded(
            child: ListView.builder(             // Línea 28: Lista scrollable
              itemCount: 5,                      // Línea 30: 5 tarjetas
              itemBuilder: (context, index) {
                return _buildUserCard(index);
              },
            ),
          ),

          // ===== TARJETA PROMOCIONAL =====
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(     // Degradado fucsia-violeta
                colors: [Color(0xFFC026D3), Color(0xFF7C3AED)],
              ),
            ),
            child: Column(
              children: [
                Text('Renueva tu préstamo online', ...),
                Text('Puedes renovar tus préstamos...', ...),
                ElevatedButton(                  // Botón "Renovar Ahora" (deshabilitado con onPressed: null)
                  onPressed: null,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  child: Text('Renovar Ahora'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Línea 91: Construye cada tarjeta de usuario
  Widget _buildUserCard(int index) {
    final usuarios = [                           // Línea 92-96: 3 usuarios que se repiten cíclicamente
      {'nombre': 'Ana Pérez', 'email': '@ana', 'avatar': '...'},
      {'nombre': 'Carlos Gómez', 'email': '@carlos', 'avatar': '...'},
      {'nombre': 'María López', 'email': '@maria', 'avatar': '...'},
    ];

    final usuario = usuarios[index % usuarios.length];  // Línea 98: % = operador módulo, repite la lista

    return Container(                           // Tarjeta con avatar circular + nombre + email
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundImage: NetworkImage(usuario['avatar']!)),
          Column(
            children: [
              Text(usuario['nombre']!, ...),     // Nombre en blanco
              Text(usuario['email']!, ...),      // Email en gris
            ],
          ),
        ],
      ),
    );
  }
}
```

**¿Qué hace este archivo?**
Panel lateral derecho con usuarios activos y tarjeta promocional. Solo se muestra en pantallas mayores a 1200px.

---

## 13. views/libros/libro_detalle.dart

```dart
import 'package:flutter/material.dart';
import '../../models/libro.dart';               // Línea 2: Modelo del libro
import '../../models/ejemplar.dart';            // Línea 3: Modelo del ejemplar
import '../../models/solicitud.dart';           // Línea 4: Modelo de solicitud
import '../../data/datos_simulados.dart';       // Línea 5: Datos simulados (para agregar solicitudes)

class LibroDetallePage extends StatefulWidget { // Línea 7: StatefulWidget porque cambia al solicitar
  final Libro libro;                            // Línea 8: Recibe el libro del que mostrar detalle

  const LibroDetallePage({super.key, required this.libro});  // Línea 10: libro es obligatorio

  @override
  State<LibroDetallePage> createState() => _LibroDetallePageState();
}

class _LibroDetallePageState extends State<LibroDetallePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF18181B),
      appBar: AppBar(                           // Línea 21: Barra superior con título y botón de volver
        title: Text(widget.libro.titulo),       // Línea 23: widget.libro accede al libro del StatefulWidget
        foregroundColor: Colors.white,           // Línea 24: Texto e ícono de volver en blanco
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== SECCIÓN SUPERIOR: IMAGEN + INFO =====
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(                      // Línea 34: Recorta la imagen con bordes redondeados
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 200, height: 280,    // Línea 37-38: Tamaño fijo de la imagen
                    child: widget.libro.imagen.startsWith('http')
                        ? Image.network(widget.libro.imagen, fit: BoxFit.cover)
                        : Image.asset(widget.libro.imagen, fit: BoxFit.cover),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(widget.libro.titulo, ...),    // Título grande
                      Text('Autor: ${widget.libro.autor}', ...),   // Autor
                      Text('Área: ${widget.libro.area}', ...),     // Área
                      Container(                         // Línea 68-83: Badge de disponibilidad
                        decoration: BoxDecoration(
                          color: widget.libro.disponibles > 0
                              ? Colors.green.withValues(alpha: 0.2)   // Fondo verde semi-transparente
                              : Colors.red.withValues(alpha: 0.2),    // Fondo rojo semi-transparente
                        ),
                        child: Text('${widget.libro.disponibles} de ${widget.libro.totalEjemplares} disponibles'),
                        // Ejemplo: "2 de 3 disponibles"
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ===== LISTA DE EJEMPLARES =====
            const Text('Ejemplares', ...),       // Línea 90: Título de sección
            ListView.builder(                    // Línea 99: Lista de ejemplares
              shrinkWrap: true,
              itemCount: widget.libro.ejemplares.length,  // Línea 102: Cantidad de ejemplares del libro
              itemBuilder: (context, index) {
                final ejemplar = widget.libro.ejemplares[index];
                return Container(                // Tarjeta de cada ejemplar
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.book,        // Ícono verde si disponible, rojo si no
                            color: ejemplar.disponible ? Colors.green[300] : Colors.red[300]),
                          Column(
                            children: [
                              Text('Ejemplar ${ejemplar.id}'),      // ID del ejemplar
                              Text('Condición: ${ejemplar.condicion}'),  // Condición física
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(              // Badge "Disponible" o "Prestado"
                            child: Text(ejemplar.disponible ? 'Disponible' : 'Prestado'),
                          ),
                          // Línea 160: Botón "Solicitar" SOLO si está disponible
                          if (ejemplar.disponible)
                            ElevatedButton(
                              onPressed: () => _solicitarEjemplar(ejemplar),
                              child: const Text('Solicitar'),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Línea 184: Método que crea una solicitud
  void _solicitarEjemplar(Ejemplar ejemplar) {
    final solicitud = Solicitud(
      id: 'S${DateTime.now().millisecondsSinceEpoch}',  // Línea 186: ID único basado en timestamp
      nombreUsuario: 'Usuario Actual',                   // Línea 187: Usuario fijo (sin login aún)
      libro: widget.libro,                               // Línea 188: El libro actual
      ejemplar: ejemplar,                                // Línea 189: El ejemplar seleccionado
    );
    solicitudesSimuladas.add(solicitud);                  // Línea 191: Agrega a la lista global de solicitudes

    ScaffoldMessenger.of(context).showSnackBar(           // Línea 193: Muestra mensaje de confirmación
      SnackBar(
        content: Text('Solicitud enviada para "${widget.libro.titulo}" - Ejemplar ${ejemplar.id}'),
        backgroundColor: const Color(0xFFC026D3),
      ),
    );
    setState(() {});                                      // Línea 199: Redibuja la pantalla
  }
}
```

**¿Qué hace este archivo?**
Muestra el detalle de un libro con su imagen, autor, área y disponibilidad. Lista todos los ejemplares con su condición y estado. Si un ejemplar está disponible, muestra el botón "Solicitar" que crea una nueva solicitud en la lista simulada.

---

## 14. views/gestor/bandeja_solicitudes_page.dart

```dart
import 'package:flutter/material.dart';
import '../../models/solicitud.dart';
import '../../models/prestamo.dart';
import '../../data/datos_simulados.dart';

class BandejaSolicitudesPage extends StatefulWidget {  // Línea 6: StatefulWidget porque la lista cambia
  const BandejaSolicitudesPage({super.key});

  @override
  State<BandejaSolicitudesPage> createState() => _BandejaSolicitudesPageState();
}

class _BandejaSolicitudesPageState extends State<BandejaSolicitudesPage> {
  @override
  Widget build(BuildContext context) {
    // Línea 16-18: Filtra solo las solicitudes con estado "pendiente"
    final pendientes = solicitudesSimuladas
        .where((s) => s.estado == 'pendiente')
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Bandeja de Solicitudes')),
      body: pendientes.isEmpty
          ? const Center(child: Text('No hay solicitudes pendientes'))  // Línea 29: Mensaje si no hay
          : ListView.builder(                  // Línea 34: Lista de solicitudes pendientes
              itemCount: pendientes.length,
              itemBuilder: (context, index) {
                return _buildSolicitudCard(pendientes[index]);
              },
            ),
    );
  }

  // Línea 45: Construye cada tarjeta de solicitud
  Widget _buildSolicitudCard(Solicitud solicitud) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(solicitud.nombreUsuario, ...),                        // Nombre del usuario
                Text('Libro: ${solicitud.libro.titulo}', ...),            // Título del libro
                Text('Ejemplar: ${solicitud.ejemplar.id} (${solicitud.ejemplar.condicion})', ...),
                // Muestra: "Ejemplar: E1-1 (Bueno)"
              ],
            ),
          ),
          Row(
            children: [
              ElevatedButton(                    // Línea 82: Botón APROBAR (verde)
                onPressed: () => _aprobar(solicitud),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                child: const Text('Aprobar'),
              ),
              ElevatedButton(                    // Línea 93: Botón RECHAZAR (rojo)
                onPressed: () => _rechazar(solicitud),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
                child: const Text('Rechazar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Línea 110: Aprueba una solicitud
  void _aprobar(Solicitud solicitud) {
    setState(() {
      solicitud.estado = 'aprobada';              // Línea 112: Cambia estado a "aprobada"
      solicitud.ejemplar.disponible = false;       // Línea 113: Marca el ejemplar como NO disponible

      // Líneas 115-121: Crea un nuevo préstamo
      prestamosSimulados.add(Prestamo(
        id: 'P${DateTime.now().millisecondsSinceEpoch}',
        nombreUsuario: solicitud.nombreUsuario,
        libro: solicitud.libro,
        ejemplar: solicitud.ejemplar,
        fechaPrestamo: DateTime.now(),
      ));
    });
    // Muestra mensaje de confirmación verde
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Préstamo aprobado: "${solicitud.libro.titulo}" para ${solicitud.nombreUsuario}'),
    ));
  }

  // Línea 132: Rechaza una solicitud
  void _rechazar(Solicitud solicitud) {
    setState(() {
      solicitud.estado = 'rechazada';             // Línea 134: Cambia estado a "rechazada"
    });
    // Muestra mensaje de confirmación rojo
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Solicitud rechazada: "${solicitud.libro.titulo}"'),
    ));
  }
}
```

**¿Qué hace este archivo?**
Panel del bibliotecario. Muestra las solicitudes pendientes con nombre de usuario, libro y ejemplar. El bibliotecario puede Aprobar (crea un préstamo y marca el ejemplar como no disponible) o Rechazar (cambia el estado de la solicitud).

---

## 15. views/prestamos/mis_prestamos.dart

```dart
import 'package:flutter/material.dart';
import '../../models/prestamo.dart';
import '../../data/datos_simulados.dart';

class MisPrestamosPage extends StatefulWidget {
  const MisPrestamosPage({super.key});

  @override
  State<MisPrestamosPage> createState() => _MisPrestamosPageState();
}

class _MisPrestamosPageState extends State<MisPrestamosPage> {
  @override
  Widget build(BuildContext context) {
    final activos = prestamosSimulados.where((p) => p.activo).toList();  // Línea 15: Solo préstamos activos

    return Scaffold(
      appBar: AppBar(title: const Text('Préstamos Activos')),
      body: activos.isEmpty
          ? const Center(child: Text('No hay préstamos activos'))
          : ListView.builder(
              itemCount: activos.length,
              itemBuilder: (context, index) {
                return _buildPrestamoCard(activos[index]);
              },
            ),
    );
  }

  // Línea 42: Tarjeta de préstamo activo
  Widget _buildPrestamoCard(Prestamo prestamo) {
    final diasPrestamo = DateTime.now().difference(prestamo.fechaPrestamo).inDays;
    // Línea 43: Calcula cuántos días lleva prestado

    return Container(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(prestamo.libro.titulo, ...),          // Título del libro
                Text('Usuario: ${prestamo.nombreUsuario}'),  // Quién lo tiene
                Text('Ejemplar: ${prestamo.ejemplar.id}'),   // Qué ejemplar
                Text('Días prestado: $diasPrestamo',         // Línea 76: Días prestado
                  style: TextStyle(
                    color: diasPrestamo > 7 ? Colors.red[300] : Colors.green[300],
                    // Rojo si lleva más de 7 días, verde si no
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(                                    // Línea 84: Botón "Registrar Devolución"
            onPressed: () => _mostrarDialogoDevolucion(prestamo),
            child: const Text('Registrar Devolución'),
          ),
        ],
      ),
    );
  }

  // Línea 99: Muestra un diálogo para registrar la devolución
  void _mostrarDialogoDevolucion(Prestamo prestamo) {
    String condicion = 'Bueno';                              // Línea 100: Valor por defecto del dropdown
    final observacionesController = TextEditingController();  // Línea 101: Controlador del campo de texto

    showDialog(                                              // Línea 103: Abre un diálogo modal
      context: context,
      builder: (context) {
        return StatefulBuilder(                               // Línea 106: StatefulBuilder permite setState dentro del diálogo
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Registrar Devolución'),
              content: Column(
                mainAxisSize: MainAxisSize.min,               // Línea 115: El diálogo se ajusta al contenido
                children: [
                  Text('Libro: ${prestamo.libro.titulo}'),
                  Text('Ejemplar: ${prestamo.ejemplar.id}'),

                  // Línea 132: Dropdown para seleccionar condición
                  DropdownButton<String>(
                    value: condicion,
                    items: ['Bueno', 'Regular', 'Malo'].map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {                    // Línea 140: Usa setDialogState (no setState)
                        condicion = value!;                  //          para actualizar SOLO el diálogo
                      });
                    },
                  ),

                  // Línea 151: Campo de texto para observaciones
                  TextField(
                    controller: observacionesController,
                    maxLines: 3,                              // 3 líneas de alto
                    decoration: InputDecoration(
                      hintText: 'Escriba observaciones...',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(                                  // Botón "Cancelar" - cierra el diálogo
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(                              // Botón "Confirmar" - registra la devolución
                  onPressed: () {
                    _registrarDevolucion(prestamo, condicion, observacionesController.text);
                    Navigator.pop(context);                   // Cierra el diálogo
                  },
                  child: const Text('Confirmar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Línea 191: Registra la devolución del préstamo
  void _registrarDevolucion(Prestamo prestamo, String condicion, String observaciones) {
    setState(() {
      prestamo.activo = false;                               // Línea 193: Marca préstamo como inactivo
      prestamo.condicionDevolucion = condicion;               // Línea 194: Guarda la condición de devolución
      prestamo.observaciones = observaciones;                 // Línea 195: Guarda las observaciones
      prestamo.ejemplar.disponible = true;                    // Línea 196: Marca el ejemplar como disponible otra vez
      prestamo.ejemplar.condicion = condicion;                // Línea 197: Actualiza la condición del ejemplar
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Devolución registrada: "${prestamo.libro.titulo}"'),
    ));
  }
}
```

**¿Qué hace este archivo?**
Muestra los préstamos activos con días prestados (rojo si >7 días). El botón "Registrar Devolución" abre un diálogo donde el bibliotecario selecciona la condición del libro devuelto y escribe observaciones. Al confirmar, el préstamo se marca como inactivo y el ejemplar vuelve a estar disponible.

---

## Colores más usados

| Color | Código | Uso |
|-------|--------|-----|
| Zinc 900 | `0xFF18181B` | Fondo principal |
| Zinc 800 | `0xFF27272A` | Fondo de tarjetas e inputs |
| Zinc 500 | `0xFF71717A` | Texto secundario / placeholder |
| Zinc 400 | `0xFFA1A1AA` | Texto inactivo |
| Fuchsia 600 | `0xFFC026D3` | Color de acento principal |
| Violet 600 | `0xFF7C3AED` | Degradados con fuchsia |
| Green 700 | `Colors.green[700]` | Botón aprobar |
| Red 700 | `Colors.red[700]` | Botón rechazar |
| Green 300 | `Colors.green[300]` | Texto disponible |
| Red 300 | `Colors.red[300]` | Texto no disponible |

## Conceptos clave de Flutter usados

| Widget/Concepto | Descripción |
|-----------------|-------------|
| `StatelessWidget` | Widget que no cambia de estado (estático) |
| `StatefulWidget` | Widget que tiene estado mutable y se puede redibujar con `setState()` |
| `setState()` | Método que notifica a Flutter que debe redibujar el widget |
| `Row` | Organiza hijos en fila horizontal |
| `Column` | Organiza hijos en columna vertical |
| `Expanded` | Hace que un hijo ocupe el espacio restante |
| `Container` | Caja con padding, margin, color, decoración |
| `Stack` / `Positioned` | Superponer widgets uno encima de otro |
| `ListView.builder` | Lista con scroll que construye items bajo demanda |
| `GridView.builder` | Cuadrícula que construye items bajo demanda |
| `Navigator.push` | Navega a una nueva pantalla (la pone encima de la actual) |
| `MaterialPageRoute` | Define la ruta de navegación a otra pantalla |
| `showDialog` | Muestra un diálogo modal (popup) |
| `AlertDialog` | Widget de diálogo con título, contenido y acciones |
| `StatefulBuilder` | Permite usar setState dentro de un widget que no es StatefulWidget |
| `DropdownButton` | Menú desplegable para seleccionar una opción |
| `ScaffoldMessenger.showSnackBar` | Muestra un mensaje temporal en la parte inferior |
| `const` | Indica que el widget no cambia, mejora rendimiento |
| `EdgeInsets` | Define márgenes/padding (top, bottom, left, right) |
| `BoxDecoration` | Estilo de un Container (color, borde, degradado, imagen) |
| `NetworkImage` | Carga imagen desde una URL de internet |
| `AssetImage` | Carga imagen desde los archivos locales del proyecto |
| `ClipRRect` | Recorta un widget con bordes redondeados |
| `TextEditingController` | Controla y lee el contenido de un TextField |
| `Function(String)` | Tipo de una función callback que recibe un String |
| `.where()` | Filtra una lista según una condición |
| `%` (módulo) | Devuelve el residuo de una división (para repetir listas cíclicamente) |
| `String?` | Tipo nullable - puede ser String o null |
| `final` | Variable que no se puede reasignar después de inicializar |
| `required` | Parámetro obligatorio en el constructor |
