// Autor: Davi de Assis Fabricio
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/mission.dart';
import '../services/game_service.dart';
import '../widgets/mission_card.dart';
import '../widgets/progress_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GameService _game = GameService(Supabase.instance.client);
  late Future<HomeData> _future;
  String _category = 'Todas';
  String _difficulty = 'Todas';

  @override
  void initState() {
    super.initState();
    _future = _game.getHomeData();
  }

  Future<void> _reload() {
    final next = _game.getHomeData();
    setState(() => _future = next);
    return next.then((_) {});
  }

  void _openMission(Mission mission) {
    context.push('/home/mission/${mission.id}', extra: mission).then((_) {
      if (mounted) _reload();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Central de Missões'),
          actions: [
            IconButton(
              tooltip: 'Atualizar',
              icon: const Icon(Icons.refresh),
              onPressed: _reload,
            ),
          ],
        ),
        body: FutureBuilder<HomeData>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Não foi possível carregar as missões.'),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _reload,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final data = snapshot.data!;
            final categories = <String>{
              'Todas',
              ...data.missions.map((mission) => mission.category),
            }.toList();
            final difficulties = <String>{
              'Todas',
              ...data.missions.map((mission) => mission.difficulty),
            }.toList();
            final filtered = data.missions.where((mission) {
              return (_category == 'Todas' ||
                      mission.category == _category) &&
                  (_difficulty == 'Todas' ||
                      mission.difficulty == _difficulty);
            }).toList();
            final available = data.missions.where(
              (mission) =>
                  data.progress[mission.id]?.status != 'completed',
            );
            final featured = available.isEmpty ? null : available.first;

            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Olá, ${data.profile.nickname}!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  const Text('Qual será sua próxima conquista?'),
                  const SizedBox(height: 16),
                  ProgressCard(profile: data.profile),
                  if (featured != null) ...[
                    const SizedBox(height: 18),
                    Text(
                      'Missão em destaque',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    MissionCard(
                      mission: featured,
                      status: data.progress[featured.id]?.status,
                      onTap: () => _openMission(featured),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Text(
                    'Todas as missões',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      DropdownMenu<String>(
                        label: const Text('Categoria'),
                        initialSelection: _category,
                        dropdownMenuEntries: categories
                            .map((item) => DropdownMenuEntry(
                                  value: item,
                                  label: item,
                                ))
                            .toList(),
                        onSelected: (value) {
                          if (value != null) {
                            setState(() => _category = value);
                          }
                        },
                      ),
                      DropdownMenu<String>(
                        label: const Text('Dificuldade'),
                        initialSelection: _difficulty,
                        dropdownMenuEntries: difficulties
                            .map((item) => DropdownMenuEntry(
                                  value: item,
                                  label: item,
                                ))
                            .toList(),
                        onSelected: (value) {
                          if (value != null) {
                            setState(() => _difficulty = value);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text('Nenhuma missão para estes filtros.'),
                      ),
                    )
                  else
                    ...filtered.map(
                      (mission) => MissionCard(
                        mission: mission,
                        status: data.progress[mission.id]?.status,
                        onTap: () => _openMission(mission),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      );
}
