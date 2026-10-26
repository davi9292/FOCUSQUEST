// Autor: Davi de Assis Fabricio
class Mission {
  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.instructions,
    required this.category,
    required this.difficulty,
    required this.points,
  });

  final int id;
  final String title;
  final String description;
  final String instructions;
  final String category;
  final String difficulty;
  final int points;

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
        id: (json['id'] as num).toInt(),
        title: json['title'] as String,
        description: json['description'] as String,
        instructions: json['instructions'] as String,
        category: json['category'] as String,
        difficulty: json['difficulty'] as String,
        points: (json['points'] as num).toInt(),
      );
}

class UserMission {
  const UserMission({
    required this.missionId,
    required this.status,
    this.completedAt,
  });

  final int missionId;
  final String status;
  final DateTime? completedAt;

  factory UserMission.fromJson(Map<String, dynamic> json) => UserMission(
        missionId: (json['mission_id'] as num).toInt(),
        status: json['status'] as String,
        completedAt: json['completed_at'] == null
            ? null
            : DateTime.parse(json['completed_at'] as String),
      );
}
