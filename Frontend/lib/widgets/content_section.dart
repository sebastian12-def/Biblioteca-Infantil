import 'package:flutter/material.dart';

class ContentSection extends StatelessWidget {
  final String filtroActivo;
  final Function(String) onFiltroChanged;

  const ContentSection({
    super.key,
    required this.filtroActivo,
    required this.onFiltroChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Gestiona y busca libros en la biblioteca escolar',
            style: TextStyle(
              color: Color(0xFF71717A),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: double.infinity,
            height: 176,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://assets.codepen.io/3685267/nft-dashboard-art-6.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Encuentra la mejor colección\nde libros aquí',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Explorar Ahora'),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Libros Populares',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    _buildFilterButton('Todos'),
                    _buildFilterButton('Disponibles'),
                    _buildFilterButton('Prestados'),
                    _buildFilterButton('Reservados'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    final isActive = text == filtroActivo;
    return Container(
      margin: const EdgeInsets.only(left: 12),
      child: TextButton(
        onPressed: () => onFiltroChanged(text),
        child: Text(
          text,
          style: TextStyle(
            color: isActive
                ? const Color(0xFFC026D3)
                : const Color(0xFF71717A),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
