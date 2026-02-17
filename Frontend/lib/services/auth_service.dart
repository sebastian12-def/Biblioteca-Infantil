import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para manejar login, registro y sesión del usuario
class AuthService {
  
  /// Inicia sesión con documento y contraseña
  /// Retorna true si fue exitoso, false si falló
  static Future<Map<String, dynamic>> login(String documento, String password) async {
    final response = await ApiService.post('/auth/login', {
      'documento': documento,
      'password': password,
    });

    if (response['success'] == true && response['token'] != null) {
      // Guardar el token
      await ApiService.saveToken(response['token']);
      
      // Guardar datos del usuario
      final prefs = await SharedPreferences.getInstance();
      final usuario = response['usuario'];
      if (usuario != null) {
        // El ID puede ser int o string (UUID)
        await prefs.setString('userId', usuario['id']?.toString() ?? '');
        await prefs.setString('userName', usuario['nombre'] ?? '');
        await prefs.setString('userApellido', usuario['apellido'] ?? '');
        await prefs.setString('userTipo', usuario['tipo_usuario'] ?? '');
        await prefs.setString('userDocumento', usuario['documento'] ?? '');
      }
    }

    return response;
  }

  /// Registra un nuevo usuario
  static Future<Map<String, dynamic>> register({
    required String documento,
    required String password,
    required String nombre,
    required String apellido,
    required String tipoUsuario,
  }) async {
    final response = await ApiService.post('/auth/register', {
      'documento': documento,
      'password': password,
      'nombre': nombre,
      'apellido': apellido,
      'tipo_usuario': tipoUsuario,
    });

    if (response['success'] == true && response['token'] != null) {
      await ApiService.saveToken(response['token']);
      
      final prefs = await SharedPreferences.getInstance();
      final usuario = response['usuario'];
      if (usuario != null) {
        // El ID puede ser int o string (UUID)
        await prefs.setString('userId', usuario['id']?.toString() ?? '');
        await prefs.setString('userName', usuario['nombre'] ?? '');
        await prefs.setString('userApellido', usuario['apellido'] ?? '');
        await prefs.setString('userTipo', usuario['tipo_usuario'] ?? '');
        await prefs.setString('userDocumento', usuario['documento'] ?? '');
      }
    }

    return response;
  }

  /// Cierra la sesión del usuario
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Verifica si hay una sesión activa
  static Future<bool> isLoggedIn() async {
    final token = await ApiService.getToken();
    return token != null && token.isNotEmpty;
  }

  /// Obtiene el nombre del usuario logueado
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final nombre = prefs.getString('userName') ?? '';
    final apellido = prefs.getString('userApellido') ?? '';
    return '$nombre $apellido'.trim();
  }

  /// Obtiene el tipo de usuario (alumno, gestor, etc.)
  static Future<String> getUserTipo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userTipo') ?? '';
  }

  /// Obtiene el ID del usuario
  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? '';
  }
}
