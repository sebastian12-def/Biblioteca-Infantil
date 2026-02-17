import { getAllBooks, getBookById, searchBooks } from '../services/booksService.js'
import { getEjemplaresByLibro, getEjemplaresConteo } from '../services/ejemplarService.js'

// GET /libros - Obtener todos los libros con conteo de ejemplares
export const getBooksController = async (req, res) => {
    try {
        const resultado = await getAllBooks()
        
        if (!resultado.success) {
            return res.status(500).json(resultado)
        }

        // Agregar conteo de ejemplares a cada libro
        const librosConEjemplares = await Promise.all(
            resultado.data.map(async (libro) => {
                const conteo = await getEjemplaresConteo(libro.id_libro)
                return {
                    ...libro,
                    total_ejemplares: conteo.success ? conteo.data.total : 0,
                    ejemplares_disponibles: conteo.success ? conteo.data.disponibles : 0,
                    ejemplares_prestados: conteo.success ? conteo.data.prestados : 0
                }
            })
        )

        res.status(200).json({
            success: true,
            message: "Libros obtenidos exitosamente",
            cantidad: librosConEjemplares.length,
            data: librosConEjemplares
        })
    } catch (error) {
        res.status(500).json({
            success: false,
            error: error.message
        })
    }
}

// GET /libros/:id - Obtener un libro por ID con sus ejemplares
export const getBookByIdController = async (req, res) => {
    const { id } = req.params

    try {
        const resultado = await getBookById(id)
        
        if (!resultado.success) {
            return res.status(404).json({
                success: false,
                message: "Libro no encontrado"
            })
        }

        // Obtener ejemplares del libro
        const ejemplaresResult = await getEjemplaresByLibro(id)
        const conteo = await getEjemplaresConteo(id)

        res.status(200).json({
            success: true,
            data: {
                ...resultado.data,
                total_ejemplares: conteo.success ? conteo.data.total : 0,
                ejemplares_disponibles: conteo.success ? conteo.data.disponibles : 0,
                ejemplares_prestados: conteo.success ? conteo.data.prestados : 0,
                ejemplares: ejemplaresResult.success ? ejemplaresResult.data : []
            }
        })
    } catch (error) {
        res.status(500).json({
            success: false,
            error: error.message
        })
    }
}

// GET /libros/buscar?q=termino - Buscar libros
export const searchBooksController = async (req, res) => {
    const { q } = req.query

    if (!q || q.trim() === '') {
        return res.status(400).json({
            success: false,
            message: "Parámetro de búsqueda requerido"
        })
    }

    try {
        const resultado = await searchBooks(q)
        
        if (!resultado.success) {
            return res.status(500).json(resultado)
        }

        res.status(200).json({
            success: true,
            cantidad: resultado.data.length,
            data: resultado.data
        })
    } catch (error) {
        res.status(500).json({
            success: false,
            error: error.message
        })
    }
}

// GET /libros/:id/ejemplares - Obtener ejemplares de un libro
export const getEjemplaresLibroController = async (req, res) => {
    const { id } = req.params

    try {
        const ejemplaresResult = await getEjemplaresByLibro(id)
        const conteo = await getEjemplaresConteo(id)

        if (!ejemplaresResult.success) {
            return res.status(500).json(ejemplaresResult)
        }

        res.status(200).json({
            success: true,
            id_libro: id,
            total: conteo.success ? conteo.data.total : 0,
            disponibles: conteo.success ? conteo.data.disponibles : 0,
            prestados: conteo.success ? conteo.data.prestados : 0,
            ejemplares: ejemplaresResult.data
        })
    } catch (error) {
        res.status(500).json({
            success: false,
            error: error.message
        })
    }
}
