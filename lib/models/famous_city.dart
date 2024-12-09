class FamousCity {
  final String name;
  final double lat;
  final double lon;

  const FamousCity({
    required this.name,
    required this.lat,
    required this.lon,
  });
}


List<FamousCity> famousCities = [
  const FamousCity(
    name: 'London', 
    lat: 51.5074, 
    lon: -0.1278,
    ),
    const FamousCity(
    name: 'Paris', 
    lat: 48.866669, 
    lon: 2.33333,
    ),
    const FamousCity(
    name: 'New York', 
    lat: 40.71278, 
    lon: -74.0060,
    ),
    const FamousCity(
    name: 'Sydney', 
    lat: -33.8688, 
    lon: 151.2093,
    ),
];