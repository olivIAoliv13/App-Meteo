import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show immutable;

import '/constants/constants.dart';
import '/models/hourly_weather.dart';
import '/models/weather.dart';
import '/models/weekly_weather.dart';
import '/utils/logging.dart';

@immutable
class ApiHelper {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const WeeklyWeatherUrl =
      'https://api.open-meteo.com/v1/forecast?current=&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto';

  static double lat = 48.866669; // Définit Paris par défaut
  static double lon = 2.33333;    // Définit Paris par défaut
  static final dio = Dio();

  static Future<void> fetchLocation(double latitude, double longitude) async {
    lat = latitude;
    lon = longitude;

    // Affiche les coordonnées
    print('Location: Latitude: $lat, Longitude: $lon');
  }

  static Future<Weather> getCurrentWeather() async {
    final url = _constructWeatherUrl();
    final response = await _fetchData(url);
    return Weather.fromJson(response);
  }

  static Future<HourlyWeather> getHourlyForecast() async {
    final url = _constructForecastUrl();
    final response = await _fetchData(url);
    return HourlyWeather.fromJson(response);
  }

  static Future<WeeklyWeather> getWeeklyForecast() async {
    final url = _constructWeeklyForecastUrl();
    final response = await _fetchData(url);
    return WeeklyWeather.fromJson(response);
  }

  static Future<Map<String, double>> getCoordinatesByCityName(String cityName) async {
  final url = _constructWeatherByCityUrl(cityName);
  final response = await _fetchData(url);
  
  // Supposons que response contient 'coord' comme un Map
  if (response['coord'] != null) {
    return {
      'lat': (response['coord']['lat'] as num).toDouble(), // Convertit en double
      'lon': (response['coord']['lon'] as num).toDouble(), // Convertit en double
    };
  } else {
    throw Exception('Coordonnées non trouvées');
  }
}


  // Ajoutez cette méthode si elle n'est pas présente
  static Future<Weather> getWeatherByCityName({
    required String cityName,
  }) async {
    final url = _constructWeatherByCityUrl(cityName);
    final response = await _fetchData(url);
    return Weather.fromJson(response);
  }

  static String _constructWeatherUrl() =>
      '$baseUrl/weather?lat=$lat&lon=$lon&units=metric&appid=${Constants.apiKey}';

  static String _constructForecastUrl() =>
      '$baseUrl/forecast?lat=$lat&lon=$lon&units=metric&appid=${Constants.apiKey}';

  static String _constructWeatherByCityUrl(String cityName) =>
      '$baseUrl/weather?q=$cityName&units=metric&appid=${Constants.apiKey}';

  static String _constructWeeklyForecastUrl() =>
      '$WeeklyWeatherUrl&latitude=$lat&longitude=$lon';

  static Future<Map<String, dynamic>> _fetchData(String url) async {
    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        printWarning('Failed to load data: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      printWarning('Error fetching data from $url: $e');
      throw Exception('Error fetching data');
    }
  }
}
