# 🚀 Guía de Configuración - Backend Biblioteca Infantil

## 📋 Requisitos Previos

- **Node.js** v18+ instalado
- **npm** v9+
- Cuenta en **Supabase** con credenciales configuradas
- **Git** configurado

## 🔧 Instalación

### 1. Clonar el repositorio

```bash
git clone <repositorio>
cd Biblioteca-Infantil
git checkout infraestructura
```

### 2. Instalar dependencias

```bash
npm install
```

### 3. Configurar variables de entorno

Crear archivo `.env` en la **raíz del proyecto**:

```bash
# .env (NUNCA commitear este archivo)
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
PORT=3000
JWT_SECRET=tu_secret_aqui
NODE_ENV=development
```

⚠️ **IMPORTANTE:** 
- Agregar `.env` a `.gitignore`
- Las credenciales son sensibles, NO compartir

## ▶️ Iniciar el Servidor

### Modo Desarrollo

```bash
npm start
```

**Output esperado:**
```
✅ Cliente Supabase inicializado correctamente
✓ Servidor corriendo en http://localhost:3000
✓ Entorno: development
✓ Listo para recibir peticiones
```

### Modo con Nodemon (Auto-reload)

```bash
npm run dev
```

## 🧪 Verificar que funciona

### Health Check

```bash
curl http://localhost:3000/health
```

**Respuesta exitosa (200):**
```json
{
  "success": true,
  "message": "Servidor de express corriendo correctamente",
  "status": "OK",
  "server": "up",
  "db": "Connected"
}
```

**Respuesta con error BD (500):**
```json
{
  "status": "error",
  "db": "down"
}
```

## 📁 Estructura del Proyecto

```
Backend/
├── server.js                 # Punto de entrada
├── index.js                  # Configuración Express
└── src/
    ├── config/
    │   └── supabase.js      # Conexión a Supabase
    ├── services/
    │   └── healthService.js # Lógica de health check
    ├── routes/
    │   └── health.routes.js # Rutas health
    ├── controllers/          # Lógica de peticiones HTTP
    ├── middlewares/          # Middleware Express
    └── models/               # Ejemplos de modelos
```

## 🔌 Arquitectura por Capas

### Service Layer
```javascript
// Backend/src/services/healthService.js
// Contiene: lógica de negocio
export const checkSupabaseConection = async () => { ... }
```

### Routes Layer
```javascript
// Backend/src/routes/health.routes.js
// Contiene: endpoints HTTP
router.get("/", async(req, res) => { ... })
```

### Config Layer
```javascript
// Backend/src/config/supabase.js
// Contiene: conexión a BD
export const supabase = createClient(url, key)
```

## 🚨 Solución de Problemas

### Error: "MODULE_NOT_FOUND"
```
Asegúrate de que todas las importaciones tengan extensión .js:
import { algo } from "../archivo.js";  ✅
import { algo } from "../archivo";     ❌
```

### Error: "Falta SUPABASE_URL"
```
Verifica que:
1. El archivo .env exista en la raíz
2. Las variables estén correctas
3. Node.js esté leyendo dotenv (import 'dotenv/config')
```

### Error: "Supabase NO disponible"
```
Significa:
1. ✅ La conexión se estableció
2. ❌ La tabla 'usuarios' no existe o está vacía

Crear la tabla en Supabase SQL Editor:
CREATE TABLE usuarios (
  id BIGSERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 📝 Consideraciones de Desarrollo

### Variables de Entorno
- **NUNCA** hardcodear credenciales
- **NUNCA** commitear `.env`
- Usar ejemplo `.env.example` para otros developers

### Logs
- `console.log` en desarrollo
- Implementar logger profesional en producción (winston, pino)

### Estructura sin Models
- Como usamos Supabase (SDK listo), **NO necesitamos Models**
- Estructura: Routes → Services → Supabase
- Más simple y mantenible

## 🔐 Seguridad

- [ ] Validar entrada de datos (express-validator ya instalado)
- [ ] CORS configurado en producción
- [ ] JWT para autenticación (jsonwebtoken ya instalado)
- [ ] bcrypt para contraseñas (ya instalado)

## 📚 Documentación Oficial

- [Supabase JS SDK](https://supabase.com/docs/reference/javascript/introduction)
- [Express.js](https://expressjs.com/)
- [Node.js Dotenv](https://github.com/motdotla/dotenv)

---

**Última actualización:** Febrero 7, 2026
