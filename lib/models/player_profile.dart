// Autor: Davi de Assis Fabricio
class PlayerProfile {
  const PlayerProfile({
    required this.id,
    required this.nickname,
    required this.totalPoints,
    required this.completedCount,
  });

  final String id;
  final String nickname;
  final int totalPoints;
  final int completedCount;

  int get level => totalPoints ~/ 100 + 1;
  double get levelProgress => (totalPoints % 100) / 100;

  factory PlayerProfile.fromJson(Map<String, dynamic> json) => PlayerProfile(
        id: json['id'] as String,
        nickname: json['nickname'] as String,
        totalPoints: (json['total_points'] as num).toInt(),
        completedCount: (json['completed_count'] as num).toInt(),
      );
}
