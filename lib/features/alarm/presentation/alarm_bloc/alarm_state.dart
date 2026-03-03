import 'package:equatable/equatable.dart';

import '../../data/models/alarm_model.dart';

class AlarmState extends Equatable {
  final List<AlarmModel> alarms;

  const AlarmState(this.alarms);

  @override
  List<Object?> get props => [alarms];
}
