import 'user_profile.dart';

abstract class AuthRepository {
  Future<UserProfile> signUpAdmin(String email, String password);
  Future<UserProfile> signInAdmin(String email, String password);
  Future<void> signOut();
  Future<UserProfile?> getCurrentUserWithProfile();
}