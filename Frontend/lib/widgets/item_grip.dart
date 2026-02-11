import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../data/datos_simulados.dart';
import '../views/libros/libro_detalle.dart';

class ItemsGrid extends StatelessWidget {
  final String filtro;
  final String busqueda;

  const ItemsGrid({super.key, this.filtro = 'Todos', this.busqueda = ''});

  @override
  Widget build(BuildContext context) {
    List<Libro> librosFiltrados = librosSimulados.where((libro) {
      if (busqueda.isNotEmpty) {
        final query = busqueda.toLowerCase();
        if (!libro.titulo.toLowerCase().contains(query) &&
            !libro.autor.toLowerCase().contains(query) &&
            !libro.area.toLowerCase().contains(query)) {
          return false;
        }
      }

      if (filtro == 'Disponibles') return libro.disponibles > 0;
      if (filtro == 'Prestados') return libro.disponibles == 0;
      if (filtro == 'Reservados') return libro.disponibles < libro.totalEjemplares;
      return true;
    }).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: librosFiltrados.length,
      itemBuilder: (context, index) {
        return _buildBookCard(context, librosFiltrados[index]);
      },
    );
  }

  Widget _buildBookCard(BuildContext context, Libro libro) {
    return Card(
      color: const Color(0xFF27272A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: libro.imagen.startsWith('http')
                      ? NetworkImage(libro.imagen)
                      : AssetImage(libro.imagen) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            libro.area,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: libro.disponibles > 0
                                  ? Colors.green.withValues(alpha: 0.3)
                                  : Colors.red.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${libro.disponibles}/${libro.totalEjemplares}',
                              style: TextStyle(
                                color: libro.disponibles > 0 ? Colors.green[300] : Colors.red[300],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  libro.titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  libro.autor,
                  style: const TextStyle(
                    color: Color(0xFFA1A1AA),
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LibroDetallePage(libro: libro),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC026D3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Ver Detalles'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
