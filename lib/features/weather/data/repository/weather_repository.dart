import 'package:geolocator/geolocator.dart';
import '../data_source/remote_data_source.dart';
import '../models/weather_model.dart';

class WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepository({required this.remoteDataSource});

  Future<WeatherModel> getWeather() async {
    // Permission handling
    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied");
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return await remoteDataSource.fetchWeather(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}