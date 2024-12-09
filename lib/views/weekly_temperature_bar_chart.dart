import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_tutorial/constants/text_styles.dart';
import 'package:weather_app_tutorial/providers/weekly_weather_provider.dart';
import 'package:weather_app_tutorial/constants/app_colors.dart';
import 'package:intl/intl.dart';

class WeeklyTemperatureBarChart extends ConsumerWidget {
  const WeeklyTemperatureBarChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyForecastData = ref.watch(weeklyWeatherProvider);

    return weeklyForecastData.when(
      data: (weeklyWeather) {
        final List<double> minTemps = (weeklyWeather.daily.temperature2mMin as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList();
        final List<double> maxTemps = (weeklyWeather.daily.temperature2mMax as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList();

        final List<BarChartGroupData> barGroups = List.generate(minTemps.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: minTemps[index],
                gradient: LinearGradient(
                  colors: [
                    AppColors.royalFuchsia.withOpacity(0.3),
                    AppColors.royalFuchsia.withOpacity(1),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 15,
                borderRadius: BorderRadius.circular(4),
              ),
              BarChartRodData(
                toY: maxTemps[index],
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondPrimaryColor.withOpacity(0.3),
                    AppColors.secondPrimaryColor.withOpacity(1),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 15,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        });

        final List<String> days = weeklyWeather.daily.time.map((e) {
          final date = DateTime.parse(e);
          return DateFormat('EEE dd').format(date);
        }).toList();

        return Card( // Utilisation d'un widget Card pour l'élévation
          elevation: 10, // Ajout d'une élévation de 10
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Arrondi de la carte
          ),
          child: Container(
            height: 280, // Fixez la hauteur de la carte à 280
            decoration: BoxDecoration(
              color: AppColors.lightBlack,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Prévisions de Température Hebdomadaire',
                    style: TextStyles.h2,
                  ),
                  const SizedBox(height: 20), // Espacement entre le titre et le graphique
                  Expanded( // Utilisez Expanded pour occuper l'espace restant
                    child: BarChart(
                      BarChartData(
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                final dayIndex = value.toInt();
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    days[dayIndex],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white, // Couleur du texte en bas
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false), // Masquer le côté droit
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false), // Masquer le côté gauche
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false), // Masquer le haut
                          ),
                        ),
                        barGroups: barGroups,
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        alignment: BarChartAlignment.spaceAround,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              String weekDay = days[group.x.toInt()];
                              String minTemp = minTemps[group.x.toInt()].toString();
                              String maxTemp = maxTemps[group.x.toInt()].toString();
                              return BarTooltipItem(
                                'Min: $minTemp °C\nMax: $maxTemp °C',
                                const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text('Erreur: $error'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
