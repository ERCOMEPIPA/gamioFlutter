import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient client = Supabase.instance.client;

  // --- Initializer ---
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
    
    final supabaseUrl = dotenv.env['PUBLIC_SUPABASE_URL'] ?? '';
    final supabaseAnonKey = dotenv.env['PUBLIC_SUPABASE_ANON_KEY'] ?? '';

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );
  }

  // --- Authentication Operations ---
  User? get currentUser => client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Future<AuthResponse> login(String email, String password) async {
    return await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signup(String email, String password, String username) async {
    final response = await client.auth.signUp(email: email, password: password);
    
    // Disparar un perfil inicial manual si el trigger de Supabase tuviese algún retardo
    if (response.user != null) {
      try {
        await client.from('profiles').insert({
          'id': response.user!.id,
          'name': username,
          'avatar_url': '',
          'favorite_games': [],
          'points': 0,
          'xp': 0,
          'level': 1,
          'is_admin': false,
          'is_banned': false,
        });
      } catch (_) {
        // Ignorar si el trigger de base de datos ya lo autocompletó
      }
    }
    return response;
  }

  Future<void> logout() async {
    await client.auth.signOut();
  }

  Future<void> updatePassword(String newPassword) async {
    await client.auth.updateUser(UserAttributes(password: newPassword));
  }

  // --- Profile Operations ---
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    if (!isAuthenticated) return null;
    try {
      final data = await client
          .from('profiles')
          .select()
          .eq('id', currentUser!.id)
          .single();
      return data;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String avatarUrl,
    required String selectedTitle,
    required String selectedBorder,
  }) async {
    if (!isAuthenticated) return;
    await client.from('profiles').update({
      'name': name,
      'avatar_url': avatarUrl,
      'selected_title': selectedTitle,
      'selected_border': selectedBorder,
    }).eq('id', currentUser!.id);
  }

  Stream<Map<String, dynamic>> getProfileStream() {
    final userId = currentUser?.id;
    if (userId == null) return const Stream.empty();
    return client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((List<Map<String, dynamic>> data) {
          return data.isNotEmpty ? data.first : <String, dynamic>{};
        });
  }

  Future<void> saveOnboarding({
    required List<String> favoriteGames,
    required String gameStyle,
    required String timeSlot,
  }) async {
    if (!isAuthenticated) return;
    await client.from('profiles').update({
      'favorite_games': favoriteGames,
      'game_style': gameStyle,
      'time_slot': timeSlot,
    }).eq('id', currentUser!.id);

    // Otorgar +10 puntos de onboarding de regalo
    try {
      await earnPoints(currentUser!.id, 10, 20);
    } catch (_) {}
  }

  // --- RPC Gamification Calls ---
  Future<void> earnPoints(String profileId, int points, int xp) async {
    await client.rpc('earn_points', params: {
      'p_profile_id': profileId,
      'p_amount': points,
      'p_xp_amount': xp,
    });
  }

  Future<bool> buyReward(String rewardId) async {
    if (!isAuthenticated) return false;
    final res = await client.rpc('buy_reward', params: {
      'p_profile_id': currentUser!.id,
      'p_reward_id': rewardId,
    });
    return res as bool;
  }

  Future<int> claimDailyPoints() async {
    if (!isAuthenticated) return 0;
    final res = await client.rpc('claim_daily_points', params: {
      'p_profile_id': currentUser!.id,
    });
    return res as int;
  }

  // --- Games operations ---
  Future<List<Map<String, dynamic>>> fetchGames() async {
    final List<dynamic> gamesData = await client.from('games').select();
    return List<Map<String, dynamic>>.from(gamesData);
  }

  Future<List<Map<String, dynamic>>> fetchAllProfiles() async {
    final List<dynamic> profilesData = await client.from('profiles').select('favorite_games');
    return List<Map<String, dynamic>>.from(profilesData);
  }

  // --- Matchmaking & Discovery ---
  Future<List<Map<String, dynamic>>> fetchMatchmakingProfiles({
    String? game,
    String? style,
    String? timeSlot,
    String? search,
  }) async {
    var query = client.from('profiles').select().eq('is_banned', false);

    if (game != null && game != 'Todos') {
      query = query.contains('favorite_games', [game]);
    }
    if (style != null && style != 'Todos') {
      query = query.eq('game_style', style);
    }
    if (timeSlot != null && timeSlot != 'Todos') {
      query = query.eq('time_slot', timeSlot);
    }

    final List<dynamic> result = await query;
    var list = List<Map<String, dynamic>>.from(result);

    if (currentUser != null) {
      list.removeWhere((p) => p['id'] == currentUser!.id);
    }

    if (search != null && search.trim().isNotEmpty) {
      final queryText = search.trim().toLowerCase();
      list = list.where((p) {
        final name = (p['name'] ?? '').toString().toLowerCase();
        return name.contains(queryText);
      }).toList();
    }

    return list;
  }

  // --- Friend Requests ---
  Future<List<Map<String, dynamic>>> fetchFriendRequests() async {
    if (!isAuthenticated) return [];
    final List<dynamic> res = await client
        .from('friend_requests')
        .select('*, sender:profiles!friend_requests_sender_id_fkey(*)')
        .eq('receiver_id', currentUser!.id)
        .eq('status', 'pending');
    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> sendFriendRequest(String receiverId) async {
    if (!isAuthenticated) return;
    await client.from('friend_requests').insert({
      'sender_id': currentUser!.id,
      'receiver_id': receiverId,
      'status': 'pending'
    });
  }

  Future<void> updateFriendRequest(String requestId, String status) async {
    await client.from('friend_requests').update({
      'status': status,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', requestId);
  }

  // --- Community Posts ---
  Future<List<Map<String, dynamic>>> fetchPosts() async {
    // Solo anuncios de las últimas 2 horas
    final twoHoursAgo = DateTime.now().subtract(const Duration(hours: 2)).toUtc().toIso8601String();
    
    final List<dynamic> res = await client
        .from('posts')
        .select('*, profiles(*)')
        .gte('created_at', twoHoursAgo)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res);
  }

  Future<Map<String, dynamic>> createPost({
    required String content,
    String? game,
    String? mode,
    int? spots,
    List<String>? tags,
  }) async {
    if (!isAuthenticated) throw Exception('No autorizado');

    final res = await client.from('posts').insert({
      'author_id': currentUser!.id,
      'content': content,
      'game': game,
      'mode': mode,
      'spots': spots,
      'tags': tags ?? [],
    }).select().single();

    // Otorgar +15 puntos y +30 XP de recompensa
    try {
      await earnPoints(currentUser!.id, 15, 30);
    } catch (_) {}

    return res;
  }

  Future<void> deletePost(String postId) async {
    await client.from('posts').delete().eq('id', postId);
  }

  // --- Global Chat (Messages table) ---
  Future<List<Map<String, dynamic>>> fetchGlobalMessages({String room = 'global'}) async {
    final List<dynamic> res = await client
        .from('messages')
        .select('*, profiles(*)')
        .eq('room', room)
        .order('created_at', ascending: true)
        .limit(100);
    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> sendGlobalMessage(String content, {String room = 'global'}) async {
    if (!isAuthenticated) return;
    await client.from('messages').insert({
      'profile_id': currentUser!.id,
      'content': content,
      'room': room,
    });
  }

  // --- Private Chats (Conversations) ---
  Future<List<Map<String, dynamic>>> fetchConversations() async {
    if (!isAuthenticated) return [];
    
    final List<dynamic> res = await client
        .from('conversation_participants')
        .select('''
          conversation_id,
          conversations (
            id,
            updated_at,
            conversation_participants (
              profiles (*)
            )
          )
        ''')
        .eq('profile_id', currentUser!.id);

    final list = List<Map<String, dynamic>>.from(res);
    final formattedList = <Map<String, dynamic>>[];

    for (var cp in list) {
      final conv = cp['conversations'];
      if (conv == null) continue;
      
      final participants = conv['conversation_participants'] as List;
      final otherParticipant = participants.firstWhere(
        (p) => p['profiles']['id'] != currentUser!.id,
        orElse: () => null,
      );

      if (otherParticipant != null) {
        formattedList.add({
          'id': conv['id'],
          'updated_at': conv['updated_at'],
          'other_user': otherParticipant['profiles'],
        });
      }
    }
    
    // Ordenar de más reciente a más antiguo
    formattedList.sort((a, b) => b['updated_at'].compareTo(a['updated_at']));
    return formattedList;
  }

  Future<String> startConversation(String targetProfileId) async {
    if (!isAuthenticated) throw Exception('No autorizado');

    // 1. Verificar si ya existe conversación conjunta
    final List<dynamic> existing = await client
        .from('conversation_participants')
        .select('conversation_id')
        .inFilter('profile_id', [currentUser!.id, targetProfileId]);

    final counts = <String, int>{};
    for (var entry in existing) {
      final id = entry['conversation_id'].toString();
      counts[id] = (counts[id] ?? 0) + 1;
    }

    String? existingId;
    counts.forEach((id, count) {
      if (count == 2) {
        existingId = id;
      }
    });

    if (existingId != null) {
      return existingId!;
    }

    // 2. Crear nueva conversación
    final newConv = await client.from('conversations').insert({}).select().single();
    final convId = newConv['id'];

    // 3. Añadir participantes
    await client.from('conversation_participants').insert([
      {'conversation_id': convId, 'profile_id': currentUser!.id},
      {'conversation_id': convId, 'profile_id': targetProfileId},
    ]);

    return convId;
  }

  Future<List<Map<String, dynamic>>> fetchPrivateMessages(String conversationId) async {
    final List<dynamic> res = await client
        .from('private_messages')
        .select('*, profiles(*)')
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> sendPrivateMessage(String conversationId, String content) async {
    if (!isAuthenticated) return;
    await client.from('private_messages').insert({
      'conversation_id': conversationId,
      'profile_id': currentUser!.id,
      'content': content,
    });

    // Actualizar updated_at en conversaciones
    await client.from('conversations').update({
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', conversationId);
  }

  // --- Reports & Incident tickets ---
  Future<void> submitReport({
    required String reportedId,
    required String reason,
    required String details,
    String? chatRoom,
  }) async {
    if (!isAuthenticated) return;
    await client.from('reports').insert({
      'reporter_id': currentUser!.id,
      'reported_id': reportedId,
      'reason': reason,
      'details': details,
      'chat_room': chatRoom,
      'status': 'pending',
    });
  }

  Future<List<Map<String, dynamic>>> fetchAdminReports() async {
    final List<dynamic> res = await client
        .from('reports')
        .select('*, reporter:profiles!reports_reporter_id_fkey(*), reported:profiles!reports_reported_id_fkey(*)')
        .eq('status', 'pending')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> resolveReport(String reportId, String status) async {
    await client.from('reports').update({'status': status}).eq('id', reportId);
  }

  Future<void> banUser(String profileId) async {
    await client.from('profiles').update({'is_banned': true}).eq('id', profileId);
  }

  Future<void> submitSupportTicket({
    required String title,
    required String description,
  }) async {
    // Al no haber tabla de soporte separada, en Astro los tickets se simulan enviándolos a soporte o correo.
    // Nosotros creamos un reporte de tipo 'other' hacia el admin como un ticket simulado en base de datos.
    if (!isAuthenticated) return;
    final List<dynamic> admins = await client.from('profiles').select('id').eq('is_admin', true).limit(1);
    final adminId = admins.isNotEmpty ? admins[0]['id'] : currentUser!.id;
    await submitReport(
      reportedId: adminId,
      reason: 'other',
      details: '[TICKET DE SOPORTE] Título: $title. Descripción: $description',
      chatRoom: 'Soporte Técnico',
    );
  }
}
