class Ejemplar {
  final String id;
  final String idLibro;
  final String codigoInventario;
  String condicion;
  bool disponible;

  Ejemplar({
    required this.id,
    this.idLibro = '',
    this.codigoInventario = '',
    required this.condicion,
    this.disponible = true,
  });

  /// Crea un Ejemplar desde el JSON del backend
  factory Ejemplar.fromJson(Map<String, dynamic> json) {
    return Ejemplar(
      id: json['id_ejemplar']?.toString() ?? '',
      idLibro: json['id_libro']?.toString() ?? '',
      codigoInventario: json['codigo_inventario'] ?? '',
      condicion: json['condicion'] ?? 'bueno',
      disponible: json['disponibilidad'] ?? true,
    );
  }
}

