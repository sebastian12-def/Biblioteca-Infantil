import 'package:flutter/material.dart';
import '../../models/prestamo.dart';
import '../../data/datos_simulados.dart';

class MisPrestamosPage extends StatefulWidget {
  const MisPrestamosPage({super.key});

  @override
  State<MisPrestamosPage> createState() => _MisPrestamosPageState();
}

class _MisPrestamosPageState extends State<MisPrestamosPage> {
  @override
  Widget build(BuildContext context) {
    final activos = prestamosSimulados.where((p) => p.activo).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF18181B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181B),
        title: const Text('Préstamos Activos'),
        foregroundColor: Colors.white,
      ),
      body: activos.isEmpty
          ? const Center(
              child: Text(
                'No hay préstamos activos',
                style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activos.length,
              itemBuilder: (context, index) {
                final prestamo = activos[index];
                return _buildPrestamoCard(prestamo);
              },
            ),
    );
  }

  Widget _buildPrestamoCard(Prestamo prestamo) {
    final diasPrestamo = DateTime.now().difference(prestamo.fechaPrestamo).inDays;

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
                  prestamo.libro.titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Usuario: ${prestamo.nombreUsuario}',
                  style: const TextStyle(color: Color(0xFFA1A1AA)),
                ),
                Text(
                  'Ejemplar: ${prestamo.ejemplar.id}',
                  style: const TextStyle(color: Color(0xFFA1A1AA)),
                ),
                Text(
                  'Días prestado: $diasPrestamo',
                  style: TextStyle(
                    color: diasPrestamo > 7 ? Colors.red[300] : Colors.green[300],
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _mostrarDialogoDevolucion(prestamo),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC026D3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Registrar Devolución'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoDevolucion(Prestamo prestamo) {
    String condicion = 'Bueno';
    final observacionesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF27272A),
              title: const Text(
                'Registrar Devolución',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Libro: ${prestamo.libro.titulo}',
                    style: const TextStyle(color: Color(0xFFA1A1AA)),
                  ),
                  Text(
                    'Ejemplar: ${prestamo.ejemplar.id}',
                    style: const TextStyle(color: Color(0xFFA1A1AA)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Condición de devolución:',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: condicion,
                    dropdownColor: const Color(0xFF27272A),
                    style: const TextStyle(color: Colors.white),
                    items: ['Bueno', 'Regular', 'Malo'].map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        condicion = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Observaciones:',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: observacionesController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Escriba observaciones...',
                      hintStyle: const TextStyle(color: Color(0xFF71717A)),
                      filled: true,
                      fillColor: const Color(0xFF18181B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Color(0xFFA1A1AA))),
                ),
                ElevatedButton(
                  onPressed: () {
                    _registrarDevolucion(prestamo, condicion, observacionesController.text);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC026D3),
                  ),
                  child: const Text('Confirmar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _registrarDevolucion(Prestamo prestamo, String condicion, String observaciones) {
    setState(() {
      prestamo.activo = false;
      prestamo.condicionDevolucion = condicion;
      prestamo.observaciones = observaciones;
      prestamo.ejemplar.disponible = true;
      prestamo.ejemplar.condicion = condicion;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Devolución registrada: "${prestamo.libro.titulo}"'),
        backgroundColor: Colors.green[700],
      ),
    );
  }
}
