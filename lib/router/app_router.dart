// Autor: Davi de Assis Fabricio
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/mission.dart';
import '../screens/achievements_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/mission_detail_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/ranking_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/splash_screen.dart';
import '../widgets/app_shell.dart';

class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(SupabaseClient client) {
    _subscription = client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  AppRouter(this._client) {
    _refresh = _AuthRefresh(_client);
    router = GoRouter(
      initialLocation: '/splash',
      refreshListenable: _refresh,
      redirect: (context, state) {
        final path = state.uri.path;
        if (path == '/splash') return null;
        final signedIn = _client.auth.currentSession != null;
        final isAuthPage = path == '/login' || path == '/signup';
        if (!signedIn && !isAuthPage) return '/login';
        if (signedIn && isAuthPage) return '/home';
        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => AppShell(
            currentPath: state.uri.path,
            child: child,
          ),
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'mission/:id',
                  builder: (context, state) {
                    final id = int.tryParse(state.pathParameters['id'] ?? '');
                    if (id == null) {
                      return const Scaffold(
                        body: Center(child: Text('Missão inválida.')),
                      );
                    }
                    return MissionDetailScreen(
                      missionId: id,
                      selectedMission: state.extra is Mission
                          ? state.extra! as Mission
                          : null,
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/achievements',
              builder: (context, state) => const AchievementsScreen(),
            ),
            GoRoute(
              path: '/ranking',
              builder: (context, state) => const RankingScreen(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    );
  }

  final SupabaseClient _client;
  late final _AuthRefresh _refresh;
  late final GoRouter router;

  void dispose() {
    router.dispose();
    _refresh.dispose();
  }
}
