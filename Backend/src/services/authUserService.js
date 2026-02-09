import { supabase } from "../config/supabase.js"


export const registerUser = async (userData) =>{
    const {data, error} = await supabase 
    .from('usuarios')
    .insert([userData])
    .select()

    // manejo la respuesta 
    if(error){
        return{ 
            success : false,
            error: error.message
        }
    }

    return {success: true, data: data[0]}//data[0] porque insert retorna un array
}


export const checkDocumentExists = async (documento) =>{
    const {data, error} = await supabase
    .from('usuarios')
    .select('id_usuario')
    .eq('documento', documento)
    .single()


    if(error){
        // No encontró = documento NO existe = return false
        return false
    }

    return  true
}