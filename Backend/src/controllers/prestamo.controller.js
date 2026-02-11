import * as prestamoService from "../services/prestamosService.js";

/**
 * Maneja la obtención de préstamos del alumno logueado.
 */
export const getMisPrestamosController = async (req, res) => {
    try {
        // El id_usuario viene del token decodificado Middleware de Cristian
        const id_usuario = req.user.id; 

        const resultado = await prestamoService.getPrestamosByUsuario(id_usuario);

        if (!resultado.success) {
            //  Mensaje de error
            return res.status(500).json({
                success: false,
                message: "Error al recuperar tu historial de préstamos",
                error: resultado.error
            });
        }

        //  Mensaje de éxito
        res.status(200).json({
            success: true,
            message: "Historial de préstamos obtenido correctamente",
            data: resultado.data
        });
    } catch (error) {
        res.status(500).json({ success: false, message: "Error interno del servidor", error: error.message });
    }
};

/**
 * Maneja la creación de una nueva solicitud de préstamo.
 */
export const solicitarPrestamoController = async (req, res) => {
    try {
        const id_usuario = req.user.id;
        const { id_libro, id_ejemplar } = req.body;

        // Validación básica de entrada
        if (!id_libro || !id_ejemplar) {
            return res.status(400).json({
                success: false,
                message: "Faltan datos necesarios (id_libro o id_ejemplar)"
            });
        }

        const resultado = await prestamoService.crearPrestamo(id_usuario, id_libro, id_ejemplar);

        if (!resultado.success) {
            //  Mensaje de error 
            return res.status(400).json({
                success: false,
                message: "No se pudo procesar la solicitud de préstamo",
                error: resultado.error
            });
        }

        // Mensaje de éxito
        res.status(201).json({
            success: true,
            message: "¡Préstamo registrado con éxito! Disfruta tu libro.",
            data: resultado.data
        });
    } catch (error) {
        res.status(500).json({ success: false, message: "Error al procesar la solicitud", error: error.message });
    }
};