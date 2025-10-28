import 'package:flutter/material.dart';
import '../../domain/equipment/equipment_repository.dart';
import '../../domain/equipment/equipment.dart';

class AdminHomePage extends StatefulWidget {
  final EquipmentRepository equipmentRepository;
  const AdminHomePage({super.key, required this.equipmentRepository});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late Future<List<Equipment>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.equipmentRepository.fetchAll();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = widget.equipmentRepository.fetchAll();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipos Biomédicos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/auth', (route) => false);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Equipment>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error al cargar equipos: ${snapshot.error}'),
                ),
              );
            }
            final items = snapshot.data ?? const [];
            if (items.isEmpty) {
              return const Center(
                child: Text('No hay equipos registrados'),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final eq = items[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.medical_services, color: Colors.teal),
                    title: Text(eq.name),
                    subtitle: Text([
                      if (eq.brand != null) eq.brand!,
                      if (eq.model != null) 'Modelo: ${eq.model!}',
                      if (eq.serial != null) 'Serie: ${eq.serial!}',
                      if (eq.location != null) 'Ubicación: ${eq.location!}',
                    ].join(' · ')),
                    trailing: eq.status != null
                        ? Chip(
                            label: Text(eq.status!),
                            backgroundColor: Colors.teal.shade50,
                          )
                        : null,
                    onTap: () {
                      // Aquí luego podemos navegar al detalle de la hoja de vida del equipo
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}