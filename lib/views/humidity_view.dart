import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_tutorial/constants/app_colors.dart';
import 'package:weather_app_tutorial/constants/text_styles.dart';
import 'package:weather_app_tutorial/models/hourly_weather.dart';
import 'package:weather_app_tutorial/providers/hourly_weather_provider.dart';

class HumidityView extends ConsumerWidget {
  const HumidityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hourlyWeatherData = ref.watch(hourlyWeatherProvider);

    return hourlyWeatherData.when(
      data: (HourlyWeather hourlyWeather) {
        // Récupération de l'humidité actuelle
        var currentWeather = hourlyWeather.list.first; // Prendre les données actuelles
        double humidity = currentWeather.main.humidity.toDouble();

        return Card( // Utilisation d'un widget Card pour l'élévation
          elevation: 10, // Ajout d'une élévation de 10
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Arrondi de la carte
          ),
          child: Container(
            height: 200, // Fixez la hauteur de la carte ici
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightBlack,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligner à gauche
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0), // Décalage à gauche
                  child: Text(
                    'Humidity Overview',
                    style: TextStyles.h2,
                  ),
                ),
                SizedBox(height: 30), // Réduit l'espace pour l'humidité
                // Compteur d'humidité
                Center(
                  child: CustomPaint(
                    size: Size(180, 100), // Ajuster la taille pour agrandir le graphique
                    painter: HumidityIndicator(humidity: humidity),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, StackTrace) {
        return Center(child: Text(error.toString()));
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class HumidityIndicator extends CustomPainter {
  final double humidity;

  HumidityIndicator({required this.humidity});

  @override
  void paint(Canvas canvas, Size size) {
    // Paramètres pour dessiner
    double radius = size.width / 2;
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    // Couleur pour le fond (100% d'humidité)
    paint.color = AppColors.royalFuchsia.withOpacity(0.3);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      3.14, // Début à 180 degrés pour retourner le demi-cercle
      3.14, // 180 degrés pour le demi-cercle
      false,
      paint,
    );

    // Couleur pour l'humidité actuelle
    paint.color = AppColors.royalFuchsia;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      3.14, // Début à 180 degrés
      3.14 * (humidity / 100), // Calcul de l'angle en fonction de l'humidité
      false,
      paint,
    );

    // Cercle intérieur
    paint.color = AppColors.blueGrey.withOpacity(0.0);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(radius, radius), radius - 6, paint);

    // Affichage du pourcentage au centre du demi-cercle, ajusté pour être plus haut
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '${humidity.toInt()}%',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(radius - textPainter.width / 2, radius - textPainter.height / 1.2), // Ajuster la position verticale
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repeindre si nécessaire
  }
}
