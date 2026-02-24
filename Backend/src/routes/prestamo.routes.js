import { Router } from 'express';
import { getMisPrestamosController, solicitarPrestamoController, devolverPrestamoController } from '../controllers/prestamo.controller.js';
import { authMiddleware } from '../middlewares/auth.js';
import { body } from "express-validator";
import { validateRequest } from "../middlewares/validateRequest.js";

const router = Router();

/**
 * 'authMiddleware' extrae el id del alumno del token y lo pasa al controlador.
 */
router.get('/mis-prestamos', authMiddleware, getMisPrestamosController);

/**
 * Protegido para que solo usuarios autenticados soliciten libros.
 */
router.post(
    '/solicitar',
    authMiddleware,
    [
        body('id_libro').notEmpty().withMessage('id_libro es requerido'),
        body('id_ejemplar').notEmpty().withMessage('id_ejemplar es requerido'),
    ],
    validateRequest,
    solicitarPrestamoController
);

/**
 * Devuelve un préstamo.
 */
router.put(
    '/devolver',
    authMiddleware,
    [body('id_prestamo').notEmpty().withMessage('id_prestamo es requerido')],
    validateRequest,
    devolverPrestamoController
);

export default router;
