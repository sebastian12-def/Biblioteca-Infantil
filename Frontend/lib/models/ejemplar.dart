class Ejemplar {
  final String id;
  String condicion;
  bool disponible;

  Ejemplar({
    required this.id,
    required this.condicion,
    this.disponible = true,
  });
}
