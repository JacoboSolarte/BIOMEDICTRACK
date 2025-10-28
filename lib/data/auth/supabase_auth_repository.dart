import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/auth/auth_repository.dart';
import '../../domain/auth/user_profile.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;
  SupabaseAuthRepository(this._client);

  @override
  Future<UserProfile> signUpAdmin(String email, String password) async {
    final res = await _client.auth.signUp(email: email, password: password);
    final uid = res.user?.id;
    // Si Supabase requiere confirmación de correo, user puede ser null y la sesión no existe.
    if (uid == null) {
      throw Exception(
          'Registro iniciado. Revisa tu correo y confirma tu cuenta para continuar.');
    }
    // El perfil se crea mejor con un trigger en BD; no lo upsertamos aquí.
    return UserProfile(
      id: uid,
      email: res.user?.email,
      role: 'admin',
    );
  }

  @override
  Future<UserProfile> signInAdmin(String email, String password) async {
    final res = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final uid = res.user?.id;
    if (uid == null) {
      throw Exception('No se pudo iniciar sesión');
    }
    final profile = await _client
        .from('profiles')
        .select('id, email, role')
        .eq('id', uid)
        .maybeSingle();

    final role = profile?['role'] as String?;
    if (role != 'admin') {
      await _client.auth.signOut();
      throw Exception('Tu cuenta no tiene rol de administrador');
    }

    return UserProfile(
      id: uid,
      email: res.user?.email,
      role: role!,
    );
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<UserProfile?> getCurrentUserWithProfile() async {
    final user = _client.auth.currentUser;
    final uid = user?.id;
    if (uid == null) return null;
    final profile = await _client
        .from('profiles')
        .select('id, email, role')
        .eq('id', uid)
        .maybeSingle();
    if (profile == null) return null;
    return UserProfile.fromMap({
      'id': uid,
      'email': user?.email,
      'role': profile['role'],
    });
  }
}