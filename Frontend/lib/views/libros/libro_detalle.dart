import 'package:flutter/material.dart';
import '../../models/libro.dart';
import '../../models/ejemplar.dart';
import '../../services/libro_service.dart';
import '../../services/prestamo_service.dart';

class LibroDetallePage extends StatefulWidget {
  final Libro libro;

  const LibroDetallePage({super.key, required this.libro});

  @override
  State<LibroDetallePage> createState() => _LibroDetallePageState();
}

class _LibroDetallePageState extends State<LibroDetallePage> {
  Libro? _libroCompleto;
  List<Ejemplar> _ejemplares = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarDetalles();
  }

  Future<void> _cargarDetalles() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Cargar libro con detalles completos y ejemplares
      final libro = await LibroService.getLibroById(widget.libro.id);
      
      if (libro != null) {
        setState(() {
          _libroCompleto = libro;
          _ejemplares = libro.ejemplares;
          _isLoading = false;
        });
      } else {
        // Si no se puede cargar de la API, usar datos pasados
        final ejemplares = await LibroService.getEjemplares(widget.libro.id);
        setState(() {
          _libroCompleto = widget.libro;
          _ejemplares = ejemplares;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error al cargar detalles: $e';
        _isLoading = false;
        _libroCompleto = widget.libro;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final libro = _libroCompleto ?? widget.libro;

    return Scaffold(
      backgroundColor: const Color(0xFF18181B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181B),
        title: Text(libro.titulo),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_error != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.orange),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_error!, style: const TextStyle(color: Colors.orange))),
                        ],
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 200,
                          height: 280,
                          child: libro.imagen.startsWith('http')
                              ? Image.network(
                                  libro.imagen,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: const Color(0xFF27272A),
                                    child: const Icon(Icons.book, size: 80, color: Color(0xFFA1A1AA)),
                                  ),
                                )
                              : Image.asset(libro.imagen, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              libro.titulo,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Autor: ${libro.autor}',
                              style: const TextStyle(color: Color(0xFFA1A1AA), fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Área: ${libro.area}',
                              style: const TextStyle(color: Color(0xFFA1A1AA), fontSize: 16),
                            ),
                            if (libro.anioPublicacion > 0) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Año: ${libro.anioPublicacion}',
                                style: const TextStyle(color: Color(0xFFA1A1AA), fontSize: 16),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: libro.disponibles > 0
                                    ? Colors.green.withValues(alpha: 0.2)
                                    : Colors.red.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${libro.disponibles} de ${libro.totalEjemplares} disponibles',
                                style: TextStyle(
                                  color: libro.disponibles > 0 ? Colors.green[300] : Colors.red[300],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Ejemplares',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ejemplares.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF27272A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Column(
                              children: [
                                Icon(Icons.inventory_2_outlined, color: Color(0xFFA1A1AA), size: 48),
                                SizedBox(height: 12),
                                Text(
                                  'No hay ejemplares registrados',
                                  style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _ejemplares.length,
                          itemBuilder: (context, index) {
                            final ejemplar = _ejemplares[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF27272A),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.book,
                                        color: ejemplar.disponible ? Colors.green[300] : Colors.red[300],
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ejemplar.codigoInventario.isNotEmpty
                                                ? ejemplar.codigoInventario
                                                : 'Ejemplar ${index + 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Condición: ${ejemplar.condicion}',
                                            style: const TextStyle(color: Color(0xFFA1A1AA)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: ejemplar.disponible
                                              ? Colors.green.withValues(alpha: 0.2)
                                              : Colors.red.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          ejemplar.disponible ? 'Disponible' : 'Prestado',
                                          style: TextStyle(
                                            color: ejemplar.disponible ? Colors.green[300] : Colors.red[300],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (ejemplar.disponible)
                                        ElevatedButton(
                                          onPressed: () => _solicitarPrestamo(ejemplar),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFC026D3),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Solicitar'),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }

  Future<void> _solicitarPrestamo(Ejemplar ejemplar) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF27272A),
        title: const Text('Confirmar Préstamo', style: TextStyle(color: Colors.white)),
        content: Text(
          '¿Desea solicitar el préstamo de "${_libroCompleto?.titulo ?? widget.libro.titulo}"?',
          style: const TextStyle(color: Color(0xFFA1A1AA)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC026D3)),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      final libro = _libroCompleto ?? widget.libro;
      final resultado = await PrestamoService.solicitarPrestamo(
        ejemplar.id,
        idLibro: libro.id,
      );
      
      if (resultado['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Préstamo solicitado: ${resultado['message'] ?? 'Éxito'}'),
              backgroundColor: Colors.green,
            ),
          );
          _cargarDetalles(); // Recargar para actualizar disponibilidad
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${resultado['error'] ?? resultado['message'] ?? 'Error desconocido'}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al solicitar préstamo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
