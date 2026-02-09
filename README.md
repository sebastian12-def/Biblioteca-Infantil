# Biblioteca Infantil

Sistema de gestión de biblioteca para estudiantes. Permite registrarse, autenticarse y gestionar reservas de libros.

## Estructura del Proyecto

```
Biblioteca-Infantil/
├── Backend/
│   ├── src/
│   │   ├── config/
│   │   │   └── supabase.js          # Configuración de conexión a BD
│   │   ├── controllers/
│   │   │   └── auth.controller.js   # Lógica de registro y login
│   │   ├── middlewares/
│   │   │   ├── auth.js              # Validación de JWT
│   │   │   └── notFound.js          # Manejo de rutas no encontradas
│   │   ├── routes/
│   │   │   ├── auth.routes.js       # Endpoints de autenticación
│   │   │   └── health.routes.js     # Health check
│   │   └── services/
│   │       ├── authUserService.js   # Lógica de usuarios
│   │       └── tokenService.js      # Generación y verificación de JWT
│   ├── index.js                     # Configuración de Express
│   ├── server.js                    # Punto de entrada
│   └── package.json
├── Frontend/
│   └── (por implementar)
└── .gitignore

```

## Instalación

### Requisitos

- Node.js v24.12.0 o superior
- npm o yarn
- Cuenta en Supabase

### Pasos

1. Clonar el repositorio

```bash
git clone <url-repositorio>
cd Biblioteca-Infantil
```

2. Instalar dependencias

```bash
npm install
```

3. Configurar variables de entorno

Crear archivo `.env` en la raíz:

```
SUPABASE_URL=tu_url_supabase
SUPABASE_KEY=tu_key_supabase
JWT_SECRET=tu_secret_muy_seguro_minimo_32_caracteres
PORT=5000
NODE_ENV=development
```

4. Ejecutar el servidor

```bash
npm run dev      # Con nodemon (desarrollo)
npm start        # Sin nodemon (producción)
```

El servidor estará en `http://localhost:3000`

## Base de Datos

### Tabla: usuarios

```sql
CREATE TABLE usuarios (
  id_usuario UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  documento VARCHAR UNIQUE NOT NULL,
  password TEXT NOT NULL,
  nombre VARCHAR NOT NULL,
  apellido VARCHAR NOT NULL,
  tipo_usuario VARCHAR DEFAULT 'estudiante',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## API Endpoints

### Autenticación

#### Registro

```http
POST /auth/register
Content-Type: application/json

{
  "documento": "12345678",
  "password": "password123",
  "nombre": "Juan",
  "apellido": "Pérez",
  "tipo_usuario": "estudiante"
}
```

Respuesta exitosa (201):

```json
{
  "success": true,
  "message": "Usuario registrado exitosamente",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": "7d",
  "usuario": {
    "id": "86e35d6e-a013-4f10-8f80-3ec81d780bc0",
    "documento": "12345678",
    "nombre": "Juan",
    "apellido": "Pérez",
    "tipo_usuario": "estudiante"
  }
}
```

Errores:

- 400: Faltan datos requeridos
- 409: Documento ya registrado
- 500: Error del servidor

#### Login

```http
POST /auth/login
Content-Type: application/json

{
  "documento": "12345678",
  "password": "password123"
}
```

Respuesta exitosa (200):

```json
{
  "success": true,
  "message": "Login exitoso",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": "7d",
  "usuario": {
    "id": "86e35d6e-a013-4f10-8f80-3ec81d780bc0",
    "documento": "12345678",
    "nombre": "Juan",
    "apellido": "Pérez",
    "tipo_usuario": "estudiante"
  }
}
```

Errores:

- 400: Faltan documento o password
- 404: Usuario no encontrado
- 401: Password incorrecta
- 500: Error del servidor

## JWT (JSON Web Token)

El token contiene:

```
Header:
{
  "alg": "HS256",
  "typ": "JWT"
}

Payload:
{
  "id": "uuid-del-usuario",
  "documento": "12345678",
  "tipo_usuario": "estudiante",
  "iat": 1770596118,
  "exp": 1771200918
}

Signature:
HMACSHA256(base64UrlEncode(header) + "." + base64UrlEncode(payload), JWT_SECRET)
```

El token expira en 7 días.

## Usar Token en Requests

Incluir en el header `Authorization`:

```http
GET /ruta-protegida
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## Seguridad

- Las contraseñas se encriptan con bcrypt (10 salt rounds) antes de guardar
- Los tokens se firman con HS256 usando JWT_SECRET
- El JWT_SECRET debe tener mínimo 32 caracteres
- Las contraseñas hasheadas en BD no pueden invertirse

## Arquitectura

El proyecto sigue el patrón: **Route -> Controller -> Service -> Database**

- **Routes**: Define endpoints y vincula con controllers
- **Controllers**: Maneja requests HTTP, valida datos, orquesta services
- **Services**: Contiene lógica de negocio y queries a BD
- **Middlewares**: Interceptan requests para validaciones globales

No se usan Models porque Supabase SDK proporciona ya la abstracción de datos.

## Contribuciones

Cada miembro del equipo trabaja en su rama:

```bash
git checkout -b feature/nombre-feature
# Hacer cambios
git add .
git commit -m "feat: descripción del cambio"
git push origin feature/nombre-feature
# Crear Pull Request
```

Reglas:

- NO modificar archivos ajenos
- Crear archivos nuevos para nuevas funcionalidades
- Hacer git pull antes de trabajar
- Commits frecuentes y descriptivos

## Status del Proyecto

Completado:

- Registro con validación y encriptación
- Login con verificación de credenciales
- JWT generación y validación
- Middleware de autenticación
- Middleware de 404

Por hacer:

- Endpoints de libros (listar, detalles)
- Endpoints de reservas
- Historial de usuario
- Frontend (registro, login, dashboard)
- CORS configurado
- Validación con ZOD

## Equipo

- Cristian: Autenticación y JWT
- [Compañero 1]: Libros
- [Compañero 2]: Reservas e historial
