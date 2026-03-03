import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufs_task/features/alarm/presentation/alarm_bloc/alarm_bloc.dart';

import '../../../weather/presentation/weather_bloc/weather_bloc.dart';
import '../alarm_bloc/alarm_event.dart';
import '../alarm_bloc/alarm_state.dart';

class AlarmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Offline Alarm")),
      body: Column(
        children: [
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                color: Colors.blue.shade100,
                child: Text(
                  state.status,
                  style: const TextStyle(fontSize: 18),
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<AlarmBloc, AlarmState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = state.alarms[index];
                    return ListTile(
                      title: Text(
                          "${alarm.time.hour}:${alarm.time.minute}"),
                      subtitle: Text(alarm.label),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context
                              .read<AlarmBloc>()
                              .add(DeleteAlarm(alarm.key as int));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );

          if (time != null) {
            final now = DateTime.now();
            final alarmTime = DateTime(
                now.year, now.month, now.day, time.hour, time.minute);

            context
                .read<AlarmBloc>()
                .add(AddAlarm(alarmTime, "Alarm"));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}