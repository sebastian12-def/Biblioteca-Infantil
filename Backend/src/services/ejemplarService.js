import { supabase } from "../config/supabase.js"

// Obtener todos los ejemplares de un libro
export const getEjemplaresByLibro = async (id_libro) => {
    const { data, error } = await supabase
        .from('ejemplares_libros')
        .select('*')
        .eq('id_libro', id_libro)
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data }
}

// Obtener ejemplares disponibles de un libro
export const getEjemplaresDisponibles = async (id_libro) => {
    const { data, error } = await supabase
        .from('ejemplares_libros')
        .select('*')
        .eq('id_libro', id_libro)
        .eq('estado', 'disponible')
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data }
}

// Crear un nuevo ejemplar
export const createEjemplar = async (ejemplarData) => {
    if (!ejemplarData.id_libro || !ejemplarData.codigo_ejemplar) {
        return { success: false, error: "Faltan id_libro y codigo_ejemplar" }
    }

    const { data, error } = await supabase
        .from('ejemplares_libros')
        .insert([ejemplarData])
        .select()
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data: data[0] }
}

// Actualizar estado de un ejemplar
export const updateEjemplarEstado = async (id_ejemplar, estado) => {
    const { data, error } = await supabase
        .from('ejemplares_libros')
        .update({ estado })
        .eq('id_ejemplar', id_ejemplar)
        .select()
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data: data[0] }
}

// Obtener un ejemplar por ID
export const getEjemplarById = async (id_ejemplar) => {
    const { data, error } = await supabase
        .from('ejemplares_libros')
        .select('*')
        .eq('id_ejemplar', id_ejemplar)
        .single()
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data }
}

// Eliminar un ejemplar
export const deleteEjemplar = async (id_ejemplar) => {
    const { error } = await supabase
        .from('ejemplares_libros')
        .delete()
        .eq('id_ejemplar', id_ejemplar)
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, message: "Ejemplar eliminado" }
}
