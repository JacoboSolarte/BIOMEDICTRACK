import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/equipment/equipment.dart';
import '../../domain/equipment/equipment_repository.dart';

class SupabaseEquipmentRepository implements EquipmentRepository {
  final SupabaseClient _client;
  SupabaseEquipmentRepository(this._client);

  @override
  Future<List<Equipment>> fetchAll() async {
    final rows = await _client
        .from('equipment')
        .select('id, name, brand, model, serial, location, status')
        .order('created_at', ascending: false);
    return (rows as List<dynamic>)
        .map((e) => Equipment.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}