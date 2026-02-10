import express from "express"
import { 
    getBooksController, 
    getBookByIdController, 
    searchBooksController 
} from '../controllers/books.controller.js'

const router = express.Router()

// GET /libros - Obtener todos los libros
router.get('/', getBooksController)

// GET /libros/buscar?q=termino - Buscar libros (ANTES de /:id)
router.get('/buscar', searchBooksController)

// GET /libros/:id - Obtener un libro por ID
router.get('/:id', getBookByIdController)

export default router
