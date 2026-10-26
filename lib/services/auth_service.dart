// Autor: Davi de Assis Fabricio
import 'package:supabase_flutter/supabase_flutter.dart';

// Converte erros comuns do Supabase em mensagens claras para o aluno.
String authErrorMessage(AuthException error) {
  final message = error.message.toLowerCase();
  if (message.contains('invalid login credentials')) {
    return 'E-mail ou senha incorretos.';
  }
  if (message.contains('email not confirmed')) {
    return 'Confirme seu e-mail antes de entrar.';
  }
  if (message.contains('already registered')) {
    return 'Este e-mail já está cadastrado.';
  }
  if (message.contains('password')) {
    return 'A senha não atende aos requisitos do cadastro.';
  }
  return error.message;
}

class AuthService {
  AuthService(this._client);

  final SupabaseClient _client;

  Future<void> signIn(String email, String password) async {
    await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<bool> signUp(
    String nickname,
    String email,
    String password,
  ) async {
    final response = await _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'nickname': nickname.trim()},
    );
    // Com confirmação de e-mail habilitada, a sessão pode vir nula.
    return response.session != null;
  }

  Future<void> signOut() => _client.auth.signOut();
}
