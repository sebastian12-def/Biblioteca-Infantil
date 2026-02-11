import 'libro.dart';
import 'ejemplar.dart';

class Prestamo {
  final String id;
  final String nombreUsuario;
  final Libro libro;
  final Ejemplar ejemplar;
  final DateTime fechaPrestamo;
  bool activo;
  String? condicionDevolucion;
  String? observaciones;

  Prestamo({
    required this.id,
    required this.nombreUsuario,
    required this.libro,
    required this.ejemplar,
    required this.fechaPrestamo,
    this.activo = true,
    this.condicionDevolucion,
    this.observaciones,
  });
}
