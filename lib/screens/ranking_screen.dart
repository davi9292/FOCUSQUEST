// Autor: Davi de Assis Fabricio
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_theme.dart';
import '../models/ranking_entry.dart';
import '../services/game_service.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  late final GameService _game = GameService(Supabase.instance.client);
  late Future<List<RankingEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = _game.getRanking();
  }

  Future<void> _reload() {
    final next = _game.getRanking();
    setState(() => _future = next);
    return next.then((_) {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Ranking'),
          actions: [
            IconButton(
              tooltip: 'Atualizar',
              icon: const Icon(Icons.refresh),
              onPressed: _reload,
            ),
          ],
        ),
        body: FutureBuilder<List<RankingEntry>>(
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
            final entries = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Classificação por pontos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  if (entries.isEmpty)
                    const Center(child: Text('Ainda não há jogadores.'))
                  else
                    ...entries.map((entry) {
                      final topThree = entry.position <= 3;
                      return Card(
                        color: entry.isMe
                            ? AppColors.primary.withValues(alpha: .35)
                            : null,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: topThree
                                ? AppColors.reward
                                : AppColors.surface,
                            child: Text(
                              '${entry.position}',
                              style: TextStyle(
                                color: topThree
                                    ? AppColors.background
                                    : AppColors.text,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            entry.isMe
                                ? '${entry.nickname} (você)'
                                : entry.nickname,
                          ),
                          trailing: Text(
                            '${entry.points} XP',
                            style: TextStyle(
                              color: topThree
                                  ? AppColors.reward
                                  : AppColors.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                ],
              ),
            );
          },
        ),
      );
}
