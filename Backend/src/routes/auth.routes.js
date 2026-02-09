import {registerController, loginController} from '../controllers/auth.controller.js'
import e from "express";



const router = e.Router();

router.post('/register', registerController)

router.post('/login', loginController )
export  default router