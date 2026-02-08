import express from "express";
const aplicacion = express(); // Se crea la instancia antes de usarla

import prestamoRoutes from './src/routes/prestamo.routes.js';
import healthRoute from './src/routes/health.routes.js';
import { notFoundHandler } from './src/middlewares/notFound.js';

aplicacion.use(express.json());
aplicacion.use('/prestamos', prestamoRoutes);
aplicacion.use('/health', healthRoute);

aplicacion.use(notFoundHandler);

export default aplicacion; // Exportamos aplicacion