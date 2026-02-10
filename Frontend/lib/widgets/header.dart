import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Header extends StatelessWidget {
  final Function(String) onBusqueda;

  const Header({super.key, required this.onBusqueda});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF18181B),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC026D3), Color(0xFF7C3AED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'B',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'BIBLIOTECA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                onChanged: onBusqueda,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar por título, autor o área...',
                  hintStyle: const TextStyle(color: Color(0xFF71717A)),
                  filled: true,
                  fillColor: const Color(0xFF27272A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Iconsax.search_normal, color: Color(0xFF71717A)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Iconsax.notification, color: Colors.white),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF18181B),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://assets.codepen.io/3685267/nft-dashboard-pro-1.jpg',
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Iconsax.arrow_down, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
