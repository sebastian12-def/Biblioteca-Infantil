
import { verifyToken } from "../services/tokenService.js";
export const authMiddleware = (req, res, next) => {
      // MIDDLEWARE DE AUTENTICACIÓN
    // Responsabilidad: Verificar si el token es válido
    // Si es válido → permite continuar
    // Si es inválido → rechaza con 401

    const authHeader = req.headers.authorization;

    if(!authHeader){
        return res.status(401).json({
            success: false,
            message: "No tienes autorización"
        });
    }

    const token = authHeader.split(' ') [1]; //devido el header en 2 y tomo la segunda posicion del array 

    const decoded = verifyToken(token)


    if(!decoded.success){
        return res.status(401).json({
            success: false,
            error: decoded.error  //el error por que las firmas o el token expiro
        });
    }
    // Token válido → guarda datos en req para que la ruta los use
    req.user = decoded.data
    next();
}