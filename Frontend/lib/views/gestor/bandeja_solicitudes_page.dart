import 'package:flutter/material.dart';
import '../../models/solicitud.dart';
import '../../models/prestamo.dart';
import '../../data/datos_simulados.dart';

class BandejaSolicitudesPage extends StatefulWidget {
  const BandejaSolicitudesPage({super.key});

  @override
  State<BandejaSolicitudesPage> createState() => _BandejaSolicitudesPageState();
}

class _BandejaSolicitudesPageState extends State<BandejaSolicitudesPage> {
  @override
  Widget build(BuildContext context) {
    final pendientes = solicitudesSimuladas
        .where((s) => s.estado == 'pendiente')
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF18181B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181B),
        title: const Text('Bandeja de Solicitudes'),
        foregroundColor: Colors.white,
      ),
      body: pendientes.isEmpty
          ? const Center(
              child: Text(
                'No hay solicitudes pendientes',
                style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pendientes.length,
              itemBuilder: (context, index) {
                final solicitud = pendientes[index];
                return _buildSolicitudCard(solicitud);
              },
            ),
    );
  }

  Widget _buildSolicitudCard(Solicitud solicitud) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF27272A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  solicitud.nombreUsuario,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Libro: ${solicitud.libro.titulo}',
                  style: const TextStyle(color: Color(0xFFA1A1AA)),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ejemplar: ${solicitud.ejemplar.id} (${solicitud.ejemplar.condicion})',
                  style: const TextStyle(color: Color(0xFFA1A1AA)),
                ),
              ],
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _aprobar(solicitud),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Aprobar'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _rechazar(solicitud),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Rechazar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _aprobar(Solicitud solicitud) {
    setState(() {
      solicitud.estado = 'aprobada';
      solicitud.ejemplar.disponible = false;

      prestamosSimulados.add(Prestamo(
        id: 'P${DateTime.now().millisecondsSinceEpoch}',
        nombreUsuario: solicitud.nombreUsuario,
        libro: solicitud.libro,
        ejemplar: solicitud.ejemplar,
        fechaPrestamo: DateTime.now(),
      ));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Préstamo aprobado: "${solicitud.libro.titulo}" para ${solicitud.nombreUsuario}'),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  void _rechazar(Solicitud solicitud) {
    setState(() {
      solicitud.estado = 'rechazada';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Solicitud rechazada: "${solicitud.libro.titulo}"'),
        backgroundColor: Colors.red[700],
      ),
    );
  }
}
