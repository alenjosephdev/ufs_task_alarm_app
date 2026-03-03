import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherRemoteDataSource {
  Future<WeatherModel> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final response = await http.get(
      Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true",
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception("Failed to fetch weather");
    }
  }
}