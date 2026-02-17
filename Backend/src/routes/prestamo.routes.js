import { Router } from 'express';
import { getMisPrestamosController, solicitarPrestamoController, devolverPrestamoController } from '../controllers/prestamo.controller.js';
import { authMiddleware } from '../middlewares/auth.js';

const router = Router();

/**
 * 'authMiddleware' extrae el id del alumno del token y lo pasa al controlador.
 */
router.get('/mis-prestamos', authMiddleware, getMisPrestamosController);

/**
 * Protegido para que solo usuarios autenticados soliciten libros.
 */
router.post('/solicitar', authMiddleware, solicitarPrestamoController);

/**
 * Devuelve un préstamo.
 */
router.put('/devolver', authMiddleware, devolverPrestamoController);

export default router;