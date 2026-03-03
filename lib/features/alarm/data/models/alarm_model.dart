import 'package:hive/hive.dart';

part 'alarm_model.g.dart';

@HiveType(typeId: 0)
class AlarmModel extends HiveObject {
  @HiveField(0)
  DateTime time;

  @HiveField(1)
  String label;

  AlarmModel({
    required this.time,
    required this.label,
  });
}