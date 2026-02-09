import {registerController} from '../controllers/auth.controller.js'
import e from "express";



const router = e.Router();

router.post('/register', registerController)

export  default router