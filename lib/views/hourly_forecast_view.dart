import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app_tutorial/constants/app_colors.dart';
import 'package:weather_app_tutorial/constants/text_styles.dart';
import 'package:weather_app_tutorial/models/hourly_weather.dart';
import 'package:weather_app_tutorial/providers/hourly_weather_provider.dart';

class HourlyForecastView extends ConsumerStatefulWidget {
  const HourlyForecastView({super.key});

  @override
  _HourlyForecastViewState createState() => _HourlyForecastViewState();
}

class _HourlyForecastViewState extends ConsumerState<HourlyForecastView> {
  String selectedMetric = 'Temperature';

  @override
  Widget build(BuildContext context) {
    final hourlyWeatherData = ref.watch(hourlyWeatherProvider);

    return hourlyWeatherData.when(
      data: (HourlyWeather hourlyWeather) {
        List<dynamic> next24Hours = hourlyWeather.list.where((weather) {
          final dateTime = DateTime.fromMillisecondsSinceEpoch(weather.dt * 1000);
          return dateTime.isAfter(DateTime.now()) && dateTime.isBefore(DateTime.now().add(const Duration(hours: 24)));
        }).toList();

        List<FlSpot> spots = next24Hours.asMap().entries.map((entry) {
          int index = entry.key;
          var weather = entry.value;

          double value;
          if (selectedMetric == 'Temperature') {
            value = weather.main.temp.toDouble();
          } else if (selectedMetric == 'Wind') {
            value = weather.wind.speed.toDouble();
          } else {
            value = weather.main.humidity.toDouble();
          }

          return FlSpot(index.toDouble(), value);
        }).toList();

        double minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 2;
        double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 2;

        return Card(
          elevation: 10,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            height: 280,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: AppColors.lightBlack,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Overview For The Next 24h', style: TextStyles.h2),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                    colors: [
                                      AppColors.primaryColor,
                                      AppColors.secondPrimaryColor,
                                    ],
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedMetric = 'Temperature';
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: const Text('Temperature'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                    colors: [
                                      AppColors.primaryColor,
                                      AppColors.secondPrimaryColor,
                                    ],
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedMetric = 'Wind';
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: const Text('Wind'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                    colors: [
                                      AppColors.primaryColor,
                                      AppColors.secondPrimaryColor,
                                    ],
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedMetric = 'Humidity';
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: const Text('Humidity'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                      child: SizedBox(
                        height: 165,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, _) {
                                    final hourIndex = value.toInt();
                                    if (hourIndex >= 0 && hourIndex < next24Hours.length) {
                                      final weather = next24Hours[hourIndex];
                                      final dateTime = DateTime.fromMillisecondsSinceEpoch(weather.dt * 1000);
                                      return Text(
                                        _formatHour(dateTime),
                                        style: TextStyle(color: AppColors.white, fontSize: 15),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            minX: 0,
                            maxX: next24Hours.length.toDouble() - 1,
                            minY: minY,
                            maxY: maxY,
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                gradient: LinearGradient(
                                  colors: [AppColors.royalFuchsia, AppColors.primaryColor],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                barWidth: 4,
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [AppColors.royalFuchsia.withOpacity(0.3), AppColors.primaryColor.withOpacity(0.0)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                dotData: FlDotData(show: true),
                              ),
                            ],
                            lineTouchData: LineTouchData(
                              handleBuiltInTouches: true,
                              touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
                              enabled: true,
                              touchTooltipData: LineTouchTooltipData(
                                tooltipMargin: 8,
                                tooltipPadding: const EdgeInsets.all(8),
                                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                  return touchedSpots.map((spot) {
                                    final hourIndex = spot.x.toInt();
                                    final weather = next24Hours[hourIndex];
                                    String value;
                                    if (selectedMetric == 'Temperature') {
                                      value = '${weather.main.temp}°C';
                                    } else if (selectedMetric == 'Wind') {
                                      value = '${weather.wind.speed} m/s';
                                    } else {
                                      value = '${weather.main.humidity}%';
                                    }

                                    return LineTooltipItem(
                                      value,
                                      const TextStyle(color: Colors.white),
                                    );
                                  }).toList();
                                },
                                fitInsideHorizontally: true,
                                fitInsideVertically: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

  String _formatHour(DateTime dateTime) {
    return '${dateTime.hour}:00';
  }
}
