import 'package:hive/hive.dart';

part 'appointment_model.g.dart';

@HiveType(typeId: 0)
class AppointmentModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime dateTime;

  @HiveField(4)
  String type;

  @HiveField(5)
  int color;

  AppointmentModel({
    this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.type,
    required this.color,
  });
}
