import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../theme/gamio_theme.dart';
import '../../widgets/custom_alert.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLoading = false;
  String _category = 'canje_tienda';

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submitTicket() async {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty || desc.isEmpty) {
      CustomAlert.show(
        context: context,
        title: 'Campos Incompletos',
        message: 'Por favor, describe detalladamente tu ticket de soporte para que podamos ayudarte.',
        type: AlertType.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await SupabaseService().submitSupportTicket(
        title: '[$_category] - $title',
        description: desc,
      );

      await CustomAlert.show(
        context: context,
        title: 'Ticket Creado 🎫',
        message: '¡Excelente! Tu ticket ha sido registrado en la base de datos de auditoría. Un moderador de soporte lo validará en las próximas horas.',
        type: AlertType.success,
        iconText: '🛡️',
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      CustomAlert.show(
        context: context,
        title: 'Fallo al Enviar',
        message: e.toString(),
        type: AlertType.error,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          'SOPORTE TÉCNICO',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: GamioTheme.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: GamioTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: GamioTheme.borderColor),
                    ),
                    child: const Row(
                      children: [
                        Text('🛎️ ', style: TextStyle(fontSize: 22)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '¿Has canjeado monedas de juego (LoL, VP, Apex)? Envíanos aquí el código de compra y tu ID in-game para que te hagamos la recarga de saldo manual.',
                            style: TextStyle(color: GamioTheme.textSecondary, fontSize: 12, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'CATEGORÍA DEL TICKET',
                    style: TextStyle(
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
                      value: _category,
                      isExpanded: true,
                      underline: const SizedBox(),
                      dropdownColor: GamioTheme.surfaceCard,
                      onChanged: (v) => setState(() => _category = v!),
                      items: const [
                        DropdownMenuItem(value: 'canje_tienda', child: Text('Canje de puntos de la tienda 💎', style: TextStyle(fontSize: 13))),
                        DropdownMenuItem(value: 'error_perfil', child: Text('Problemas con perfil o cosméticos 🖼️', style: TextStyle(fontSize: 13))),
                        DropdownMenuItem(value: 'reporte_conducta', child: Text('Reportar conducta molesta 🚩', style: TextStyle(fontSize: 13))),
                        DropdownMenuItem(value: 'otros', child: Text('Otras dudas / consultas generales 🛎️', style: TextStyle(fontSize: 13))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'TÍTULO DEL TICKET',
                    style: TextStyle(
                      color: GamioTheme.textSecondary,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Título descriptivo rápido...'),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'DESCRIPCIÓN Y DETALLES COMPLETOS',
                    style: TextStyle(
                      color: GamioTheme.textSecondary,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _descController,
                    maxLines: 6,
                    decoration: const InputDecoration(hintText: 'Describe el problema con todos los detalles (añade códigos de compra, ID de Riot, etc.)...'),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GamioTheme.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _submitTicket,
                    child: const Text(
                      'ENVIAR TICKET DE SOPORTE 🛎️',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
