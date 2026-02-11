import { Router } from 'express';
import { getMisPrestamosController, solicitarPrestamoController } from '../controllers/prestamo.controller.js';
import { validarJWT } from '../middlewares/auth.js'; // El middleware que hizo Cristian

const router = Router();

/**
 * 'validarJWT' extrae el id del alumno del token y lo pasa al controlador.
 */
router.get('/mis-prestamos', validarJWT, getMisPrestamosController);

/**
 * Protegido para que solo usuarios autenticados soliciten libros.
 */
router.post('/solicitar', validarJWT, solicitarPrestamoController);

export default router;