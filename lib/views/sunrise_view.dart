import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_tutorial/constants/app_colors.dart';
import 'package:weather_app_tutorial/constants/text_styles.dart';
import 'package:weather_app_tutorial/providers/current_weather_provider.dart';

class SunriseSunsetCard extends ConsumerWidget {
  const SunriseSunsetCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider);

    return weatherAsync.when(
      data: (weather) {
        // Calcul des données
        final sunrise = DateTime.fromMillisecondsSinceEpoch(weather.sys.sunrise * 1000);
        final sunset = DateTime.fromMillisecondsSinceEpoch(weather.sys.sunset * 1000);
        final sunriseMinutes = sunrise.hour * 60 + sunrise.minute;
        final sunsetMinutes = sunset.hour * 60 + sunset.minute;

        return Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            height: 200, // Augmenté pour inclure les icônes et heures
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightBlack,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre dans le coin supérieur gauche
                const Text(
                  'Sunrise & Sunset',
                  style: TextStyles.h2,
                ),
                const SizedBox(height: 16),
                // Contenu centré avec le graphique et les icônes
                Center(
                  child: Stack(
                    clipBehavior: Clip.none, // Permet de dessiner au-dessus du graphique
                    children: [
                      // Le graphique en demi-cercle
                      CustomPaint(
                        size: const Size(250, 110), // Taille maximale du graphique
                        painter: SemiCircleGaugePainter(
                          sunriseMinutes: sunriseMinutes,
                          sunsetMinutes: sunsetMinutes,
                          sunriseLabel: DateFormat('hh:mm a').format(sunrise),
                          sunsetLabel: DateFormat('hh:mm a').format(sunset),
                        ),
                      ),
                      // Icône du lever de soleil au-dessus du point
                      Positioned(
                        left: -60, // Positionnement horizontal pour le lever de soleil
                        top: 80,   // Positionnement vertical pour l'icône
                        child: Image.asset(
                          'assets/icons/sunrise.png', // Chemin de l'image sunrise
                          width: 30, // Ajuste la taille si nécessaire
                          height: 30, // Ajuste la taille si nécessaire
                        ),
                      ),
                      // Icône du coucher de soleil au-dessus du point
                      Positioned(
                        right: -60, // Positionnement horizontal pour le coucher de soleil
                        top: 80,     // Positionnement vertical pour l'icône
                        child: Image.asset(
                          'assets/icons/sunset.png', // Chemin de l'image sunset
                          width: 30, // Ajuste la taille si nécessaire
                          height: 30, // Ajuste la taille si nécessaire
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(
          'Error: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

class SemiCircleGaugePainter extends CustomPainter {
  final int sunriseMinutes;
  final int sunsetMinutes;
  final String sunriseLabel;
  final String sunsetLabel;

  SemiCircleGaugePainter({
    required this.sunriseMinutes,
    required this.sunsetMinutes,
    required this.sunriseLabel,
    required this.sunsetLabel,
  });

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Toujours redessiner le graphique en cas de changements.
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    // Dimensions de la jauge
    final radius = size.width / 2 - 10;
    final center = Offset(size.width / 2, size.height);

    // Dessine la partie nuit (fond)
    paint.color = AppColors.primaryColor.withOpacity(0.9);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // Commence à gauche
      pi, // Demi-cercle
      false,
      paint,
    );

    // Dessine la partie jour
    paint.color = AppColors.royalFuchsia;
    final sunriseAngle = pi + (sunriseMinutes / 1440) * pi;
    final sunsetAngle = pi + (sunsetMinutes / 1440) * pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      sunriseAngle,
      sunsetAngle - sunriseAngle,
      false,
      paint,
    );

    // Dessine les points pour le lever et coucher du soleil
    final sunriseOffset = Offset(
      center.dx + radius * cos(sunriseAngle),
      center.dy + radius * sin(sunriseAngle),
    );
    final sunsetOffset = Offset(
      center.dx + radius * cos(sunsetAngle),
      center.dy + radius * sin(sunsetAngle),
    );

    final pointPaint = Paint()..color = Colors.white;
    canvas.drawCircle(sunriseOffset, 8, pointPaint);
    canvas.drawCircle(sunsetOffset, 8, pointPaint);

    // Dessine les labels pour les points
    final labelOffset = 20; // Décalage pour les légendes des points

    final textPainterSunrise = TextPainter(
      text: TextSpan(
        text: sunriseLabel,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    textPainterSunrise.paint(
      canvas,
      Offset(sunriseOffset.dx - textPainterSunrise.width / 2, labelOffset - 45),
    );

    final textPainterSunset = TextPainter(
      text: TextSpan(
        text: sunsetLabel,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    textPainterSunset.paint(
      canvas,
      Offset(sunsetOffset.dx - textPainterSunset.width / 2, labelOffset - 45),
    );
  }
}
