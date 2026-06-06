import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';
import '../../widgets/custom_alert.dart';
import '../../widgets/neon_border.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _isLoading = true;
  final _nameController = TextEditingController();
  final _avatarController = TextEditingController();
  final _passwordController = TextEditingController();

  // Shop equip selection
  String _selectedTitle = '';
  String _selectedBorder = '';

  List<String> _unlockedTitles = [''];
  List<String> _unlockedBorders = [''];

  final List<String> _defaultAvatars = const [
    'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=150&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=150&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1563089145-599997674d42?w=150&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=150&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1566241477600-ac026ad43874?w=150&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1589254065878-42c9da997008?w=150&auto=format&fit=crop',
  ];

  final Map<String, String> _titleTranslation = {
    '': 'Sin Título Equipado 🚫',
    'title_casual': 'Gamer Casual 🎮',
    'title_support': 'Soporte de Élite 🛡️',
    'title_lone_wolf': 'Lobo Solitario 🐺',
    'title_tryhard': 'Tryhard Certificado 🔥',
    'title_legend': 'Leyenda Viviente 🏆',
  };

  final Map<String, String> _borderTranslation = {
    '': 'Sin Marco Equipado 🚫',
    'border_bronze': 'Borde de Bronce 🥉',
    'border_silver': 'Borde de Plata 🥈',
    'border_gold': 'Borde de Oro 🥇',
    'border_neon': 'Neón Psicodélico 🌈',
  };

  StreamSubscription? _profileSubscription;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _subscribeToProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarController.dispose();
    _passwordController.dispose();
    _profileSubscription?.cancel();
    super.dispose();
  }

  void _subscribeToProfile() {
    _profileSubscription?.cancel();
    _profileSubscription = SupabaseService().getProfileStream().listen((profile) {
      if (profile.isNotEmpty && mounted) {
        setState(() {
          _profile = profile;
          _selectedTitle = profile['selected_title'] ?? '';
          _selectedBorder = profile['selected_border'] ?? '';
        });
      }
    });
  }

  Future<void> _loadProfileData() async {
    try {
      final profile = await SupabaseService().getCurrentUserProfile();
      if (profile != null) {
        final List claimed = profile['claimed_rewards'] ?? [];
        
        final titles = <String>[''];
        final borders = <String>[''];

        for (var item in claimed) {
          if (item.toString().startsWith('title_')) {
            titles.add(item.toString());
          } else if (item.toString().startsWith('border_')) {
            borders.add(item.toString());
          }
        }

        setState(() {
          _profile = profile;
          _nameController.text = profile['name'] ?? '';
          _avatarController.text = profile['avatar_url'] ?? '';
          _selectedTitle = profile['selected_title'] ?? '';
          _selectedBorder = profile['selected_border'] ?? '';
          _unlockedTitles = titles;
          _unlockedBorders = borders;
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfileChanges() async {
    setState(() => _isLoading = true);
    try {
      await SupabaseService().updateProfile(
        name: _nameController.text.trim(),
        avatarUrl: _avatarController.text.trim(),
        selectedTitle: _selectedTitle,
        selectedBorder: _selectedBorder,
      );
      
      await CustomAlert.show(
        context: context,
        title: 'Perfil Guardado',
        message: 'Tus cambios de identidad han sido guardados con éxito en la base de datos.',
        type: AlertType.success,
        iconText: '💾',
      );
      _loadProfileData();
    } catch (e) {
      CustomAlert.show(
        context: context,
        title: 'Error de Guardado',
        message: e.toString(),
        type: AlertType.error,
      );
      setState(() => _isLoading = false);
    }
  }

  void _openChangePasswordDialog() {
    _passwordController.clear();
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: GamioTheme.bgSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GamioTheme.primary.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'MODIFICAR CONTRASEÑA',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Divider(color: GamioTheme.borderColor),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Nueva contraseña (mín. 6 caracteres)'),
                style: const TextStyle(fontSize: 13, color: Colors.white),
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
                    onPressed: () async {
                      final pwd = _passwordController.text.trim();
                      if (pwd.length < 6) return;

                      Navigator.of(context).pop();
                      setState(() => _isLoading = true);
                      try {
                        await SupabaseService().updatePassword(pwd);
                        CustomAlert.show(
                          context: context,
                          title: 'Contraseña Actualizada',
                          message: 'Tu contraseña de Supabase ha sido modificada con éxito.',
                          type: AlertType.success,
                          iconText: '🔑',
                        );
                      } catch (e) {
                        CustomAlert.show(
                          context: context,
                          title: 'Error de Actualización',
                          message: e.toString(),
                          type: AlertType.error,
                        );
                      } finally {
                        setState(() => _isLoading = false);
                      }
                    },
                    child: const Text('ACTUALIZAR', style: TextStyle(fontSize: 12)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _profile == null) {
      return const Scaffold(
        backgroundColor: GamioTheme.bgPrimary,
        body: Center(child: CircularProgressIndicator(color: GamioTheme.primary)),
      );
    }

    final points = _profile?['points'] ?? 0;
    final xp = _profile?['xp'] ?? 0;
    final level = _profile?['level'] ?? 1;
    final favGames = List<String>.from(_profile?['favorite_games'] ?? []);

    final translatedTitle = _titleTranslation[_selectedTitle] ?? _selectedTitle;
    final translatedBorder = _borderTranslation[_selectedBorder] ?? _selectedBorder;

    return Scaffold(
      backgroundColor: GamioTheme.bgPrimary,
      appBar: AppBar(
        backgroundColor: GamioTheme.bgSecondary,
        elevation: 0,
        title: const Text(
          'AJUSTES DE PERFIL',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Card Header Preview
            _buildAvatarPreview(points, level, xp),
            const SizedBox(height: 28),
            // Edit visible name & Avatar URL
            const Text(
              'DATOS DE IDENTIDAD',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Nombre visible',
                prefixIcon: Icon(Icons.person_outline, size: 20),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            const Text(
              'ELIGE TU FOTO DE PERFIL',
              style: TextStyle(
                color: GamioTheme.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 72,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _defaultAvatars.length,
                itemBuilder: (context, index) {
                  final url = _defaultAvatars[index];
                  final isSelected = _avatarController.text == url;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _avatarController.text = url;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 12, bottom: 4, top: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? GamioTheme.primary : GamioTheme.borderColor,
                          width: isSelected ? 3 : 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: GamioTheme.primary.withOpacity(0.4),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                )
                              ]
                            : null,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          url,
                          width: 58,
                          height: 58,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            width: 58,
                            height: 58,
                            color: GamioTheme.bgTertiary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Equipables (Inventory)
            const Text(
              'INVENTARIO Y COSMÉTICOS EQUIPABLES',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            _buildEquipableDropdown(
              'Título Honorífico Equipado',
              _selectedTitle,
              _unlockedTitles,
              _titleTranslation,
              (v) => setState(() => _selectedTitle = v!),
            ),
            const SizedBox(height: 12),
            _buildEquipableDropdown(
              'Marco de Avatar Equipado',
              _selectedBorder,
              _unlockedBorders,
              _borderTranslation,
              (v) => setState(() => _selectedBorder = v!),
            ),
            const SizedBox(height: 24),
            // Action Buttons
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: GamioTheme.primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.save_outlined, size: 20),
              label: const Text('GUARDAR CAMBIOS', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: _saveProfileChanges,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: GamioTheme.borderColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.lock_outline, color: Colors.white, size: 18),
              label: const Text('CAMBIAR CONTRASEÑA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: _openChangePasswordDialog,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPreview(int points, int level, int xp) {
    final name = _nameController.text.trim();
    final avatar = _avatarController.text.trim();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GamioTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GamioTheme.borderColor),
      ),
      child: Column(
        children: [
          NeonBorder(
            borderType: _selectedBorder,
            radius: 36,
            child: avatar.isNotEmpty
                ? Image.network(
                    avatar,
                    fit: BoxFit.cover,
                    width: 72,
                    height: 72,
                    errorBuilder: (c, e, s) => _defaultAvatar(name),
                  )
                : _defaultAvatar(name),
          ),
          const SizedBox(height: 12),
          Text(
            name.isNotEmpty ? name : 'Gamer',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          if (_selectedTitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: GamioTheme.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: GamioTheme.accent.withOpacity(0.3)),
              ),
              child: Text(
                _titleTranslation[_selectedTitle] ?? _selectedTitle,
                style: const TextStyle(
                  color: GamioTheme.accentLight,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('NIVEL $level', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              Text('${xp % 100}/100 XP', style: const TextStyle(color: GamioTheme.primary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (xp % 100) / 100,
              backgroundColor: GamioTheme.bgPrimary,
              valueColor: const AlwaysStoppedAnimation<Color>(GamioTheme.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipableDropdown(
    String label,
    String currentValue,
    List<String> items,
    Map<String, String> translation,
    ValueChanged<String?> onChanged,
  ) {
    // Si la lista de items no contiene la clave actual, inyectarla para evitar cuelgues
    if (!items.contains(currentValue)) {
      items.add(currentValue);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: GamioTheme.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: GamioTheme.surfaceCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: GamioTheme.borderColor),
          ),
          child: DropdownButton<String>(
            value: currentValue,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: GamioTheme.surfaceCard,
            onChanged: onChanged,
            items: items.map((String val) {
              final labelText = translation[val] ?? val;
              return DropdownMenuItem<String>(
                value: val,
                child: Text(
                  labelText,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              );
            }).toList(),
          ),
        ),
      ],
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
          fontSize: 28,
        ),
      ),
    );
  }
}
