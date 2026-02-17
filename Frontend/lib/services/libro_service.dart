import 'api_service.dart';
import '../models/libro.dart';
import '../models/ejemplar.dart';

/// Servicio para obtener libros del backend
class LibroService {
  
  /// Obtiene todos los libros
  static Future<List<Libro>> getLibros() async {
    final response = await ApiService.get('/libros');
    
    if (response['success'] == true && response['data'] != null) {
      final List<dynamic> librosJson = response['data'];
      return librosJson.map((json) => Libro.fromJson(json)).toList();
    }
    
    return [];
  }

  /// Obtiene un libro por su ID con sus ejemplares
  static Future<Libro?> getLibroById(String id) async {
    final response = await ApiService.get('/libros/$id');
    
    if (response['success'] == true && response['data'] != null) {
      return Libro.fromJson(response['data']);
    }
    
    return null;
  }

  /// Obtiene los ejemplares de un libro
  static Future<List<Ejemplar>> getEjemplares(String idLibro) async {
    final response = await ApiService.get('/libros/$idLibro/ejemplares');
    
    if (response['success'] == true && response['ejemplares'] != null) {
      final List<dynamic> ejemplaresJson = response['ejemplares'];
      return ejemplaresJson.map((json) => Ejemplar.fromJson(json)).toList();
    }
    
    return [];
  }

  /// Busca libros por título o autor
  static Future<List<Libro>> buscarLibros(String termino) async {
    final response = await ApiService.get('/libros/buscar?q=$termino');
    
    if (response['success'] == true && response['data'] != null) {
      final List<dynamic> librosJson = response['data'];
      return librosJson.map((json) => Libro.fromJson(json)).toList();
    }
    
    return [];
  }
}
