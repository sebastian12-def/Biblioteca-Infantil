import { supabase } from "../config/supabase.js"

// Obtener todos los libros
export const getAllBooks = async () => {
    const { data, error } = await supabase
        .from('libros')
        .select('*')
        .order('titulo', { ascending: true })
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data }
}

// Obtener un libro por ID
export const getBookById = async (id_libro) => {
    const { data, error } = await supabase
        .from('libros')
        .select('*')
        .eq('id_libro', id_libro)
        .single()
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data }
}

// Buscar libros por título o autor
export const searchBooks = async (searchTerm) => {
    const { data, error } = await supabase
        .from('libros')
        .select('*')
        .or(`titulo.ilike.%${searchTerm}%,autor.ilike.%${searchTerm}%`)
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data }
}

// Crear un nuevo libro
export const createBook = async (bookData) => {
    if (!bookData.titulo || !bookData.autor || !bookData.cantidad_total) {
        return { success: false, error: "Faltan campos requeridos" }
    }

    const { data, error } = await supabase
        .from('libros')
        .insert([{ ...bookData, cantidad_disponible: bookData.cantidad_total }])
        .select()
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data: data[0] }
}

// Actualizar un libro
export const updateBook = async (id_libro, updateData) => {
    const { data, error } = await supabase
        .from('libros')
        .update({ ...updateData, updated_at: new Date() })
        .eq('id_libro', id_libro)
        .select()
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data: data[0] }
}

// Decrementar disponibilidad (al reservar)
export const decrementarDisponibilidad = async (id_libro) => {
    const libro = await getBookById(id_libro)
    if (!libro.success) return libro

    if (libro.data.cantidad_disponible <= 0) {
        return { success: false, error: "No hay copias disponibles" }
    }

    const { data, error } = await supabase
        .from('libros')
        .update({ cantidad_disponible: libro.data.cantidad_disponible - 1 })
        .eq('id_libro', id_libro)
        .select()
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data: data[0] }
}

// Incrementar disponibilidad (al devolver)
export const incrementarDisponibilidad = async (id_libro) => {
    const libro = await getBookById(id_libro)
    if (!libro.success) return libro

    if (libro.data.cantidad_disponible >= libro.data.cantidad_total) {
        return { success: false, error: "Cantidad no puede exceder el total" }
    }

    const { data, error } = await supabase
        .from('libros')
        .update({ cantidad_disponible: libro.data.cantidad_disponible + 1 })
        .eq('id_libro', id_libro)
        .select()
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, data: data[0] }
}

// Eliminar un libro
export const deleteBook = async (id_libro) => {
    const { error } = await supabase
        .from('libros')
        .delete()
        .eq('id_libro', id_libro)
    
    return error ? 
        { success: false, error: error.message } : 
        { success: true, message: "Libro eliminado" }
}
