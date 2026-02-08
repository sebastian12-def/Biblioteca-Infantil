import e from "express";

// importo la fn que hacec el checjk de conexion a supabase
import { checkSupabaseConection } from "../services/healthService.js";

const router = e.Router();


router.get("/", async(req, res)=>{
    try{
        await checkSupabaseConection(); //si salio mal salta al catch
        console.log("Conectado a supabase correctamente..."); 
        

        res.status(200).json({
            success: true,
            message: 'Servidor de express corriendo correctamente',
            
            status : "OK",
            server: 'up',
            db: "Connected"
        })
        
    }
    catch(error){
            console.error("Error al conectar al supabase");
            res.status(500).json({
                status: 'error',
                db: 'down'
            })
        }
})


export default router