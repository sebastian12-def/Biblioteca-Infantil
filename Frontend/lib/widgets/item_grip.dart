import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../services/libro_service.dart';
import '../views/libros/libro_detalle.dart';

class ItemsGrid extends StatefulWidget {
  final String filtro;
  final String busqueda;

  const ItemsGrid({super.key, this.filtro = 'Todos', this.busqueda = ''});

  @override
  State<ItemsGrid> createState() => _ItemsGridState();
}

class _ItemsGridState extends State<ItemsGrid> {
  List<Libro> _libros = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarLibros();
  }

  @override
  void didUpdateWidget(ItemsGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambió la búsqueda, recargar
    if (oldWidget.busqueda != widget.busqueda) {
      _cargarLibros();
    }
  }

  Future<void> _cargarLibros() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      List<Libro> libros;
      if (widget.busqueda.isNotEmpty) {
        libros = await LibroService.buscarLibros(widget.busqueda);
      } else {
        libros = await LibroService.getLibros();
      }
      
      setState(() {
        _libros = libros;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar libros: $e';
        _isLoading = false;
      });
    }
  }

  List<Libro> _aplicarFiltro(List<Libro> libros) {
    return libros.where((libro) {
      if (widget.filtro == 'Disponibles') return libro.disponibles > 0;
      if (widget.filtro == 'Prestados') return libro.disponibles == 0;
      if (widget.filtro == 'Reservados') return libro.disponibles < libro.totalEjemplares;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: Colors.blueAccent),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _cargarLibros,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final librosFiltrados = _aplicarFiltro(_libros);

    if (librosFiltrados.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(Icons.library_books, color: Color(0xFFA1A1AA), size: 48),
              SizedBox(height: 16),
              Text(
                'No se encontraron libros',
                style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

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
                    onPressed: () async {
                      // Navega a detalles y espera el resultado
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LibroDetallePage(libro: libro),
                        ),
                      );
                      // Al volver, refresca la grilla para mostrar disponibilidad real
                      if (mounted) {
                        _cargarLibros();
                      }
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
