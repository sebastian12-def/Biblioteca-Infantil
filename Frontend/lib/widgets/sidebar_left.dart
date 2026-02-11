import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../views/gestor/bandeja_solicitudes_page.dart';
import '../views/prestamos/mis_prestamos.dart';

class SidebarLeft extends StatelessWidget {
  const SidebarLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 192,
      color: const Color(0xFF18181B),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 96),
            child: Column(
              children: [
                _buildNavItem(context, Iconsax.shop, 'Biblioteca', 0, true),
                _buildNavItem(context, Iconsax.home, 'Inicio', 1),
                _buildNavItem(context, Iconsax.heart, 'Favoritos', 2),
                _buildNavItem(context, Iconsax.trend_up, 'Prestamos', 3),
                _buildNavItem(context, Iconsax.book, 'Coleccion', 4),
                _buildNavItem(context, Iconsax.document, 'Solicitudes', 5),
                _buildNavItem(context, Iconsax.setting, 'Configuracion', 6),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildNavItem(context, Iconsax.logout, 'Cerrar Sesion', 7),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index, [bool isSelected = false]) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFC026D3)
                : const Color(0xFF27272A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFA1A1AA),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          if (label == 'Solicitudes') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BandejaSolicitudesPage()),
            );
          } else if (label == 'Prestamos') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MisPrestamosPage()),
            );
          }
        },
      ),
    );
  }
}
