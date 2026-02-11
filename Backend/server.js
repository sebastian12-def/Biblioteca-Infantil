import app from  './index.js'

import 'dotenv/config';


const PORT  = process.env.PORT || 5000;


app.listen(PORT, ()=>{
    console.log(`✓ Servidor corriendo en http://localhost:${PORT}`);
    console.log(`✓ Entorno: ${process.env.NODE_ENV || 'development'}`);
    console.log(`✓ Listo para recibir peticiones`);
    
})