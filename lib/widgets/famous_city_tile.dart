import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_tutorial/constants/app_colors.dart';
import 'package:weather_app_tutorial/constants/text_styles.dart';
import 'package:weather_app_tutorial/extensions/strings.dart';
import 'package:weather_app_tutorial/providers/get_weather_by_city_provider.dart';
import 'package:weather_app_tutorial/utils/get_weather_icons.dart';

class FamousCityTile extends ConsumerWidget {
  const FamousCityTile({super.key, required this.city, required this.index});

  final String city;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherData = ref.watch(getWeatherByCityNameProvider(city));

    return weatherData.when(
      data: (weather) {
        return Material(
          color: AppColors.lightBlack,
          elevation:  10 ,
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            height: 55,  // Fixe la hauteur de la carte
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 7,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${weather.main.temp.round().toString()}°',
                            style: TextStyles.h2,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            weather.weather[0].description.capitalize,
                            style: TextStyles.subtitleText,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,  // Limite à 2 lignes le texte de description
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      getWeatherIcon(weatherCode: weather.weather[0].id),
                      width: 50,
                    ),
                  ],
                ),
                Text(
                  weather.name,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(.8),
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis, // Gère le débordement du texte du nom de la ville
                  maxLines: 1,  // Limite le nom de la ville à 1 ligne
                )
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
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
