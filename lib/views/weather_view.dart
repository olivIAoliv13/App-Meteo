import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_tutorial/constants/app_colors.dart';
import 'package:weather_app_tutorial/extensions/datetime.dart';
import 'package:weather_app_tutorial/extensions/strings.dart';
import 'package:weather_app_tutorial/providers/current_weather_provider.dart';
import 'package:weather_app_tutorial/constants/text_styles.dart';
import 'package:weather_app_tutorial/views/weather_info.dart';

class WeatherScreenView extends ConsumerWidget {
  const WeatherScreenView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherData = ref.watch(currentWeatherProvider);
    return weatherData.when(
      data: (weather) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            // Container contenant les informations météo avec un fond en gradient
            Container(
              height: 508, // Fixez la hauteur de la carte
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    AppColors.primaryColor,
                    AppColors.secondPrimaryColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(16), // Arrondi de la carte
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nom de la ville
                  Text(
                    weather.name,
                    style: TextStyles.h1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  // Date actuelle
                  Text(
                    DateTime.now().dateTime,
                    style: TextStyles.subtitleText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Image de la météo
                  SizedBox(
                    height: 200,
                    child: Image.asset(
                      'assets/icons/${weather.weather[0].icon.replaceAll('n', 'd')}.png',
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Description de la météo
                  Text(
                    weather.weather[0].description.capitalize,
                    style: TextStyles.h2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Informations sur la température, l'humidité et le vent
                  WeatherInfo(
                    weather: weather,
                  ),
                ],
              ),
            ),
          ],
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
