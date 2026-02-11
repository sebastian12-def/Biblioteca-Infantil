// lib/widgets/sidebar_right.dart
import 'package:flutter/material.dart';

class SidebarRight extends StatelessWidget {
  const SidebarRight({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 288, // w-72
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF18181B), // bg-zinc-900
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Usuarios Activos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Lista de usuarios
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildUserCard(index);
              },
            ),
          ),
          
          // Tarjeta promocional
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFC026D3), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Renueva tu préstamo online',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Puedes renovar tus préstamos de forma fácil y rápida desde la app',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(Colors.white),
                    ),
                    child: Text(
                      'Renovar Ahora',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(int index) {
    final usuarios = [
      {'nombre': 'Ana Pérez', 'email': '@ana', 'avatar': 'https://assets.codepen.io/3685267/nft-dashboard-pro-1.jpg'},
      {'nombre': 'Carlos Gómez', 'email': '@carlos', 'avatar': 'https://assets.codepen.io/3685267/nft-dashboard-pro-2.jpg'},
      {'nombre': 'María López', 'email': '@maria', 'avatar': 'https://assets.codepen.io/3685267/nft-dashboard-pro-3.jpg'},
    ];
    
    final usuario = usuarios[index % usuarios.length];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF27272A), // bg-zinc-800
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(usuario['avatar']!),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                usuario['nombre']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                usuario['email']!,
                style: const TextStyle(
                  color: Color(0xFFA1A1AA), // text-zinc-400
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}