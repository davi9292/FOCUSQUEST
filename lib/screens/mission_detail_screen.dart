// Autor: Davi de Assis Fabricio
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_theme.dart';
import '../models/mission.dart';
import '../services/game_service.dart';

class MissionDetailScreen extends StatefulWidget {
  const MissionDetailScreen({
    required this.missionId,
    this.selectedMission,
    super.key,
  });

  final int missionId;
  final Mission? selectedMission;

  @override
  State<MissionDetailScreen> createState() => _MissionDetailScreenState();
}

class _MissionDetailScreenState extends State<MissionDetailScreen> {
  late final GameService _game = GameService(Supabase.instance.client);
  late Future<MissionDetailData> _future;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _future = _game.getMissionDetail(
      widget.missionId,
      selected: widget.selectedMission,
    );
  }

  void _reload() {
    setState(() {
      _future = _game.getMissionDetail(widget.missionId);
    });
  }

  Future<void> _act(String? status) async {
    setState(() => _saving = true);
    try {
      if (status == null) {
        await _game.startMission(widget.missionId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Missão iniciada!')),
          );
        }
      } else {
        final awarded = await _game.completeMission(widget.missionId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                awarded
                    ? 'Missão concluída! Seus pontos foram atualizados.'
                    : 'Esta missão já foi concluída.',
              ),
            ),
          );
        }
      }
      if (mounted) _reload();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Detalhes da missão')),
        body: FutureBuilder<MissionDetailData>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Não foi possível abrir a missão.'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _reload,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            final data = snapshot.data!;
            final status = data.progress?.status;
            final completed = status == 'completed';
            final label = completed
                ? 'Concluída'
                : status == 'in_progress'
                    ? 'Em andamento'
                    : 'Disponível';
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  data.mission.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text(data.mission.category)),
                    Chip(label: Text(data.mission.difficulty)),
                    Chip(label: Text('+${data.mission.points} XP')),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Objetivo',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(data.mission.description),
                        const SizedBox(height: 20),
                        Text(
                          'Como realizar',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(data.mission.instructions),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(
                    completed
                        ? Icons.check_circle
                        : status == 'in_progress'
                            ? Icons.hourglass_bottom
                            : Icons.flag_outlined,
                    color: completed
                        ? AppColors.success
                        : AppColors.secondary,
                  ),
                  title: Text('Status: $label'),
                  subtitle: completed
                      ? const Text('Os pontos desta missão já foram recebidos.')
                      : null,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: completed || _saving
                      ? null
                      : () => _act(status),
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(completed
                          ? Icons.check
                          : status == null
                              ? Icons.play_arrow
                              : Icons.done),
                  label: Text(completed
                      ? 'Missão concluída'
                      : status == null
                          ? 'Iniciar missão'
                          : 'Concluir missão'),
                ),
              ],
            );
          },
        ),
      );
}
