import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';
import '../../widgets/custom_alert.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  List<Map<String, dynamic>> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    try {
      final list = await SupabaseService().fetchAdminReports();
      setState(() {
        _reports = list;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _banUser(String profileId, String userName, String reportId) async {
    final confirm = await CustomAlert.show(
      context: context,
      title: 'CONFIRMAR SUSPENSIÓN',
      message: '¿Estás completamente seguro de suspender a "$userName" de forma indefinida de Gamio? Se le denegará el acceso inmediato a la base de datos.',
      type: AlertType.confirm,
      primaryButtonText: 'SUSPENDER (BAN)',
      secondaryButtonText: 'CANCELAR',
      iconText: '🚷',
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        // 1. Ban user
        await SupabaseService().banUser(profileId);
        // 2. Resolve report
        await SupabaseService().resolveReport(reportId, 'resolved');
        
        await CustomAlert.show(
          context: context,
          title: 'Usuario Suspendido',
          message: 'La cuenta de "$userName" ha sido suspendida de forma indefinida en la base de datos de Postgres.',
          type: AlertType.success,
          iconText: '🚨',
        );
        _loadReports();
      } catch (e) {
        CustomAlert.show(
          context: context,
          title: 'Error de Suspensión',
          message: e.toString(),
          type: AlertType.error,
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _dismissReport(String reportId) async {
    final confirm = await CustomAlert.show(
      context: context,
      title: 'Desestimar Denuncia',
      message: '¿Deseas archivar y desestimar este reporte de comportamiento sin aplicar ninguna sanción?',
      type: AlertType.confirm,
      primaryButtonText: 'DESESTIMAR',
      secondaryButtonText: 'CANCELAR',
      iconText: '📁',
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await SupabaseService().resolveReport(reportId, 'dismissed');
        _loadReports();
      } catch (e) {
        CustomAlert.show(
          context: context,
          title: 'Fallo al Archivar',
          message: e.toString(),
          type: AlertType.error,
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GamioTheme.bgPrimary,
      appBar: AppBar(
        backgroundColor: GamioTheme.bgSecondary,
        elevation: 0,
        title: const Text(
          'AUDITORÍA DE REPORTES',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: GamioTheme.warning,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: GamioTheme.primary))
          : RefreshIndicator(
              onRefresh: _loadReports,
              color: GamioTheme.primary,
              child: _reports.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.all(24),
                      children: const [
                        SizedBox(height: 120),
                        Center(
                          child: Text(
                            '¡Felicidades Administrador!\n\nNo hay reportes de comportamiento pendientes de auditoría en este momento.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: GamioTheme.textMuted, height: 1.6),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _reports.length,
                      itemBuilder: (context, index) {
                        final r = _reports[index];
                        final reportId = r['id'].toString();
                        final reporter = r['reporter'] as Map<String, dynamic>?;
                        final reported = r['reported'] as Map<String, dynamic>?;

                        final reporterName = reporter?['name'] ?? 'Usuario';
                        final reportedName = reported?['name'] ?? 'Usuario';
                        final reportedId = reported?['id']?.toString() ?? '';

                        final reason = r['reason'] ?? 'chat_abuse';
                        final details = r['details'] ?? '';
                        final chatRoom = r['chat_room'] ?? '';
                        
                        String reasonText = 'Abuso en chat';
                        if (reason == 'gameplay_abuse') reasonText = 'Conducta deportiva nociva';
                        if (reason == 'spam') reasonText = 'Spam de publicidad';
                        if (reason == 'other') reasonText = 'Otro motivo / Ticket de canje';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: GamioTheme.error.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: GamioTheme.error),
                                      ),
                                      child: Text(
                                        reasonText.toUpperCase(),
                                        style: const TextStyle(
                                          color: GamioTheme.error,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (chatRoom.isNotEmpty)
                                      Text(
                                        chatRoom,
                                        style: const TextStyle(color: GamioTheme.textMuted, fontSize: 10),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 13, color: Colors.white),
                                    children: [
                                      const TextSpan(text: 'Denunciante: ', style: TextStyle(color: GamioTheme.textSecondary, fontWeight: FontWeight.bold)),
                                      TextSpan(text: reporterName),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 13, color: Colors.white),
                                    children: [
                                      const TextSpan(text: 'Denunciado: ', style: TextStyle(color: GamioTheme.textSecondary, fontWeight: FontWeight.bold)),
                                      TextSpan(text: reportedName, style: const TextStyle(color: GamioTheme.accentLight, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'DETALLES DE LA INCIDENCIA:',
                                  style: TextStyle(
                                    color: GamioTheme.textMuted,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: GamioTheme.bgPrimary,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: GamioTheme.borderColor),
                                  ),
                                  child: Text(
                                    details,
                                    style: const TextStyle(
                                      color: GamioTheme.textSecondary,
                                      fontSize: 12,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Divider(color: GamioTheme.borderColor),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                        side: const BorderSide(color: GamioTheme.borderColor),
                                      ),
                                      icon: const Icon(Icons.archive_outlined, size: 16, color: Colors.white),
                                      label: const Text('Desestimar', style: TextStyle(fontSize: 11, color: Colors.white)),
                                      onPressed: () => _dismissReport(reportId),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                        backgroundColor: GamioTheme.error,
                                        foregroundColor: Colors.white,
                                      ),
                                      icon: const Icon(Icons.block_flipped, size: 16),
                                      label: const Text('Suspender Cuenta', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                      onPressed: () => _banUser(reportedId, reportedName, reportId),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
