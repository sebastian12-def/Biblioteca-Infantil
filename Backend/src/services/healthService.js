import { supabase } from "../config/supabase.js";

// creo una request a supabase => Es la forma de saber si esta comunicadose o no

export const checkSupabaseConection = async () =>{
    // const {error} = await supabase
    // .from('usuarios')
    // .select('id')
    // .limit(1)

     // Solo verifica la conexión sin depender de datos
    const { error } = await supabase
    .from('usuarios')
    .select('count', { count: 'exact', head: true });  // ← Cuenta, no trae datos


    // manejo de repuesta de supabse
    if(error){
        throw new Error ("Supabase no disponible");
    }

    // si no hay error entonces esta(con conctadose)
    return true;
}