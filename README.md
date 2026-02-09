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

El servidor estará en `http://localhost:5000`

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

## Flujo de Trabajo Colaborativo

### Estructura de Ramas

```
main (rama principal - NO TOCAR)
  └── develop (rama de desarrollo - aquí trabaja todo el equipo)
       ├── feature/auth
       ├── feature/libros
       ├── feature/reservas
       ├── feature/ui-auth
       └── feature/dashboard
```

### Regla de Oro

**NADIE toca `main` directamente. TODOS hacen PR a `develop`.**

### Proceso de Trabajo

#### Paso 1: Actualizar develop

```bash
git checkout develop
git pull origin develop
```

#### Paso 2: Cambiar a tu rama

```bash
git checkout tu-rama
git pull origin tu-rama
```

#### Paso 3: Hacer cambios

```bash
# Agregar archivos específicos
git add Backend/src/controllers/mi-controller.js
git add Backend/src/services/mi-service.js

# Commit con mensaje descriptivo
git commit -m "feat: crear endpoint para obtener libros"

# Otro cambio
git add Backend/src/routes/libros.routes.js
git commit -m "feat: agregar ruta GET /libros"

# Push a tu rama
git push origin tu-rama
```

#### Paso 4: Crear Pull Request

En GitHub:

1. Ir a "Pull Requests"
2. Click en "New Pull Request"
3. Base: `develop` | Compare: `tu-rama`
4. Agregar descripción clara
5. Solicitar review a otros miembros
6. Esperar aprobación
7. Mergear cuando esté aprobado

#### Paso 5: Después del merge

```bash
# Volver a develop
git checkout develop

# Actualizar
git pull origin develop

# Eliminar rama local
git branch -d tu-rama

# Eliminar rama remota
git push origin --delete tu-rama
```

### Convenciones de Commits

Formato: `<tipo>: <descripción>`

Tipos:

- **feat**: Nueva funcionalidad
  ```
  git commit -m "feat: agregar registro de usuarios"
  ```

- **fix**: Corrección de bug
  ```
  git commit -m "fix: corregir validación de email en login"
  ```

- **docs**: Documentación
  ```
  git commit -m "docs: actualizar README con nuevos endpoints"
  ```

- **style**: Cambios de formato (sin lógica)
  ```
  git commit -m "style: ajustar indentación en auth.controller.js"
  ```

- **refactor**: Reorganizar código (sin cambiar comportamiento)
  ```
  git commit -m "refactor: extraer validación a función separada"
  ```

- **test**: Agregar tests
  ```
  git commit -m "test: crear tests para endpoint /login"
  ```

- **chore**: Tareas administrativas
  ```
  git commit -m "chore: actualizar dependencias de npm"
  ```

### Resolución de Conflictos

Si hay conflicto al hacer pull:

1. Git indicará archivos con conflictos
2. Abre el archivo y verás marcadores:

```
<<<<<<< HEAD
Tu código
=======
Código remoto
>>>>>>> rama-remota
```

3. Decide qué código mantener (elimina marcadores)
4. Resuelve:

```bash
git add archivo-resuelto.js
git commit -m "fix: resolver conflicto en archivo-resuelto.js"
git push origin feature/tu-funcionalidad
```

### Reglas Importantes

- NO trabajar directamente en `main`
- SIEMPRE crear rama `feature/` desde `develop`
- NUNCA modificar archivos de otros miembros
- SIEMPRE hacer `git pull` antes de empezar
- SIEMPRE hacer `git pull` antes de hacer push
- Commits frecuentes y descriptivos (no commits gigantes)
- Revisar cambios antes de hacer commit: `git diff`

### Distribución de Responsabilidades

#### Backend

| Miembro | Feature | Archivos | Rama |
|---------|---------|----------|------|
| Cristian | Autenticación | `Backend/src/controllers/auth.controller.js`, `Backend/src/services/authUserService.js`, `Backend/src/services/tokenService.js`, `Backend/src/middlewares/auth.js` | `feature/auth` |
| Compañero 1 | Libros | `Backend/src/controllers/libros.controller.js`, `Backend/src/services/libros.service.js`, `Backend/src/routes/libros.routes.js` | `feature/libros` |
| Compañero 2 | Reservas | `Backend/src/controllers/reservas.controller.js`, `Backend/src/services/reservas.service.js`, `Backend/src/routes/reservas.routes.js` | `feature/reservas` |

#### Frontend

| Miembro | Feature | Archivos | Rama |
|---------|---------|----------|------|
| Compañero 3 | UI Autenticación | `Frontend/lib/screens/register_screen.dart`, `Frontend/lib/screens/login_screen.dart`, `Frontend/lib/widgets/auth_form.dart` | `feature/ui-auth` |
| Compañero 4 | Dashboard | `Frontend/lib/screens/dashboard_screen.dart`, `Frontend/lib/widgets/book_list.dart`, `Frontend/lib/widgets/reservation_form.dart` | `feature/dashboard` |

#### Compartido

| Archivos | Responsable | Notas |
|----------|-------------|-------|
| `Backend/index.js`, `Backend/package.json` | Todos | Coordinar cambios vía PR |
| `.env.example` | Todos | Actualizar cuando hay nuevas variables |
| `README.md` | Todos | Documentación de cambios |

### Comandos Git Útiles

```bash
# Ver historial de commits
git log --oneline

# Ver ramas locales
git branch

# Ver ramas remotas
git branch -r

# Ver cambios pendientes
git status
git diff

# Deshacer cambio en archivo (antes de hacer add)
git restore archivo.js

# Deshacer commit pero mantener cambios
git reset --soft HEAD~1

# Cambiar de rama
git checkout nombre-rama

# Ver cambios antes de hacer push
git log origin/develop..HEAD
```

### Checklist antes de hacer Push

- [ ] Hice `git pull` de la rama base
- [ ] Los cambios son solo en mis archivos
- [ ] Los commits tienen mensajes descriptivos
- [ ] El código funciona localmente
- [ ] No hay conflictos
- [ ] La rama está actualizada con `develop`

## Contribuciones

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
- CORS configurado (talvez luego )
- Validación con ZOD  (talvez luego )

## Equipo

- Cristian: Autenticación y JWT
- [Compañero 1]: Libros
- [Compañero 2]: Reservas e historial
