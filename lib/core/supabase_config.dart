// Autor: Davi de Assis Fabricio
abstract final class SupabaseConfig {
  // Valores reais são passados no flutter run, sem entrar no ZIP.
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://sfzqbcmujgzchvejopue.supabase.co',
  );
  static const anonKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_VD0IDq0WUQ3LysDR8qraLg_scTXE3IM',
  );

  static bool get isConfigured =>
      !url.contains('focusquest') &&
      anonKey != 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNmenFiY211amd6Y2h2ZWpvcHVlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI5ODU4MDEsImV4cCI6MjEwODU2MTgwMX0.N-9u49XCIuRujwuql1Uvfem0O24oBWBk8PlUIn325UQ';
}
