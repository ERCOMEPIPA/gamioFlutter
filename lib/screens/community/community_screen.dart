import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/post_card.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Post> _posts = [];
  bool _isLoading = true;
  final String _currentUserId = SupabaseService().currentUser?.id ?? '';

  // New Post Controller Fields
  final _contentController = TextEditingController();
  final _gameController = TextEditingController();
  final _modeController = TextEditingController();
  final _spotsController = TextEditingController();
  final _tagsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _gameController.dispose();
    _modeController.dispose();
    _spotsController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _loadPosts() async {
    try {
      final list = await SupabaseService().fetchPosts();
      setState(() {
        _posts = list.map((json) => Post.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deletePost(String postId) async {
    final confirm = await CustomAlert.show(
      context: context,
      title: 'Eliminar Anuncio',
      message: '¿Ya has encontrado a quien buscabas y deseas eliminar esta publicación de la comunidad?',
      type: AlertType.confirm,
      primaryButtonText: 'ELIMINAR',
      secondaryButtonText: 'CANCELAR',
      iconText: '🗑️',
    );

    if (confirm == true) {
      try {
        await SupabaseService().deletePost(postId);
        _loadPosts();
      } catch (e) {
        CustomAlert.show(
          context: context,
          title: 'Error al Borrar',
          message: e.toString(),
          type: AlertType.error,
        );
      }
    }
  }

  Future<void> _startChat(String authorId) async {
    try {
      final convId = await SupabaseService().startConversation(authorId);
      Navigator.of(context).pushNamed('/chat_private', arguments: convId);
    } catch (e) {
      CustomAlert.show(
        context: context,
        title: 'Error de Chat',
        message: e.toString(),
        type: AlertType.error,
      );
    }
  }

  void _openCreatePostDialog() {
    _contentController.clear();
    _gameController.clear();
    _modeController.clear();
    _spotsController.clear();
    _tagsController.clear();

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: GamioTheme.bgSecondary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GamioTheme.primary.withOpacity(0.2)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'CREAR ANUNCIO LFG',
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: GamioTheme.textMuted),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const Divider(color: GamioTheme.borderColor),
                  const SizedBox(height: 16),
                  // Content
                  TextField(
                    controller: _contentController,
                    maxLines: 4,
                    maxLength: 500,
                    decoration: const InputDecoration(
                      hintText: 'Describe qué buscas... (Ej: Busco equipo para subir a Platino en LoL, buen rollo y discord obligatorio)',
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  // Game
                  TextField(
                    controller: _gameController,
                    decoration: const InputDecoration(
                      hintText: 'Videojuego (Ej: League of Legends)',
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _modeController,
                          decoration: const InputDecoration(
                            hintText: 'Modo (Ej: Rankeds)',
                          ),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _spotsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Spots (Ej: 2)',
                          ),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Tags
                  TextField(
                    controller: _tagsController,
                    decoration: const InputDecoration(
                      hintText: 'Tags separados por comas (Ej: Tryhard, Discord)',
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GamioTheme.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      final content = _contentController.text.trim();
                      if (content.isEmpty) return;

                      final game = _gameController.text.trim();
                      final mode = _modeController.text.trim();
                      final spotsVal = int.tryParse(_spotsController.text.trim());
                      final tagsList = _tagsController.text
                          .split(',')
                          .map((t) => t.trim())
                          .where((t) => t.isNotEmpty)
                          .toList();

                      Navigator.of(context).pop();
                      
                      setState(() => _isLoading = true);
                      try {
                        await SupabaseService().createPost(
                          content: content,
                          game: game.isNotEmpty ? game : null,
                          mode: mode.isNotEmpty ? mode : null,
                          spots: spotsVal,
                          tags: tagsList,
                        );

                        await CustomAlert.show(
                          context: context,
                          title: '¡Anuncio Creado!',
                          message: 'Publicado correctamente. Has obtenido +15 Puntos y +30 XP.',
                          type: AlertType.success,
                          iconText: '📣',
                        );
                        _loadPosts();
                      } catch (e) {
                        CustomAlert.show(
                          context: context,
                          title: 'Error de Publicación',
                          message: e.toString().contains('Tu cuenta ha sido suspendida')
                              ? 'Acceso denegado: Tu cuenta ha sido suspendida de Gamio por infracción de nuestras políticas.'
                              : e.toString(),
                          type: AlertType.error,
                        );
                        setState(() => _isLoading = false);
                      }
                    },
                    child: const Text(
                      'PUBLICAR ANUNCIO 🚀',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GamioTheme.bgPrimary,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: GamioTheme.primary))
          : RefreshIndicator(
              onRefresh: _loadPosts,
              color: GamioTheme.primary,
              child: _posts.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.all(24),
                      children: const [
                        SizedBox(height: 100),
                        Center(
                          child: Text(
                            'No hay publicaciones en la comunidad aún.\n¡Sé el primero en crear una!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: GamioTheme.textMuted, height: 1.5),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _posts.length,
                      itemBuilder: (context, index) {
                        final post = _posts[index];
                        return PostCard(
                          post: post,
                          currentUserId: _currentUserId,
                          onDelete: () => _deletePost(post.id),
                          onMessage: () => _startChat(post.authorId),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: GamioTheme.secondary,
        foregroundColor: Colors.white,
        tooltip: 'Crear Anuncio LFG',
        onPressed: _openCreatePostDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
