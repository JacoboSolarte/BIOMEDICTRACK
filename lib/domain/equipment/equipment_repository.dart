import 'equipment.dart';

abstract class EquipmentRepository {
  Future<List<Equipment>> fetchAll();
}