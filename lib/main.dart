import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/auth/supabase_auth_repository.dart';
import 'data/equipment/supabase_equipment_repository.dart';
import 'domain/equipment/equipment_repository.dart';
import 'presentation/auth/auth_page.dart';
import 'presentation/admin/admin_home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = SupabaseAuthRepository(Supabase.instance.client);
    final EquipmentRepository equipmentRepo =
        SupabaseEquipmentRepository(Supabase.instance.client);
    return MaterialApp(
      title: 'BiomedicTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF7F9FC),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDFE3E8)),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      initialRoute: '/auth',
      routes: {
        '/auth': (_) => AuthPage(authRepository: authRepo),
        '/admin': (_) => AdminHomePage(equipmentRepository: equipmentRepo),
      },
    );
  }
}
