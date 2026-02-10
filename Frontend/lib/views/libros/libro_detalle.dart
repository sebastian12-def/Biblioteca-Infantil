import 'package:flutter/material.dart';
import '../../models/libro.dart';
import '../../models/ejemplar.dart';
import '../../models/solicitud.dart';
import '../../data/datos_simulados.dart';

class LibroDetallePage extends StatefulWidget {
  final Libro libro;

  const LibroDetallePage({super.key, required this.libro});

  @override
  State<LibroDetallePage> createState() => _LibroDetallePageState();
}

class _LibroDetallePageState extends State<LibroDetallePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF18181B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181B),
        title: Text(widget.libro.titulo),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 200,
                    height: 280,
                    child: widget.libro.imagen.startsWith('http')
                        ? Image.network(widget.libro.imagen, fit: BoxFit.cover)
                        : Image.asset(widget.libro.imagen, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.libro.titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Autor: ${widget.libro.autor}',
                        style: const TextStyle(color: Color(0xFFA1A1AA), fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Área: ${widget.libro.area}',
                        style: const TextStyle(color: Color(0xFFA1A1AA), fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.libro.disponibles > 0
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${widget.libro.disponibles} de ${widget.libro.totalEjemplares} disponibles',
                          style: TextStyle(
                            color: widget.libro.disponibles > 0 ? Colors.green[300] : Colors.red[300],
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.libro.ejemplares.length,
              itemBuilder: (context, index) {
                final ejemplar = widget.libro.ejemplares[index];
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
                                'Ejemplar ${ejemplar.id}',
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
                              onPressed: () => _solicitarEjemplar(ejemplar),
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

  void _solicitarEjemplar(Ejemplar ejemplar) {
    final solicitud = Solicitud(
      id: 'S${DateTime.now().millisecondsSinceEpoch}',
      nombreUsuario: 'Usuario Actual',
      libro: widget.libro,
      ejemplar: ejemplar,
    );
    solicitudesSimuladas.add(solicitud);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Solicitud enviada para "${widget.libro.titulo}" - Ejemplar ${ejemplar.id}'),
        backgroundColor: const Color(0xFFC026D3),
      ),
    );
    setState(() {});
  }
}
