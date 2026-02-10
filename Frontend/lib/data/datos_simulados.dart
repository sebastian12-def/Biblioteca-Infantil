import '../models/libro.dart';
import '../models/ejemplar.dart';
import '../models/solicitud.dart';
import '../models/prestamo.dart';

final List<Libro> librosSimulados = [
  Libro(
    id: '1',
    titulo: 'Cien Años de Soledad',
    autor: 'Gabriel García Márquez',
    area: 'Literatura',
    imagen: 'https://assets.codepen.io/3685267/nft-dashboard-art-0.jpg',
    ejemplares: [
      Ejemplar(id: 'E1-1', condicion: 'Bueno', disponible: true),
      Ejemplar(id: 'E1-2', condicion: 'Regular', disponible: false),
      Ejemplar(id: 'E1-3', condicion: 'Bueno', disponible: true),
    ],
  ),
  Libro(
    id: '2',
    titulo: 'Don Quijote de la Mancha',
    autor: 'Miguel de Cervantes',
    area: 'Literatura',
    imagen: 'https://assets.codepen.io/3685267/nft-dashboard-art-1.jpg',
    ejemplares: [
      Ejemplar(id: 'E2-1', condicion: 'Bueno', disponible: true),
      Ejemplar(id: 'E2-2', condicion: 'Malo', disponible: false),
    ],
  ),
  Libro(
    id: '3',
    titulo: 'Siete Habitaciones a Oscuras',
    autor: 'Gabriela Aguilleta',
    area: 'Infantil',
    imagen: 'assets/image/descarga.jpg',
    ejemplares: [
      Ejemplar(id: 'E3-1', condicion: 'Bueno', disponible: true),
    ],
  ),
  Libro(
    id: '4',
    titulo: 'El Principito',
    autor: 'Antoine de Saint-Exupéry',
    area: 'Infantil',
    imagen: 'assets/image/des.jpg',
    ejemplares: [
      Ejemplar(id: 'E4-1', condicion: 'Bueno', disponible: true),
      Ejemplar(id: 'E4-2', condicion: 'Regular', disponible: true),
    ],
  ),
  Libro(
    id: '5',
    titulo: 'Matemáticas para Todos',
    autor: 'Carlos Ruiz',
    area: 'Ciencias',
    imagen: 'https://assets.codepen.io/3685267/nft-dashboard-art-1.jpg',
    ejemplares: [
      Ejemplar(id: 'E5-1', condicion: 'Bueno', disponible: false),
    ],
  ),
];

final List<Solicitud> solicitudesSimuladas = [];
final List<Prestamo> prestamosSimulados = [];
