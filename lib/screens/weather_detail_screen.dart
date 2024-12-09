import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_tutorial/constants/app_colors.dart';
import 'package:weather_app_tutorial/extensions/datetime.dart';
import 'package:weather_app_tutorial/extensions/strings.dart';
import 'package:weather_app_tutorial/models/weather.dart';
import 'package:weather_app_tutorial/providers/current_weather_provider.dart';
import 'package:weather_app_tutorial/providers/get_weather_by_city_provider.dart';
import 'package:weather_app_tutorial/constants/text_styles.dart';
import 'package:weather_app_tutorial/views/hourly_forecast_view.dart';
import 'package:weather_app_tutorial/views/weather_info.dart';

class WeatherDetailScreen extends ConsumerWidget {
  const WeatherDetailScreen({
    super.key,
    required this.cityName,
  });

  final String cityName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherData = ref.watch(getWeatherByCityNameProvider(cityName));

    return Scaffold(
      body: Stack(
        children: [
          // Remplacer GradientContainer par un Container avec couleur de fond gris
          Container(
            color: AppColors.darkBlack, // Couleur de fond gris
            child: weatherData.when(
              data: (weather) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                      width: double.infinity,
                    ),
                    Text(
                      weather.name,
                      style: TextStyles.h1,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      DateTime.now().dateTime,
                      style: TextStyles.subtitleText,
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      height: 300,
                      child: Image.asset(
                        'assets/icons/${weather.weather[0].icon.replaceAll('n', 'd')}.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      weather.weather[0].description.capitalize,
                      style: TextStyles.h2,
                    ),
                    const SizedBox(height: 40),
                    WeatherInfo(
                      weather: weather,
                    ),
                    const SizedBox(height: 15),
                  ],
                );
              },
              error: (error, stackTrace) {
                return const Center(
                  child: Text('An error has occurred'),
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white), // Couleur de l'icône
              onPressed: () {
                Navigator.of(context).pop(); // Retourne à la page précédente
              },
            ),
          ),
        ],
      ),
    );
  }
}
