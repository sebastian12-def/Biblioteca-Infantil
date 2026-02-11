import 'package:flutter/material.dart';
import '../widgets/sidebar_left.dart';
import '../widgets/header.dart';
import '../widgets/content_section.dart';
import '../widgets/item_grip.dart';
import '../widgets/sidebar_right.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _filtroActivo = 'Todos';
  String _busqueda = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF18181B),
      body: Row(
        children: [
          const SidebarLeft(),
          Expanded(
            child: Column(
              children: [
                Header(
                  onBusqueda: (valor) {
                    setState(() {
                      _busqueda = valor;
                    });
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ContentSection(
                          filtroActivo: _filtroActivo,
                          onFiltroChanged: (filtro) {
                            setState(() {
                              _filtroActivo = filtro;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: ItemsGrid(
                            filtro: _filtroActivo,
                            busqueda: _busqueda,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          MediaQuery.of(context).size.width > 1200
              ? const SidebarRight()
              : Container(),
        ],
      ),
    );
  }
}
