import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_tutorial/constants/app_colors.dart';
import 'package:weather_app_tutorial/constants/text_styles.dart';
import 'package:weather_app_tutorial/extensions/datetime.dart';
import 'package:weather_app_tutorial/providers/weekly_weather_provider.dart';
import 'package:weather_app_tutorial/utils/get_weather_icons.dart';
import 'package:weather_app_tutorial/widgets/subscript_text.dart';

class WeeklyForecastView extends ConsumerWidget {
  const WeeklyForecastView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WeeklyForecastData = ref.watch(weeklyWeatherProvider);

    return WeeklyForecastData.when(
      data: (weeklyWeather) {
        return Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.lightBlack,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Pour aligner les éléments à gauche
              children: [
                const Text(
                  'Weekly Forecast',
                  style: TextStyles.h2, // Style pour le sous-titre
                ),
                const SizedBox(height: 20), // Espacement avant la liste
                // Row pour afficher 7 jours
                Container(
                  height: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Pour espacer les éléments de manière égale
                    children: List.generate(6, (index) {
                      final dayOfWeek = DateTime.parse(weeklyWeather.daily.time[index]).dayOfWeek;
                      final date = weeklyWeather.daily.time[index];
                      final tempMax = weeklyWeather.daily.temperature2mMax[index];
                      final tempMin = weeklyWeather.daily.temperature2mMin[index];
                      final icon = weeklyWeather.daily.weatherCode[index];

                      // Appliquer un fond différent pour le premier élément
                      Color backgroundColor = index == 0
                          ? AppColors.primaryColor // Fond spécial pour le premier jour
                          : AppColors.darkBlack; // Fond par défaut

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4), // Espacement horizontal
                          child: WeeklyWeatherTile(
                            date: date,
                            day: dayOfWeek,
                            tempMax: tempMax.toInt(),
                            tempMin: tempMin.toInt(),
                            icon: getWeatherIcon2(icon),
                            backgroundColor: backgroundColor, // Passer la couleur de fond
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(error.toString()),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class WeeklyWeatherTile extends StatelessWidget {
  const WeeklyWeatherTile({
    super.key,
    required this.day,
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.icon,
    required this.backgroundColor,
  });

  final String day;
  final String date;
  final int tempMax;
  final int tempMin;
  final String icon;
  final Color backgroundColor; // Nouvelle propriété pour la couleur de fond

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: backgroundColor, // Utilisation de la couleur passée en paramètre
      ),
      child: Column( // Changement vers une disposition verticale
        mainAxisSize: MainAxisSize.min, // Adapte la taille à son contenu
        crossAxisAlignment: CrossAxisAlignment.center, // Centrage horizontal
        children: [
          // Jour
          Text(
            day,
            style: TextStyles.h3,
          ),
          const SizedBox(height: 5),
          // Date
          Text(
            date,
            style: TextStyles.subtitleText,
          ),
          const SizedBox(height: 10),
          // Températures combinées
          Row(
            mainAxisSize: MainAxisSize.min, // Adapte la taille au contenu
            children: [
              SuperscriptText(
                text: tempMin.toString(),
                superScript: "°C",
                color: AppColors.white,
                superscriptColor: AppColors.grey,
              ),
              Text(
                " - ",
                style: TextStyles.h3, // Style aligné avec les températures
              ),
              SuperscriptText(
                text: tempMax.toString(),
                superScript: "°C",
                color: AppColors.white,
                superscriptColor: AppColors.grey,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Icône météo
          Image.asset(
            icon,
            width: 40,
          ),
        ],
      ),
    );
  }
}
