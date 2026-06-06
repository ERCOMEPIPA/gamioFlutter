import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/message.dart';
import '../../models/profile.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/neon_border.dart';

class PrivateChatScreen extends StatefulWidget {
  final String conversationId;

  const PrivateChatScreen({
    Key? key,
    required this.conversationId,
  }) : super(key: key);

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = true;
  RealtimeChannel? _realtimeChannel;
  final String _currentUserId = SupabaseService().currentUser?.id ?? '';
  
  Map<String, dynamic>? _otherParticipant;
  final _profilesCache = <String, Profile>{};

  @override
  void initState() {
    super.initState();
    _loadConversationInfo();
    _loadMessages();
    _subscribeToRealtime();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _realtimeChannel?.unsubscribe();
    super.dispose();
  }

  Future<void> _loadConversationInfo() async {
    try {
      final List<dynamic> cp = await SupabaseService().client
          .from('conversation_participants')
          .select('profiles(*)')
          .eq('conversation_id', widget.conversationId);
      
      final other = cp.firstWhere(
        (entry) => entry['profiles']['id'] != _currentUserId,
        orElse: () => null,
      );
      if (other != null && mounted) {
        setState(() {
          _otherParticipant = other['profiles'];
        });
      }
    } catch (_) {}
  }

  Future<void> _loadMessages() async {
    try {
      final list = await SupabaseService().fetchPrivateMessages(widget.conversationId);
      
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
    _realtimeChannel?.unsubscribe();

    _realtimeChannel = SupabaseService().client
        .channel('public:private_messages:${widget.conversationId}')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'private_messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'conversation_id',
        value: widget.conversationId,
      ),
      callback: (payload) async {
        final newRecord = payload.newRecord;
        final profileId = newRecord['profile_id'].toString();

        // Cargar perfil si no está en caché
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
          room: 'private',
          conversationId: widget.conversationId,
          createdAt: DateTime.parse(newRecord['created_at']),
          author: authorProfile,
        );

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

    _realtimeChannel!.subscribe();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    final optimisticMsg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      profileId: _currentUserId,
      content: text,
      room: 'private',
      conversationId: widget.conversationId,
      createdAt: DateTime.now(),
      isOptimistic: true,
    );

    setState(() {
      _messages.add(optimisticMsg);
    });
    _scrollToBottom();

    try {
      await SupabaseService().sendPrivateMessage(widget.conversationId, text);
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
          message: 'No se pudo enviar el mensaje privado. Error de red.',
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
                            details: '[DM CHAT MSG: "$msgContent"] - Detalles: $details',
                            chatRoom: 'Mensaje Privado DM',
                          );
                          CustomAlert.show(
                            context: context,
                            title: 'Denuncia Enviada',
                            message: 'Tu reporte ha sido enviado con éxito para auditoría privada de comportamiento.',
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
    final otherName = _otherParticipant?['name'] ?? 'Conversación';
    final avatar = _otherParticipant?['avatar_url'] ?? '';
    final border = _otherParticipant?['selected_border'] ?? '';

    return Scaffold(
      backgroundColor: GamioTheme.bgPrimary,
      appBar: AppBar(
        backgroundColor: GamioTheme.bgSecondary,
        elevation: 0,
        title: Row(
          children: [
            NeonBorder(
              borderType: border,
              radius: 16,
              child: avatar.isNotEmpty
                  ? Image.network(
                      avatar,
                      fit: BoxFit.cover,
                      width: 32,
                      height: 32,
                      errorBuilder: (c, e, s) => _defaultAvatar(otherName),
                    )
                  : _defaultAvatar(otherName),
            ),
            const SizedBox(width: 10),
            Text(
              otherName,
              style: const TextStyle(fontFamily: 'Space Grotesk', fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          if (_otherParticipant != null)
            IconButton(
              icon: const Icon(Icons.flag_outlined, color: GamioTheme.error),
              tooltip: 'Reportar Usuario',
              onPressed: () => _openReportDialog(
                _otherParticipant!['id'],
                otherName,
                _messages.isNotEmpty ? _messages.last.content : 'Sin historial aún',
              ),
            ),
        ],
      ),
      body: Column(
        children: [
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
          _buildInputBar(otherName),
        ],
      ),
    );
  }

  Widget _buildMessageRow(Message msg, bool isMine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
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

  Widget _buildInputBar(String name) {
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
                hintText: 'Escribir a $name...',
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
