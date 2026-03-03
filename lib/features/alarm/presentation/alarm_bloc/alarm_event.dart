import 'package:equatable/equatable.dart';

abstract class AlarmEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAlarms extends AlarmEvent {}

class AddAlarm extends AlarmEvent {
  final DateTime time;
  final String label;

  AddAlarm(this.time, this.label);

  @override
  List<Object?> get props => [time, label];
}

class DeleteAlarm extends AlarmEvent {
  final int key; // Hive key

  DeleteAlarm(this.key);

  @override
  List<Object?> get props => [key];
}
