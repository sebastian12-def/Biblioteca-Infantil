# Biblioteca Infantil

Proyecto fullstack para una biblioteca escolar.

- Backend: Node.js + Express + Supabase
- Frontend: Flutter
- Auth: JWT
- Puerto backend: `3000`

## Que hace el sistema

1. Permite registrar usuarios estudiantes.
2. Permite iniciar sesion.
3. Permite ver libros y ejemplares.
4. Permite pedir prestamos.
5. Permite devolver prestamos (solo los tuyos).

## Arranque rapido (5 minutos)

1. Clona el repo.
2. Crea `.env` en la raiz.
3. Instala dependencias con `npm install`.
4. Levanta backend con `npm run dev`.
5. Levanta frontend con `cd Frontend && flutter run -d chrome`.

## Variables de entorno

Archivo `.env` en la raiz:

```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_KEY=tu_service_role_key
JWT_SECRET=una_clave_larga_de_al_menos_32_caracteres
PORT=3000
NODE_ENV=development
```

## Base de datos (paso importante)

Hay un script de hardening en:
`Backend/sql/01_hardening_prestamos_auth.sql`

Este script:
- hace unico `usuarios.documento`
- evita 2 prestamos activos para el mismo ejemplar
- agrega indices para consultas

### Si YA lo ejecutaste
No necesitas correrlo otra vez.

### Si NO lo ejecutaste
1. Abre Supabase > SQL Editor.
2. Pega el contenido del archivo SQL.
3. Ejecuta.

## Correr backend

Desde la raiz del proyecto:

```bash
npm install
npm run dev
```

Backend esperado en:
`http://localhost:3000`

Health check:
`http://localhost:3000/health`

## Correr frontend

En otra terminal:

```bash
cd Frontend
flutter pub get
flutter run -d chrome
```

## Flujo de autenticacion actual

1. Registro crea usuario.
2. Despues del registro, la app redirige a Login.
3. Login exitoso devuelve token JWT y entra al Dashboard.

## Endpoints principales

### Registro
`POST /auth/register`

Body:

```json
{
  "documento": "12345678",
  "password": "password123",
  "nombre": "Juan",
  "apellido": "Perez",
  "tipo_usuario": "estudiante"
}
```

Respuesta `201`:

```json
{
  "success": true,
  "message": "Usuario registrado exitosamente",
  "usuario": {
    "id": "uuid",
    "documento": "12345678",
    "nombre": "Juan",
    "apellido": "Perez",
    "tipo_usuario": "estudiante"
  }
}
```

### Login
`POST /auth/login`

Body:

```json
{
  "documento": "12345678",
  "password": "password123"
}
```

Respuesta `200`:

```json
{
  "success": true,
  "message": "Login exitoso",
  "token": "jwt...",
  "expiresIn": "7d",
  "usuario": {
    "id": "uuid",
    "documento": "12345678",
    "nombre": "Juan",
    "apellido": "Perez",
    "tipo_usuario": "estudiante"
  }
}
```

### Prestamos (protegidos)

- `GET /api/prestamos/mis-prestamos`
- `POST /api/prestamos/solicitar`
- `PUT /api/prestamos/devolver`

Header requerido:

```http
Authorization: Bearer <token>
```

## Reglas de seguridad implementadas

- Password hasheado con bcrypt.
- JWT con expiracion de 7 dias.
- Validacion de payload en rutas (`express-validator`).
- Un usuario no puede devolver prestamos de otro usuario.
- Manejo de consistencia en prestamos/devoluciones con rollback.

## Git y ramas

Trabajo recomendado:

```bash
git checkout develop
git pull origin develop
```

Haz cambios, commit y push a `develop` (o a una feature branch si tu flujo lo pide).

## Problemas comunes

- Error de conexion frontend-backend:
  revisa que backend este en `3000` y que frontend use `http://localhost:3000`.

- Error de Supabase:
  revisa `SUPABASE_URL`, `SUPABASE_KEY` y permisos de tablas.

- Login falla despues de registro:
  verifica que el usuario se creo en tabla `usuarios`.
