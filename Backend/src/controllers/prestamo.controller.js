// Importamos la conexión a Supabase 
import { supabase } from '../config/supabase.js';

/**
 * 1. SOLICITAR PRÉSTAMO
 * Esta función se activa cuando el usuario hunde el botón "Solicitar" en la App.
 */
export const solicitarPrestamo = async (req, res) => {
    // Recibimos el ID del ejemplar desde el cuerpo de la petición (Frontend) 
    const { id_ejemplar } = req.body;
    
    // El id_usuario se sacará del token cuando Cristian termine el Middleware 
    // Por ahora, para que puedas probar, podrías usar uno fijo o esperar a que él lo pase.
    const id_usuario = req.usuario.id; 

    try {
        // PASO A: Validar si el libro existe y si está disponible 
        const { data: ejemplar, error: errorEjemplar } = await supabase
            .from('ejemplares_libro')
            .select('disponibilidad')
            .eq('id_ejemplar', id_ejemplar)
            .single();

        // Si el ejemplar no está disponible, mandamos un mensaje de error 
        if (!ejemplar || ejemplar.disponibilidad !== 'disponible') {
            return res.status(400).json({ 
                success: false, 
                message: "No disponible: Este ejemplar ya está prestado o en mantenimiento." 
            });
        }

        // PASO B: Crear la solicitud en estado 'pendiente' 
        // Se registra en la tabla 'solicitudes' para que el bibliotecario la apruebe después 
        const { data, error } = await supabase
            .from('solicitudes')
            .insert([
                { 
                    id_usuario: id_usuario, 
                    id_ejemplar: id_ejemplar, 
                    estado: 'pendiente' // El estado inicial siempre es pendiente 
                }
            ]);

        if (error) throw error;

        // Mensaje de éxito (Tu tarea de Mensajes de éxito/error)
        return res.status(201).json({ 
            success: true, 
            message: "¡Solicitud registrada! El bibliotecario debe aprobarla." 
        });

    } catch (error) {
        return res.status(500).json({ success: false, message: "Error en el servidor: " + error.message });
    }
};

/**
 * 2. VER MIS PRÉSTAMOS
 * Muestra al estudiante o profesor sus libros actuales y pasados
 */
export const getMisPrestamos = async (req, res) => {
    const id_usuario = req.usuario.id; // Obtenemos el ID del usuario logueado 

    try {
        // Consultamos la tabla prestamos y "unimos" datos de libros para que se vea el título 
        const { data, error } = await supabase
            .from('prestamos')
            .select(`
                id_prestamo,
                fecha_prestamo,
                estado,
                ejemplares_libro (
                    codigo_inventario,
                    libros (titulo, autor)
                )
            `)
            .eq('id_usuario', id_usuario); // Filtramos para que solo vea los SUYOS 

        if (error) throw error;

        return res.status(200).json({ 
            success: true, 
            data: data 
        });

    } catch (error) {
        return res.status(500).json({ success: false, message: "Error al obtener préstamos: " + error.message });
    }
};