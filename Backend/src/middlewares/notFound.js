// MIDDLEWARE 404 => ruta no encontrada

// Un middleware que se ejecuta SOLO si ninguna otra ruta coincidió
// Responde: "No existe ese endpoint"

export const notFoundHandler = (req, res) => {
    res.status(404).json({
        success: false,
        message: "Ruta no encontrada",
        path: req.originalUrl,
        method: req.method,
        timestamp: new Date().toISOString()
    });
};