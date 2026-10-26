// Autor: Davi de Assis Fabricio
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/achievement.dart';
import '../models/player_profile.dart';
import '../services/auth_service.dart';
import '../services/game_service.dart';
import '../widgets/progress_card.dart';

class _ProfileData {
  const _ProfileData(this.profile, this.achievements);

  final PlayerProfile profile;
  final List<Achievement> achievements;
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final GameService _game = GameService(Supabase.instance.client);
  late Future<_ProfileData> _future;
  bool _signingOut = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_ProfileData> _load() async {
    final profile = await _game.getProfile();
    final achievements = await _game.getAchievements();
    return _ProfileData(profile, achievements);
  }

  Future<void> _reload() {
    final next = _load();
    setState(() => _future = next);
    return next.then((_) {});
  }

  Future<void> _logout() async {
    setState(() => _signingOut = true);
    try {
      await AuthService(Supabase.instance.client).signOut();
      if (mounted) context.go('/login');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível sair.')),
        );
      }
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
          actions: [
            IconButton(
              tooltip: 'Atualizar',
              icon: const Icon(Icons.refresh),
              onPressed: _reload,
            ),
          ],
        ),
        body: FutureBuilder<_ProfileData>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: FilledButton(
                  onPressed: _reload,
                  child: const Text('Erro ao carregar. Tentar novamente'),
                ),
              );
            }
            final data = snapshot.data!;
            final unlocked = data.achievements
                .where((item) => item.unlocked)
                .length;
            final email =
                Supabase.instance.client.auth.currentUser?.email ?? '';
            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 44),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.profile.nickname,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    email,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ProgressCard(profile: data.profile),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.emoji_events_outlined),
                      title: const Text('Conquistas desbloqueadas'),
                      trailing: Text('$unlocked'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: _signingOut ? null : _logout,
                    icon: const Icon(Icons.logout),
                    label: Text(_signingOut ? 'Saindo...' : 'Sair da conta'),
                  ),
                ],
              ),
            );
          },
        ),
      );
}
