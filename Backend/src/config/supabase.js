import { createClient } from '@supabase/supabase-js'
// como usare dotenv para leer las variables de entorno lo importo
import 'dotenv/config'

// lo que necesito para conectarme a supabase
const urlSupabase = process.env.SUPABASE_URL;
const key_secreta = process.env.SUPABASE_KEY;


// Validar credenciales => vemos si existen antes de crear el estudiante
if (!urlSupabase || !key_secreta) {
  console.error('❌ Falta SUPABASE_URL o SECRET_KEY');
  process.exit(1);
}


// 1. El medio para conectame a supase (la conexion)
export const supabase = createClient(urlSupabase, key_secreta);


//  Solo verificar que está configurado
console.log('✅ Credenciales de Supabase cargadas');

