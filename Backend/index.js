// index.js: Configuración de la App (rutas, middleware, etc.)
import express from "express";
import cors from "cors";

// Importación de rutas
import healthRoute from './src/routes/health.routes.js';
import authRoutes from './src/routes/auth.routes.js';
import booksRoutes from './src/routes/books.routes.js';
import prestamoRoutes from './src/routes/prestamo.routes.js'; 

// Middleware para rutas no encontradas
import { notFoundHandler } from './src/middlewares/notFound.js';

const app = express();

// CORS - permitir peticiones desde cualquier origen (Flutter web, móvil, etc.)
app.use(cors());

app.use(express.json()); // Middleware para procesar JSON

// Definición de Endpoints
app.use('/health', healthRoute);
app.use('/auth', authRoutes);
app.use('/libros', booksRoutes);
app.use('/api/prestamos', prestamoRoutes);


// Si ninguna ruta de arriba coincidió, entra aquí
app.use(notFoundHandler);

export default app; 