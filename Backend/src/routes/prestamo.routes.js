import { Router } from 'express';
// Importamos las funciones que creaste en el controlador
import { solicitarPrestamo, getMisPrestamos } from '../controllers/prestamo.controller.js';

// NOTA: Se comenta el middleware de autenticación porque el archivo no existe en la carpeta
// import { verifyToken } from '../middlewares/auth.middleware.js'; 

const router = Router();

/**
 * RUTA: POST /prestamos/solicitar
 * Quité 'verifyToken' para que el código no explote al arrancar
 */
router.post('/solicitar', solicitarPrestamo);

/**
 * RUTA: GET /prestamos/mis-prestamos
 */
router.get('/mis-prestamos', getMisPrestamos);

export default router;