import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import '../../../../core/alarm_callback.dart';
import '../../data/models/alarm_model.dart';
import 'alarm_event.dart';
import 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final box = Hive.box<AlarmModel>('alarms');

  AlarmBloc() : super(const AlarmState([])) {
    on<LoadAlarms>((event, emit) {
      emit(AlarmState(box.values.toList()));
    });

    on<AddAlarm>((event, emit) async {
      DateTime now = DateTime.now();
      DateTime scheduledTime = event.time;

      // If time already passed today → schedule for tomorrow
      if (scheduledTime.isBefore(now.add(const Duration(seconds: 5)))) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      final alarm = AlarmModel(time: scheduledTime, label: event.label);

      final key = await box.add(alarm);

      bool success = await AndroidAlarmManager.oneShotAt(
        scheduledTime,
        key,
        alarmCallback,
        alarmClock: true,
        exact: true,
        wakeup: true,
        allowWhileIdle: true,
      );

      print("Alarm scheduled: $success at $scheduledTime");
      print("Alarm key : $key");

      emit(AlarmState(box.values.toList()));
    });

    on<DeleteAlarm>((event, emit) async {
      print("Canceling alarm id: ${event.key}");

      await AndroidAlarmManager.cancel(event.key);
      await box.delete(event.key);

      emit(AlarmState(box.values.toList()));
    });
  }
}
