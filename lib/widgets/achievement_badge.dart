// Autor: Davi de Assis Fabricio
import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/achievement.dart';

class AchievementBadge extends StatelessWidget {
  const AchievementBadge({
    required this.achievement,
    super.key,
  });

  final Achievement achievement;

  IconData get _icon {
    if (!achievement.unlocked) return Icons.lock_rounded;
    switch (achievement.iconName) {
      case 'bolt':
        return Icons.bolt_rounded;
      case 'calendar':
        return Icons.calendar_month_rounded;
      case 'school':
        return Icons.school_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: achievement.unlocked
                ? AppColors.reward.withValues(alpha: .18)
                : AppColors.background,
            child: Icon(
              _icon,
              color: achievement.unlocked
                  ? AppColors.reward
                  : Colors.grey,
            ),
          ),
          title: Text(achievement.name),
          subtitle: Text(achievement.description),
          trailing: achievement.unlocked
              ? const Icon(Icons.check_circle, color: AppColors.success)
              : const Icon(Icons.lock_outline),
        ),
      );
}
