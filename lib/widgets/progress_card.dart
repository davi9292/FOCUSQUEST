// Autor: Davi de Assis Fabricio
import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/player_profile.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({required this.profile, super.key});

  final PlayerProfile profile;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nível ${profile.level}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: profile.levelProgress,
                minHeight: 9,
                borderRadius: BorderRadius.circular(8),
                color: AppColors.secondary,
                backgroundColor: AppColors.background,
              ),
              const SizedBox(height: 8),
              Text(
                '${profile.totalPoints % 100}/100 XP para o próximo nível',
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.reward),
                  Text(' ${profile.totalPoints} XP'),
                  const Spacer(),
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                  ),
                  Text(' ${profile.completedCount} concluídas'),
                ],
              ),
            ],
          ),
        ),
      );
}
