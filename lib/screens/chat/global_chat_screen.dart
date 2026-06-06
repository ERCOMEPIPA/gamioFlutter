import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/message.dart';
import '../../models/profile.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/neon_border.dart';

class GlobalChatScreen extends StatefulWidget {
  const GlobalChatScreen({Key? key}) : super(key: key);

  @override
  State<GlobalChatScreen> createState() => _GlobalChatScreenState();
}

class _GlobalChatScreenState extends State<GlobalChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = true;
  String _activeRoom = 'global'; // 'global' or 'rankeds'
  RealtimeChannel? _chatChannel;
  final String _currentUserId = SupabaseService().currentUser?.id ?? '';
  final _profilesCache = <String, Profile>{};

  final Map<String, Map<String, String>> _roomDetails = {
    'global': {
      'title': 'Lobby Global',
      'desc': 'Chat público para encontrar jugadores de toda la comunidad.',
    },
    'rankeds': {
      'title': 'Buscando Equipo (Rankeds)',
      'desc': 'Salas de reclutamiento para partidas competitivas.',
    }
  };

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _subscribeToRealtime();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _chatChannel?.unsubscribe();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);
    try {
      final list = await SupabaseService().fetchGlobalMessages(room: _activeRoom);
      
      setState(() {
        _messages.clear();
        _messages.addAll(list.map((json) => Message.fromJson(json)));
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _subscribeToRealtime() {
    _chatChannel?.unsubscribe();

    _chatChannel = SupabaseService().client.channel('public:messages').onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      callback: (payload) async {
        final newRecord = payload.newRecord;
        if (newRecord['room'] != _activeRoom) return;

        final profileId = newRecord['profile_id'].toString();
        
        // Cargar perfil si no está en la caché local
        Profile? authorProfile = _profilesCache[profileId];
        if (authorProfile == null) {
          try {
            final pData = await SupabaseService().client
                .from('profiles')
                .select()
                .eq('id', profileId)
                .single();
            authorProfile = Profile.fromJson(pData);
            _profilesCache[profileId] = authorProfile;
          } catch (_) {}
        }

        final newMessage = Message(
          id: newRecord['id'].toString(),
          profileId: profileId,
          content: newRecord['content'] ?? '',
          room: newRecord['room'] ?? 'global',
          createdAt: DateTime.parse(newRecord['created_at']),
          author: authorProfile,
        );

        // Evitar duplicación si el mensaje optimista ya está en la lista
        final isMine = profileId == _currentUserId;
        bool exists = false;
        if (isMine) {
          exists = _messages.any((m) => m.isOptimistic && m.content == newMessage.content);
        }

        if (mounted) {
          setState(() {
            if (exists) {
              final idx = _messages.indexWhere((m) => m.isOptimistic && m.content == newMessage.content);
              if (idx != -1) {
                _messages[idx] = newMessage; // Confirmar optimista
              }
            } else {
              _messages.add(newMessage);
            }
          });
          _scrollToBottom();
        }
      },
    );

    _chatChannel!.subscribe();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    // UI Optimista
    final optimisticMsg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      profileId: _currentUserId,
      content: text,
      room: _activeRoom,
      createdAt: DateTime.now(),
      isOptimistic: true,
    );

    setState(() {
      _messages.add(optimisticMsg);
    });
    _scrollToBottom();

    try {
      await SupabaseService().sendGlobalMessage(text, room: _activeRoom);
    } catch (e) {
      setState(() {
        _messages.removeWhere((m) => m.id == optimisticMsg.id);
      });

      if (e.toString().contains('Acceso denegado') || e.toString().contains('suspendida')) {
        Navigator.of(context).pushReplacementNamed('/banned');
      } else {
        CustomAlert.show(
          context: context,
          title: 'Error de Envío',
          message: 'No se pudo enviar el mensaje. Error en el servidor.',
          type: AlertType.error,
        );
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _openReportDialog(String targetId, String targetName, String msgContent) {
    final detailsController = TextEditingController();
    String reason = 'chat_abuse';

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: GamioTheme.bgSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: GamioTheme.error.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.flag_outlined, color: GamioTheme.error),
                    const SizedBox(width: 8),
                    const Text(
                      'REPORTAR JUGADOR',
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Divider(color: GamioTheme.borderColor),
                const SizedBox(height: 16),
                Text('Denunciado: $targetName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                const SizedBox(height: 12),
                const Text('MOTIVO:', style: TextStyle(color: GamioTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: GamioTheme.bgPrimary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: GamioTheme.borderColor),
                  ),
                  child: DropdownButton<String>(
                    value: reason,
                    isExpanded: true,
                    underline: const SizedBox(),
                    dropdownColor: GamioTheme.bgSecondary,
                    onChanged: (v) => setModalState(() => reason = v!),
                    items: const [
                      DropdownMenuItem(value: 'chat_abuse', child: Text('Abuso en chat (insultos, toxicidad)', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'gameplay_abuse', child: Text('Mala conducta de juego (trampas)', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'spam', child: Text('Spam / Publicidad molesta', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'other', child: Text('Otro motivo', style: TextStyle(fontSize: 12))),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text('DETALLES / MENSAJE AFECTADO:', style: TextStyle(color: GamioTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextField(
                  controller: detailsController,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: 'Detalla lo sucedido...'),
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('Cancelar', style: TextStyle(color: GamioTheme.textSecondary)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: GamioTheme.error),
                      onPressed: () async {
                        final details = detailsController.text.trim();
                        if (details.isEmpty) return;

                        Navigator.of(context).pop();
                        try {
                          await SupabaseService().submitReport(
                            reportedId: targetId,
                            reason: reason,
                            details: '[CHAT MSG: "$msgContent"] - Detalles: $details',
                            chatRoom: 'Room #$_activeRoom',
                          );
                          CustomAlert.show(
                            context: context,
                            title: 'Denuncia Enviada',
                            message: 'Tu reporte ha sido remitido al equipo de moderadores para su auditoría de chat.',
                            type: AlertType.success,
                            iconText: '🚩',
                          );
                        } catch (_) {}
                      },
                      child: const Text('REPORTAR 🚩', style: TextStyle(fontSize: 12)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = _roomDetails[_activeRoom]!;

    return Scaffold(
      backgroundColor: GamioTheme.bgPrimary,
      appBar: AppBar(
        backgroundColor: GamioTheme.bgSecondary,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '# ${details['title']}',
              style: const TextStyle(fontFamily: 'Space Grotesk', fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              details['desc']!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: GamioTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Cambiar de sala',
            onSelected: (room) {
              setState(() {
                _activeRoom = room;
              });
              _loadMessages();
              _subscribeToRealtime();
            },
            color: GamioTheme.bgSecondary,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'global', child: Text('# Lobby Global', style: TextStyle(fontSize: 13))),
              PopupMenuItem(value: 'rankeds', child: Text('# Buscando Equipo', style: TextStyle(fontSize: 13))),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: GamioTheme.primary))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isMine = msg.profileId == _currentUserId;
                      return _buildMessageRow(msg, isMine);
                    },
                  ),
          ),
          // Input bar
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessageRow(Message msg, bool isMine) {
    final authorName = msg.author?.name ?? 'Gamer';
    final avatar = msg.author?.avatarUrl ?? '';
    final border = msg.author?.selectedBorder ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            NeonBorder(
              borderType: border,
              radius: 16,
              child: avatar.isNotEmpty
                  ? Image.network(
                      avatar,
                      fit: BoxFit.cover,
                      width: 32,
                      height: 32,
                      errorBuilder: (c, e, s) => _defaultAvatar(authorName),
                    )
                  : _defaultAvatar(authorName),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMine)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        authorName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: GamioTheme.textSecondary),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _openReportDialog(msg.profileId, authorName, msg.content),
                        child: const Text(
                          'Reportar',
                          style: TextStyle(color: GamioTheme.textMuted, fontSize: 9, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMine
                        ? GamioTheme.secondary
                        : GamioTheme.bgSecondary,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMine ? 16 : 4),
                      bottomRight: Radius.circular(isMine ? 4 : 16),
                    ),
                    boxShadow: isMine
                        ? [BoxShadow(color: GamioTheme.secondary.withOpacity(0.15), blurRadius: 8)]
                        : null,
                  ),
                  child: Text(
                    msg.content,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${msg.createdAt.hour.toString().padLeft(2, '0')}:${msg.createdAt.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: GamioTheme.textMuted, fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: GamioTheme.bgSecondary,
        border: Border(top: BorderSide(color: GamioTheme.borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Enviar mensaje al #${_roomDetails[_activeRoom]!['title']}...',
                filled: true,
                fillColor: GamioTheme.bgPrimary,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 13),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send_rounded, color: GamioTheme.primary),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar(String name) {
    return Container(
      color: GamioTheme.secondary,
      alignment: Alignment.center,
      child: Text(
        name.isEmpty ? '?' : name[0].toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
