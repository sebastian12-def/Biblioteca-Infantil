import 'ejemplar.dart';

class Libro {
  final String id;
  final String titulo;
  final String autor;
  final String area;
  final String imagen;
  final List<Ejemplar> ejemplares;

  Libro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.area,
    required this.imagen,
    required this.ejemplares,
  });

  int get totalEjemplares => ejemplares.length;
  int get disponibles => ejemplares.where((e) => e.disponible).length;
}
