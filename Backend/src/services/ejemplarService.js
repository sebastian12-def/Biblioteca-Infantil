import { supabase } from "../config/supabase.js"

// Obtener todos los ejemplares de un libro
export const getEjemplaresByLibro = async (id_libro) => {
    const { data, error } = await supabase
        .from('ejemplares_libro')
        .select('*')
        .eq('id_libro', id_libro)
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data }
}

// Obtener ejemplares disponibles de un libro
export const getEjemplaresDisponibles = async (id_libro) => {
    const { data, error } = await supabase
        .from('ejemplares_libro')
        .select('*')
        .eq('id_libro', id_libro)
        .eq('disponibilidad', true)
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data }
}

// Obtener conteo de ejemplares por libro (disponibles y prestados)
export const getEjemplaresConteo = async (id_libro) => {
    const { data, error } = await supabase
        .from('ejemplares_libro')
        .select('disponibilidad')
        .eq('id_libro', id_libro)
    
    if (error) {
        return { success: false, error: error.message }
    }
    
    const total = data.length
    const disponibles = data.filter(e => e.disponibilidad === true).length
    const prestados = total - disponibles
    
    return { success: true, data: { total, disponibles, prestados } }
}

// Crear un nuevo ejemplar
export const createEjemplar = async (ejemplarData) => {
    if (!ejemplarData.id_libro || !ejemplarData.codigo_inventario) {
        return { success: false, error: "Faltan id_libro y codigo_inventario" }
    }

    const { data, error } = await supabase
        .from('ejemplares_libro')
        .insert([{
            id_libro: ejemplarData.id_libro,
            codigo_inventario: ejemplarData.codigo_inventario,
            condicion: ejemplarData.condicion || 'bueno',
            disponibilidad: ejemplarData.disponibilidad !== false
        }])
        .select()
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data: data[0] }
}

// Actualizar disponibilidad de un ejemplar
export const updateEjemplarDisponibilidad = async (id_ejemplar, disponibilidad) => {
    const { data, error } = await supabase
        .from('ejemplares_libro')
        .update({ disponibilidad })
        .eq('id_ejemplar', id_ejemplar)
        .select()
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data: data[0] }
}

// Obtener un ejemplar por ID
export const getEjemplarById = async (id_ejemplar) => {
    const { data, error } = await supabase
        .from('ejemplares_libro')
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
        .from('ejemplares_libro')
        .delete()
        .eq('id_ejemplar', id_ejemplar)
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, message: "Ejemplar eliminado" }
}

// Obtener primer ejemplar disponible de un libro (para préstamos)
export const getPrimerEjemplarDisponible = async (id_libro) => {
    const { data, error } = await supabase
        .from('ejemplares_libro')
        .select('*')
        .eq('id_libro', id_libro)
        .eq('disponibilidad', true)
        .limit(1)
        .single()
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data }
}
