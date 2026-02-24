import 'package:flutter/material.dart';
import '../../models/prestamo.dart';
import '../../services/prestamo_service.dart';

class MisPrestamosPage extends StatefulWidget {
  const MisPrestamosPage({super.key});

  @override
  State<MisPrestamosPage> createState() => _MisPrestamosPageState();
}

class _MisPrestamosPageState extends State<MisPrestamosPage> {
  List<Prestamo> _prestamos = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarPrestamos();
  }

  Future<void> _cargarPrestamos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prestamos = await PrestamoService.getMisPrestamos();
      setState(() {
        _prestamos = prestamos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar préstamos: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _devolverPrestamo(Prestamo prestamo) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF27272A),
        title: const Text('Devolver libro', style: TextStyle(color: Colors.white)),
        content: Text(
          '¿Seguro que quieres devolver este libro? El ejemplar quedará disponible para otros usuarios.',
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
            child: const Text('Devolver'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      final result = await PrestamoService.devolverPrestamo(
        prestamo.id,
      );
      if (result['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Libro devuelto correctamente'),
              backgroundColor: Colors.green,
            ),
          );
          _cargarPrestamos();
          // Notifica al dashboard que hubo devolución
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['error'] ?? 'No se pudo devolver el libro'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al devolver: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activos = _prestamos.where((p) => p.activo).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF18181B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181B),
        title: const Text('Mis Préstamos'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarPrestamos,
          ),
        ],
      ),
      body: _buildBody(activos),
    );
  }

  Widget _buildBody(List<Prestamo> activos) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarPrestamos,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (activos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books, color: Color(0xFFA1A1AA), size: 48),
            SizedBox(height: 16),
            Text(
              'No tienes préstamos activos',
              style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 18),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activos.length,
      itemBuilder: (context, index) {
        final prestamo = activos[index];
        return _buildPrestamoCard(prestamo);
      },
    );
  }

  Widget _buildPrestamoCard(Prestamo prestamo) {
    final diasPrestamo = DateTime.now().difference(prestamo.fechaPrestamo).inDays;
    final tituloLibro = prestamo.libro?.titulo ?? 'Libro desconocido';
    final ejemplarId = prestamo.ejemplar?.id ?? 'N/A';

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
                  tituloLibro,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Estado: ${prestamo.estado}',
                  style: const TextStyle(color: Color(0xFFA1A1AA)),
                ),
                Text(
                  'Ejemplar: $ejemplarId',
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
          if (prestamo.activo)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Activo',
                    style: TextStyle(color: Colors.green[300]),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _devolverPrestamo(prestamo),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC026D3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Devolver'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
