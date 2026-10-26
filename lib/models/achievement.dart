// Autor: Davi de Assis Fabricio
class Achievement {
  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.unlocked,
  });

  final int id;
  final String name;
  final String description;
  final String iconName;
  final bool unlocked;

  factory Achievement.fromJson(
    Map<String, dynamic> json, {
    required bool unlocked,
  }) =>
      Achievement(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String,
        description: json['description'] as String,
        iconName: json['icon_name'] as String,
        unlocked: unlocked,
      );
}
