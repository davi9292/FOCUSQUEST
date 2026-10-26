// Autor: Davi de Assis Fabricio
class RankingEntry {
  const RankingEntry({
    required this.position,
    required this.nickname,
    required this.points,
    required this.isMe,
  });

  final int position;
  final String nickname;
  final int points;
  final bool isMe;

  factory RankingEntry.fromJson(Map<String, dynamic> json) => RankingEntry(
        position: (json['rank_position'] as num).toInt(),
        nickname: json['nickname'] as String,
        points: (json['points'] as num).toInt(),
        isMe: json['is_me'] as bool,
      );
}
