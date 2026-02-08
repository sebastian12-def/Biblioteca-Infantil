// Aqui va todo lo relacionado  a la App (rutas , middleware etc...)

import express from  "express";

// ruta para health
import healthRoute from './src/routes/health.routes.js';

//  config de cors(lueugo la hago)

// middleware para la rutas no encontradas
import {notFoundHandler} from './src/middlewares/notFound.js'


const app = express() // se crea la app(instacia de express)

app.use(express.json())//para poder enviar JSON


// aqui middelware de cors (luego)


app.use('/health', healthRoute);


// manejo de errores (luego)
// si llego aqui => ninguana ruta coincidio = 404
app.use(notFoundHandler);


export default app;