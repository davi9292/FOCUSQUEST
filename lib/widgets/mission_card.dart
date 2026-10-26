// Autor: Davi de Assis Fabricio
import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/mission.dart';

class MissionCard extends StatelessWidget {
  const MissionCard({
    required this.mission,
    required this.status,
    required this.onTap,
    super.key,
  });

  final Mission mission;
  final String? status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final completed = status == 'completed';
    final inProgress = status == 'in_progress';
    final label = completed
        ? 'Concluída'
        : inProgress
            ? 'Em andamento'
            : 'Disponível';
    final statusColor = completed
        ? AppColors.success
        : inProgress
            ? AppColors.secondary
            : AppColors.reward;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      mission.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    '+${mission.points} XP',
                    style: const TextStyle(
                      color: AppColors.reward,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                mission.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  Chip(label: Text(mission.category)),
                  Chip(label: Text(mission.difficulty)),
                  Chip(
                    label: Text(label),
                    backgroundColor: statusColor.withValues(alpha: .18),
                    labelStyle: TextStyle(color: statusColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
