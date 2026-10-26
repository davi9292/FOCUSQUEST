// Autor: Davi de Assis Fabricio
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/achievement.dart';
import '../services/game_service.dart';
import '../widgets/achievement_badge.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  late final GameService _game = GameService(Supabase.instance.client);
  late Future<List<Achievement>> _future;

  @override
  void initState() {
    super.initState();
    _future = _game.getAchievements();
  }

  Future<void> _reload() {
    final next = _game.getAchievements();
    setState(() => _future = next);
    return next.then((_) {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Conquistas'),
          actions: [
            IconButton(
              tooltip: 'Atualizar',
              icon: const Icon(Icons.refresh),
              onPressed: _reload,
            ),
          ],
        ),
        body: FutureBuilder<List<Achievement>>(
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
            final items = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    '${items.where((item) => item.unlocked).length} de ${items.length} desbloqueadas',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  if (items.isEmpty)
                    const Center(child: Text('Ainda não há conquistas.'))
                  else
                    ...items.map(
                      (item) => AchievementBadge(achievement: item),
                    ),
                ],
              ),
            );
          },
        ),
      );
}
