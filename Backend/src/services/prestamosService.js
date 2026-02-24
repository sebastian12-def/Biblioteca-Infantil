import { supabase } from "../config/supabase.js";

/**
 * Obtiene el historial de prestamos de un alumno especifico.
 */
export const getPrestamosByUsuario = async (id_usuario) => {
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
        .order('fecha_prestamo', { ascending: false });

    if (error) {
        return { success: false, error: error.message };
    }

    return { success: true, data };
};

/**
 * Registra un nuevo prestamo y bloquea el ejemplar disponible.
 * Se intenta consistencia con compensacion en caso de error.
 */
export const crearPrestamo = async (id_usuario, id_libro, id_ejemplar) => {
    const { data: ejemplar, error: errorEjemplarLookup } = await supabase
        .from('ejemplares_libro')
        .select('id_ejemplar, id_libro, disponibilidad')
        .eq('id_ejemplar', id_ejemplar)
        .eq('id_libro', id_libro)
        .single();

    if (errorEjemplarLookup || !ejemplar) {
        return { success: false, error: "Ejemplar no encontrado para el libro seleccionado" };
    }

    if (!ejemplar.disponibilidad) {
        return { success: false, error: "El ejemplar ya no esta disponible" };
    }

    const { data: ejemplarBloqueado, error: errorBloqueo } = await supabase
        .from('ejemplares_libro')
        .update({ disponibilidad: false })
        .eq('id_ejemplar', id_ejemplar)
        .eq('id_libro', id_libro)
        .eq('disponibilidad', true)
        .select('id_ejemplar');

    if (errorBloqueo) {
        return { success: false, error: errorBloqueo.message };
    }

    if (!ejemplarBloqueado || ejemplarBloqueado.length === 0) {
        return { success: false, error: "El ejemplar ya no esta disponible" };
    }

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
        const { error: rollbackError } = await supabase
            .from('ejemplares_libro')
            .update({ disponibilidad: true })
            .eq('id_ejemplar', id_ejemplar)
            .eq('id_libro', id_libro)
            .eq('disponibilidad', false);

        if (rollbackError) {
            return {
                success: false,
                error: `Fallo crear prestamo y fallo rollback de ejemplar: ${rollbackError.message}`
            };
        }

        return { success: false, error: errorPrestamo.message };
    }

    return { success: true, data: data[0] };
};

/**
 * Cambia estado a devuelto validando propiedad del prestamo.
 * Si falla liberar ejemplar, revierte estado del prestamo.
 */
export const finalizarPrestamo = async (id_prestamo, id_usuario) => {
    const { data: prestamoActualizado, error: errorUpdate } = await supabase
        .from('prestamos')
        .update({ estado: 'devuelto' })
        .eq('id_prestamo', id_prestamo)
        .eq('id_usuario', id_usuario)
        .eq('estado', 'activo')
        .select('id_prestamo, id_ejemplar, id_libro');

    if (errorUpdate) return { success: false, error: errorUpdate.message };

    if (!prestamoActualizado || prestamoActualizado.length === 0) {
        return { success: false, error: "Prestamo no encontrado, no pertenece al usuario o ya fue devuelto" };
    }

    const prestamo = prestamoActualizado[0];

    const { error: errorLiberar } = await supabase
        .from('ejemplares_libro')
        .update({ disponibilidad: true })
        .eq('id_ejemplar', prestamo.id_ejemplar)
        .eq('id_libro', prestamo.id_libro);

    if (errorLiberar) {
        const { error: rollbackError } = await supabase
            .from('prestamos')
            .update({ estado: 'activo' })
            .eq('id_prestamo', id_prestamo)
            .eq('id_usuario', id_usuario);

        if (rollbackError) {
            return {
                success: false,
                error: `Fallo liberar ejemplar y fallo rollback de prestamo: ${rollbackError.message}`
            };
        }

        return { success: false, error: `No se pudo liberar ejemplar: ${errorLiberar.message}` };
    }

    return { success: true, message: "Libro devuelto correctamente" };
};
