import 'ejemplar.dart';

class Libro {
  final String id;
  final String codigoLibro;
  final String titulo;
  final String autor;
  final String area;
  final String imagen;
  final int anioPublicacion;
  final int totalEjemplares;
  final int ejemplaresDisponibles;
  final int ejemplaresPrestados;
  final List<Ejemplar> ejemplares;

  Libro({
    required this.id,
    this.codigoLibro = '',
    required this.titulo,
    required this.autor,
    required this.area,
    required this.imagen,
    this.anioPublicacion = 0,
    this.totalEjemplares = 0,
    this.ejemplaresDisponibles = 0,
    this.ejemplaresPrestados = 0,
    this.ejemplares = const [],
  });

  /// Crea un Libro desde el JSON del backend
  factory Libro.fromJson(Map<String, dynamic> json) {
    List<Ejemplar> ejemplaresList = [];
    if (json['ejemplares'] != null) {
      ejemplaresList = (json['ejemplares'] as List)
          .map((e) => Ejemplar.fromJson(e))
          .toList();
    }

    return Libro(
      id: json['id_libro']?.toString() ?? '',
      codigoLibro: json['codigo_libro'] ?? '',
      titulo: json['titulo'] ?? '',
      autor: json['autor'] ?? '',
      area: json['area'] ?? 'General',
      imagen: json['imagen_url'] ?? 'https://via.placeholder.com/150x200?text=Sin+Imagen',
      anioPublicacion: json['anio_publicacion'] ?? 0,
      totalEjemplares: json['total_ejemplares'] ?? 0,
      ejemplaresDisponibles: json['ejemplares_disponibles'] ?? 0,
      ejemplaresPrestados: json['ejemplares_prestados'] ?? 0,
      ejemplares: ejemplaresList,
    );
  }

  int get disponibles => ejemplaresDisponibles > 0 ? ejemplaresDisponibles : ejemplares.where((e) => e.disponible).length;
  bool get hayDisponibles => disponibles > 0;
}

