import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/gamio_theme.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> _news = const [
    {
      'title': 'El parche 14.11 de League of Legends redefine el meta de Tiradores 🏹',
      'source': 'Riot Games News',
      'url': 'https://www.eurogamer.es',
      'image': 'https://images.igdb.com/igdb/image/upload/t_cover_big/co49wj.jpg',
      'desc': 'Cambios masivos a los objetos de Tirador con ajustes sustanciales al Filo Infinito y las Botas de Berserker. Los campeones como Jinx y Caitlyn sufren rebalanceos profundos.'
    },
    {
      'title': 'Valorant presenta a Abyss, el nuevo mapa sin límites verticales 🗺️',
      'source': 'Valorant Esports',
      'url': 'https://www.eurogamer.es',
      'image': 'https://images.igdb.com/igdb/image/upload/t_cover_big/co2mvt.jpg',
      'desc': 'Un mapa ambientado en un cañón misterioso sin barreras físicas. Los jugadores pueden caerse al vacío durante los duelos clasificatorios, cambiando por completo las tácticas de control.'
    },
    {
      'title': 'EA Sports FC 25 detalla las mejoras tácticas del motor HypermotionV ⚽',
      'source': 'EA Sports',
      'url': 'https://www.eurogamer.es',
      'image': 'https://steamcdn-a.akamaihd.net/steam/apps/2669320/library_600x900.jpg',
      'desc': 'La inteligencia artificial colectiva y las tácticas avanzadas llamadas FC IQ permiten a los jugadores replicar los estilos de juego de los entrenadores profesionales con extrema precisión.'
    },
    {
      'title': 'Warzone introduce la rotación de mapas clásica en la temporada 4 💣',
      'source': 'Activision',
      'url': 'https://www.eurogamer.es',
      'image': 'https://steamcdn-a.akamaihd.net/steam/apps/1962663/library_600x900.jpg',
      'desc': 'Vuelve Verdansk a la rotación competitiva. Los desarrolladores anuncian ajustes severos al retraso del sprint táctico y balanceo masivo de fusiles de asalto clásicos.'
    }
  ];

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
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
          'NOTICIAS GAMING',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _news.length,
        itemBuilder: (context, index) {
          final item = _news[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 160,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        item['image']!,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(color: GamioTheme.bgTertiary),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black87],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: GamioTheme.secondary.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['source']!,
                            style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['desc']!,
                        style: const TextStyle(
                          color: GamioTheme.textSecondary,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.open_in_new, size: 14, color: GamioTheme.primary),
                            label: const Text('Leer Noticia Completa', style: TextStyle(fontSize: 12, color: GamioTheme.primary, fontWeight: FontWeight.bold)),
                            onPressed: () => _launchUrl(item['url']!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
