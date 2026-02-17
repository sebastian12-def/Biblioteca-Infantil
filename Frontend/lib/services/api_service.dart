import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio base para todas las llamadas HTTP al backend.
/// Maneja el token JWT automáticamente en cada request.
class ApiService {
    /// PUT request
    ///
    /// Realiza una petición HTTP PUT al backend.
    /// [endpoint]: Ruta relativa del recurso (ej: '/api/prestamos/devolver')
    /// [body]: Mapa con los datos a enviar en el cuerpo de la petición.
    /// [withAuth]: Si es true, incluye el token JWT en los headers.
    static Future<Map<String, dynamic>> put(
      String endpoint,
      Map<String, dynamic> body, {
      bool withAuth = false,
    }) async {
      try {
        final headers = await _getHeaders(withAuth: withAuth);
        final response = await http.put(
          Uri.parse('$baseUrl$endpoint'),
          headers: headers,
          body: jsonEncode(body),
        );
        return _handleResponse(response);
      } catch (e) {
        return {'success': false, 'error': 'Error de conexión: $e'};
      }
    }
  // URL del backend
  static const String baseUrl = 'http://localhost:3000'; // Para web/desktop
  // static const String baseUrl = 'http://10.0.2.2:3000'; // Para emulador Android
  
  /// Obtiene el token guardado en el dispositivo
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Guarda el token en el dispositivo
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  /// Elimina el token (logout)
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  /// Headers comunes para todas las peticiones
  static Future<Map<String, String>> _getHeaders({bool withAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (withAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }

  /// GET request
  static Future<Map<String, dynamic>> get(String endpoint, {bool withAuth = false}) async {
    try {
      final headers = await _getHeaders(withAuth: withAuth);
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión: $e'};
    }
  }

  /// POST request
  static Future<Map<String, dynamic>> post(
    String endpoint, 
    Map<String, dynamic> body, 
    {bool withAuth = false}
  ) async {
    try {
      final headers = await _getHeaders(withAuth: withAuth);
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión: $e'};
    }
  }

  /// Procesa la respuesta del servidor
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return {
        'success': false,
        'error': 'Error al procesar respuesta',
        'statusCode': response.statusCode,
      };
    }
  }
}
