import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';
import '../../widgets/neon_border.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  List<Map<String, dynamic>> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      final list = await SupabaseService().fetchConversations();
      setState(() {
        _conversations = list;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GamioTheme.bgPrimary,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: GamioTheme.primary))
          : RefreshIndicator(
              onRefresh: _loadConversations,
              color: GamioTheme.primary,
              child: _conversations.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.all(24),
                      children: const [
                        SizedBox(height: 120),
                        Center(
                          child: Text(
                            'Tu bandeja de entrada está vacía.\n\nBusca compañeros en el Buscador de Jugadores o chatea en el Lobby para iniciar una conversación privada.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: GamioTheme.textMuted, height: 1.6),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _conversations.length,
                      itemBuilder: (context, index) {
                        final conv = _conversations[index];
                        final otherUser = conv['other_user'] as Map<String, dynamic>;
                        final name = otherUser['name'] ?? 'Gamer';
                        final avatar = otherUser['avatar_url'] ?? '';
                        final border = otherUser['selected_border'] ?? '';
                        final title = otherUser['selected_title'] ?? '';

                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: NeonBorder(
                                borderType: border,
                                radius: 22,
                                child: avatar.isNotEmpty
                                    ? Image.network(
                                        avatar,
                                        fit: BoxFit.cover,
                                        width: 44,
                                        height: 44,
                                        errorBuilder: (c, e, s) => _defaultAvatar(name),
                                      )
                                    : _defaultAvatar(name),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  const SizedBox(width: 8),
                                  // Blue dot unread indicator
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: GamioTheme.primary,
                                      boxShadow: [
                                        BoxShadow(color: GamioTheme.primary, blurRadius: 4, spreadRadius: 1),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (title.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      GamioTheme.translateTitle(title),
                                      style: const TextStyle(color: GamioTheme.accentLight, fontSize: 9, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Abrir conversación de chat en vivo',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: GamioTheme.textSecondary, fontSize: 11),
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right, color: GamioTheme.textMuted),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/chat_private', arguments: conv['id'])
                                    .then((_) => _loadConversations());
                              },
                            ),
                            const Divider(color: GamioTheme.borderColor, height: 1),
                          ],
                        );
                      },
                    ),
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
          fontSize: 18,
        ),
      ),
    );
  }
}
