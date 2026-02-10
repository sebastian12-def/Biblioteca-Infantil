import 'libro.dart';
import 'ejemplar.dart';

class Solicitud {
  final String id;
  final String nombreUsuario;
  final Libro libro;
  final Ejemplar ejemplar;
  String estado;

  Solicitud({
    required this.id,
    required this.nombreUsuario,
    required this.libro,
    required this.ejemplar,
    this.estado = 'pendiente',
  });
}
