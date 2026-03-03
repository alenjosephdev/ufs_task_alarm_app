class WeatherModel {
  final double temperature;
  final String unit;

  WeatherModel({
    required this.temperature,
    required this.unit,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json["current_weather"]["temperature"].toDouble(),
      unit: json["current_weather_units"]["temperature"],
    );
  }
}