import aplicacion from './index.js'; // Cambiado de 'app' a 'aplicacion'
import 'dotenv/config';

const PORT = process.env.PORT || 5000;

// Usamos 'aplicacion' que es el nombre que viene del export de index.js
aplicacion.listen(PORT, () => {
    console.log(`✔ Servidor corriendo en http://localhost:${PORT}`);
    console.log(`✔ Entorno: ${process.env.NODE_ENV || 'development'}`);
    console.log(`✔ Listo para recibir peticiones`);
});