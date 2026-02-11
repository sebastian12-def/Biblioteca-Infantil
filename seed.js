import { supabase } from "./Backend/src/config/supabase.js"

const libros = [
    {
        titulo: "El Principito",
        autor: "Antoine de Saint-Exupéry",
        isbn: "978-84-206-7751-3",
        editorial: "Salamandra",
        año_publicacion: 1943,
        descripcion: "Una novela poética sobre un príncipe que viaja por el universo",
        cantidad_total: 5,
        cantidad_disponible: 5,
        categoria: "Infantil",
        imagen_url: "https://via.placeholder.com/150?text=El+Principito"
    },
    {
        titulo: "Harry Potter y la Piedra Filosofal",
        autor: "J.K. Rowling",
        isbn: "978-84-206-5959-6",
        editorial: "Salamandra",
        año_publicacion: 1997,
        descripcion: "Un joven mago descubre su verdadera identidad",
        cantidad_total: 3,
        cantidad_disponible: 3,
        categoria: "Fantasía",
        imagen_url: "https://via.placeholder.com/150?text=Harry+Potter"
    },
    {
        titulo: "Cien años de soledad",
        autor: "Gabriel García Márquez",
        isbn: "978-84-206-7070-0",
        editorial: "Sudamericana",
        año_publicacion: 1967,
        descripcion: "La historia de la familia Buendía en el pueblo de Macondo",
        cantidad_total: 2,
        cantidad_disponible: 2,
        categoria: "Realismo Mágico",
        imagen_url: "https://via.placeholder.com/150?text=Cien+años"
    },
    {
        titulo: "El Quijote",
        autor: "Miguel de Cervantes",
        isbn: "978-84-206-7840-4",
        editorial: "Ediciones Siglo XXI",
        año_publicacion: 1605,
        descripcion: "Las aventuras de un hidalgo ingeniero y su escudero",
        cantidad_total: 4,
        cantidad_disponible: 4,
        categoria: "Novela",
        imagen_url: "https://via.placeholder.com/150?text=El+Quijote"
    },
    {
        titulo: "Percy Jackson y los Dioses del Olimpo",
        autor: "Rick Riordan",
        isbn: "978-84-206-6341-8",
        editorial: "Salamandra",
        año_publicacion: 2005,
        descripcion: "Un chico descubre que es hijo de un dios griego",
        cantidad_total: 6,
        cantidad_disponible: 6,
        categoria: "Aventura",
        imagen_url: "https://via.placeholder.com/150?text=Percy+Jackson"
    }
]

async function seed() {
    try {
        console.log("📚 Verificando libros existentes en la BD...")

        // Verificar si ya hay libros
        const { data: librosExistentes, error: errorVerify } = await supabase
            .from('libros')
            .select('*')

        if (errorVerify) {
            console.error(" Error al verificar libros:", errorVerify.message)
            process.exit(1)
        }

        if (librosExistentes.length > 0) {
            console.log(` Hay ${librosExistentes.length} libros en la BD:\n`)
            librosExistentes.forEach((libro, index) => {
                console.log(`  ${index + 1}. ${libro.titulo}`)
                console.log(`     ID: ${libro.id_libro}`)
                console.log(`     Disponibles: ${libro.cantidad_disponible}/${libro.cantidad_total}`)
            })
            console.log("\n💡 Tip: Usa estos IDs para probar GET /libros/:id")
            process.exit(0)
        }

        console.log("🌱 No hay libros. Insertando datos de prueba...")

        const { data, error } = await supabase
            .from('libros')
            .insert(libros)
            .select()

        if (error) {
            console.error(" Error al insertar libros:", error.message)
            process.exit(1)
        }

        console.log(`\n Se insertaron ${data.length} libros correctamente\n`)
        data.forEach((libro, index) => {
            console.log(`  ${index + 1}. ${libro.titulo}`)
            console.log(`     ID: ${libro.id_libro}`)
            console.log(`     Disponibles: ${libro.cantidad_disponible}/${libro.cantidad_total}`)
        })
        console.log("\n💡 Tip: Usa estos IDs para probar GET /libros/:id")

        process.exit(0)
    } catch (error) {
        console.error(" Error general:", error.message)
        process.exit(1)
    }
}

seed()
