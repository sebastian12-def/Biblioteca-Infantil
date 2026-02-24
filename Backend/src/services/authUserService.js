import { supabase } from "../config/supabase.js"

export const registerUser = async (userData) => {
    const { data, error } = await supabase
        .from('usuarios')
        .insert([userData])
        .select()

    if (error) {
        return {
            success: false,
            error: error.message
        }
    }

    return { success: true, data: data[0] }
}

export const checkDocumentExists = async (documento) => {
    const { data, error } = await supabase
        .from('usuarios')
        .select('id_usuario')
        .eq('documento', documento)
        .single()

    if (error) {
        // PGRST116 = no rows found
        if (error.code === 'PGRST116') {
            return { success: true, exists: false }
        }

        return {
            success: false,
            error: error.message
        }
    }

    return { success: true, exists: !!data }
}

export const getUserByDocumento = async (documento) => {
    const { data, error } = await supabase
        .from('usuarios')
        .select('*')
        .eq('documento', documento)
        .single();

    if (error) {
        return {
            success: false,
            error: error.message
        }
    }

    return { success: true, data: data }
}
