# Frontend - Biblioteca Infantil

Aplicacion Flutter para la biblioteca escolar.

## Requisitos

- Flutter SDK instalado
- Backend corriendo en `http://localhost:3000`

## Ejecutar

```bash
flutter pub get
flutter run -d chrome
```

## Flujo esperado

1. Registro de usuario.
2. Redireccion a Login.
3. Login exitoso.
4. Dashboard con libros.
5. Solicitud y devolucion de prestamos.

## Nota de conexion

El frontend usa `http://localhost:3000` en:
`lib/services/api_service.dart`

Si cambias puerto del backend, actualiza ese archivo.
