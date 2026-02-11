import { getAllBooks, getBookById, searchBooks } from '../services/booksService.js'

// GET /libros - Obtener todos los libros
export const getBooksController = async (req, res) => {
    try {
        const resultado = await getAllBooks()
        
        if (!resultado.success) {
            return res.status(500).json(resultado)
        }

        res.status(200).json({
            success: true,
            message: "Libros obtenidos exitosamente",
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

// GET /libros/:id - Obtener un libro por ID
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

        res.status(200).json({
            success: true,
            data: resultado.data
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
