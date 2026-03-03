import 'dart:convert';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../data/data_source/remote_data_source.dart';
import '../../data/repository/weather_repository.dart';

abstract class WeatherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchWeather extends WeatherEvent {}

class WeatherState extends Equatable {
  final String status;

  const WeatherState(this.status);

  @override
  List<Object?> get props => [status];
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({required this.weatherRepository}) : super(const WeatherState("Loading...")) {
    on<FetchWeather>((event, emit) async {
      try {

        var res = await weatherRepository.getWeather();
        print("res here: ${res.temperature}");

        emit(WeatherState("Current Temperature    ${res.temperature} ${res.unit}"));
      } catch (e) {
        print("Exception caught");
        emit(const WeatherState("Weather unavailable"));
      }
    });
  }
}
