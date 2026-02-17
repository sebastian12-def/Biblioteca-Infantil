import 'libro.dart';
import 'ejemplar.dart';

class Prestamo {
  final String id;
  final String nombreUsuario;
  final Libro? libro;
  final Ejemplar? ejemplar;
  final DateTime fechaPrestamo;
  final String estado;
  bool activo;
  String? condicionDevolucion;
  String? observaciones;

  Prestamo({
    required this.id,
    this.nombreUsuario = '',
    this.libro,
    this.ejemplar,
    required this.fechaPrestamo,
    this.estado = 'activo',
    this.activo = true,
    this.condicionDevolucion,
    this.observaciones,
  });

  /// Crea un Prestamo desde el JSON del backend
  factory Prestamo.fromJson(Map<String, dynamic> json) {
    // El backend devuelve los datos del libro anidados
    Libro? libroData;
    if (json['libros'] != null) {
      libroData = Libro(
        id: '',
        titulo: json['libros']['titulo'] ?? '',
        autor: json['libros']['autor'] ?? '',
        area: '',
        imagen: '',
      );
    }

    return Prestamo(
      id: json['id_prestamo']?.toString() ?? '',
      fechaPrestamo: DateTime.tryParse(json['fecha_prestamo'] ?? '') ?? DateTime.now(),
      estado: json['estado'] ?? 'activo',
      activo: json['estado'] == 'activo',
      libro: libroData,
      ejemplar: json['id_ejemplar'] != null 
        ? Ejemplar(id: json['id_ejemplar'].toString(), condicion: 'Bueno')
        : null,
    );
  }
}

