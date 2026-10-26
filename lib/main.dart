// Autor: Davi de Assis Fabricio
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_theme.dart';
import 'core/supabase_config.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!SupabaseConfig.isConfigured) {
    runApp(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Configure SUPABASE_URL e SUPABASE_PUBLISHABLE_KEY '
              'com --dart-define para iniciar o FocusQuest.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ));
    return;
  }
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  runApp(const FocusQuestApp());
}

class FocusQuestApp extends StatefulWidget {
  const FocusQuestApp({super.key});

  @override
  State<FocusQuestApp> createState() => _FocusQuestAppState();
}

class _FocusQuestAppState extends State<FocusQuestApp> {
  late final appRouter = AppRouter(Supabase.instance.client);

  @override
  void dispose() {
    appRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'FocusQuest',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: appRouter.router,
      );
}
