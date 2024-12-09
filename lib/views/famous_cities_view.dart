import 'package:flutter/material.dart';
import 'package:weather_app_tutorial/models/famous_city.dart';
import 'package:weather_app_tutorial/screens/weather_detail_screen.dart';
import 'package:weather_app_tutorial/widgets/famous_city_tile.dart';

class FamousCitiesView extends StatelessWidget {
  const FamousCitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290, // Fixez une hauteur pour l'ensemble du GridView
      padding: const EdgeInsets.all(5),
      child: GridView.builder(
        itemCount: famousCities.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 23,
          mainAxisSpacing: 23,
          childAspectRatio: 2.07, // Changez ce rapport pour ajuster la taille
        ),
        itemBuilder: (context, index) {
          final city = famousCities[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => WeatherDetailScreen(cityName: city.name),
              ));
            },
            child: FamousCityTile(
              index: index,
              city: city.name,
            ),
          );
        },
      ),
    );
  }
}
