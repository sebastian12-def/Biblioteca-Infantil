# SETUP RAPIDO - Biblioteca Infantil

Guia corta para levantar todo en local.

## 1) Requisitos

- Node.js 18+
- npm
- Flutter SDK
- Proyecto Supabase listo

## 2) Configurar `.env` (raiz del repo)

```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_KEY=tu_service_role_key
JWT_SECRET=una_clave_larga_de_al_menos_32_caracteres
PORT=3000
NODE_ENV=development
```

## 3) Instalar dependencias

En la raiz:

```bash
npm install
```

En frontend:

```bash
cd Frontend
flutter pub get
```

## 4) Ejecutar backend

En la raiz:

```bash
npm run dev
```

Esperado:
- servidor en `http://localhost:3000`
- health en `http://localhost:3000/health`

## 5) Ejecutar frontend

En otra terminal:

```bash
cd Frontend
flutter run -d chrome
```

## 6) SQL de hardening

Archivo:
`Backend/sql/01_hardening_prestamos_auth.sql`

- Si ya lo ejecutaste en Supabase: listo, no repitas.
- Si no lo ejecutaste: correlo una vez en SQL Editor.

## 7) Prueba minima

1. Registrar usuario.
2. Confirmar que vuelve a Login.
3. Hacer Login.
4. Solicitar un prestamo.
5. Devolver el prestamo.

## 8) Git (subir a develop)

```bash
git checkout develop
git pull origin develop
git add .
git commit -m "docs: actualizar documentacion clara de setup y flujo"
git push origin develop
```
