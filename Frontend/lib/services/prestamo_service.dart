import 'api_service.dart';
import '../models/prestamo.dart';

/// Servicio para manejar préstamos del usuario
class PrestamoService {
  
  /// Obtiene los préstamos del usuario logueado
  static Future<List<Prestamo>> getMisPrestamos() async {
    final response = await ApiService.get('/api/prestamos/mis-prestamos', withAuth: true);
    
    if (response['success'] == true && response['data'] != null) {
      final List<dynamic> prestamosJson = response['data'];
      return prestamosJson.map((json) => Prestamo.fromJson(json)).toList();
    }
    
    return [];
  }

  /// Solicita un préstamo de un ejemplar específico
  static Future<Map<String, dynamic>> solicitarPrestamo(
    String idEjemplar, {
    String? idLibro,
  }) async {
    final body = <String, dynamic>{
      'id_ejemplar': idEjemplar,
    };
    
    if (idLibro != null) {
      body['id_libro'] = idLibro;
    }

    final response = await ApiService.post(
      '/api/prestamos/solicitar',
      body,
      withAuth: true,
    );
    
    return response;
  }

  /// Devuelve un préstamo (libera el ejemplar)
  static Future<Map<String, dynamic>> devolverPrestamo(String idPrestamo, String idEjemplar) async {
    final response = await ApiService.put(
      '/api/prestamos/devolver',
      {
        'id_prestamo': idPrestamo,
        'id_ejemplar': idEjemplar,
      },
      withAuth: true,
    );
    return response;
  }
}
