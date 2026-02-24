import {registerController, loginController} from '../controllers/auth.controller.js'
import e from "express";
import { body } from "express-validator";
import { validateRequest } from "../middlewares/validateRequest.js";



const router = e.Router();

router.post(
    '/register',
    [
        body('documento').trim().notEmpty().withMessage('documento es requerido'),
        body('password').isString().isLength({ min: 6 }).withMessage('password mínimo 6 caracteres'),
        body('nombre').trim().notEmpty().withMessage('nombre es requerido'),
        body('apellido').trim().notEmpty().withMessage('apellido es requerido'),
        body('tipo_usuario').trim().notEmpty().withMessage('tipo_usuario es requerido'),
    ],
    validateRequest,
    registerController
)


router.post(
    '/login',
    [
        body('documento').trim().notEmpty().withMessage('documento es requerido'),
        body('password').isString().notEmpty().withMessage('password es requerido'),
    ],
    validateRequest,
    loginController
)

export  default router
