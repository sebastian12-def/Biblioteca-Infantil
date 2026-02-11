import { supabase } from "../config/supabase.js";

/**
 * Obtiene el historial de préstamos de un alumno específico.
 * Realiza un 'join' automático con la tabla libros para traer títulos y autores.
 */
export const getPrestamosByUsuario = async (id_usuario) => {
    // Consultamos la tabla 'prestamos' filtrando por el ID del usuario logueado
    const { data, error } = await supabase
        .from('prestamos')
        .select(`
            id_prestamo,
            fecha_prestamo,
            estado,
            id_ejemplar,
            libros (
                titulo,
                autor
            )
        `)
        .eq('id_usuario', id_usuario)
        .order('fecha_prestamo', { ascending: false }); // Los más recientes primero

    if (error) {
        return { success: false, error: error.message };
    }

    return { success: true, data };
};

/**
 * Registra un nuevo préstamo y actualiza la disponibilidad del ejemplar.
 */
export const crearPrestamo = async (id_usuario, id_libro, id_ejemplar) => {
    
    // Cumplimos con "Manejo de estados": el estado inicial es 'activo'
    const { data, error: errorPrestamo } = await supabase
        .from('prestamos')
        .insert([{ 
            id_usuario, 
            id_libro, 
            id_ejemplar,
            estado: 'activo', 
            fecha_prestamo: new Date() 
        }])
        .select();

    if (errorPrestamo) {
        return { success: false, error: errorPrestamo.message };
    }

    // Al prestarse, el ejemplar debe pasar a disponibilidad = false en la tabla 'ejemplares_libro'
    const { error: errorEjemplar } = await supabase
        .from('ejemplares_libro')
        .update({ disponibilidad: false })
        .eq('id_ejemplar', id_ejemplar);

    if (errorEjemplar) {
        // pero para este nivel, reportamos el error de consistencia.
        return { success: false, error: "Préstamo creado pero falló actualizar disponibilidad: " + errorEjemplar.message };
    }

    return { success: true, data: data[0] };
};

/**
 * Cambia el estado a 'devuelto' y libera el ejemplar.
 */
export const finalizarPrestamo = async (id_prestamo, id_ejemplar) => {
    // 1. Cambiar estado del préstamo
    const { error: errorUpdate } = await supabase
        .from('prestamos')
        .update({ estado: 'devuelto' })
        .eq('id_prestamo', id_prestamo);

    if (errorUpdate) return { success: false, error: errorUpdate.message };

    // 2. Liberar el ejemplar para que otro niño pueda usarlo
    await supabase
        .from('ejemplares_libro')
        .update({ disponibilidad: true })
        .eq('id_ejemplar', id_ejemplar);

    return { success: true, message: "Libro devuelto correctamente" };
};