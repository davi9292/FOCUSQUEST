// Autor: Davi de Assis Fabricio
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/achievement.dart';
import '../models/mission.dart';
import '../models/player_profile.dart';
import '../models/ranking_entry.dart';

class HomeData {
  const HomeData({
    required this.profile,
    required this.missions,
    required this.progress,
  });

  final PlayerProfile profile;
  final List<Mission> missions;
  final Map<int, UserMission> progress;
}

class MissionDetailData {
  const MissionDetailData(this.mission, this.progress);

  final Mission mission;
  final UserMission? progress;
}

class GameService {
  GameService(this._client);

  final SupabaseClient _client;

  String get _userId {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw StateError('Sessão expirada. Entre novamente.');
    return id;
  }

  Future<PlayerProfile> getProfile() async {
    final row = await _client
        .from('profiles')
        .select('id, nickname, total_points, completed_count')
        .eq('id', _userId)
        .single();
    return PlayerProfile.fromJson(row);
  }

  Future<List<Mission>> getMissions() async {
    final rows = await _client
        .from('missions')
        .select('id, title, description, instructions, category, difficulty, points')
        .eq('is_active', true)
        .order('id');
    return rows.map((row) => Mission.fromJson(row)).toList();
  }

  Future<Mission> getMission(int id) async {
    final row = await _client
        .from('missions')
        .select('id, title, description, instructions, category, difficulty, points')
        .eq('id', id)
        .eq('is_active', true)
        .single();
    return Mission.fromJson(row);
  }

  Future<Map<int, UserMission>> getProgress() async {
    final rows = await _client
        .from('user_missions')
        .select('mission_id, status, completed_at')
        .eq('user_id', _userId);
    final progress = rows.map((row) => UserMission.fromJson(row));
    return {for (final item in progress) item.missionId: item};
  }

  Future<HomeData> getHomeData() async {
    final profile = await getProfile();
    final missions = await getMissions();
    final progress = await getProgress();
    return HomeData(
      profile: profile,
      missions: missions,
      progress: progress,
    );
  }

  Future<MissionDetailData> getMissionDetail(
    int id, {
    Mission? selected,
  }) async {
    final mission = selected ?? await getMission(id);
    final progress = await getProgress();
    return MissionDetailData(mission, progress[id]);
  }

  Future<String> startMission(int id) async {
    final result = await _client.rpc(
      'start_mission',
      params: {'p_mission_id': id},
    );
    return result as String;
  }

  Future<bool> completeMission(int id) async {
    final result = await _client.rpc(
      'complete_mission',
      params: {'p_mission_id': id},
    );
    return result as bool;
  }

  Future<List<Achievement>> getAchievements() async {
    final rows = await _client
        .from('achievements')
        .select('id, name, description, icon_name')
        .order('id');
    final unlockedRows = await _client
        .from('user_achievements')
        .select('achievement_id')
        .eq('user_id', _userId);
    final unlockedIds = unlockedRows
        .map((row) => (row['achievement_id'] as num).toInt())
        .toSet();
    return rows
        .map((row) => Achievement.fromJson(
              row,
              unlocked: unlockedIds.contains((row['id'] as num).toInt()),
            ))
        .toList();
  }

  Future<List<RankingEntry>> getRanking() async {
    final rows = await _client.rpc('get_ranking') as List<dynamic>;
    return rows
        .map((row) => RankingEntry.fromJson(
              Map<String, dynamic>.from(row as Map),
            ))
        .toList();
  }

  Future<void> updateNickname(String nickname) async {
    await _client
        .from('profiles')
        .update({'nickname': nickname.trim()})
        .eq('id', _userId);
  }
}
