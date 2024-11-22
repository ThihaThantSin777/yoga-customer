import 'package:intl/intl.dart';

class YogaCourseVO {
  final String id;

  final String dayOfWeek;
  final String time;
  final String duration;

  final int capacity;
  final double pricePerClass;

  final String typeOfClass;
  final String description;
  final String difficultyLevel;

  final List<YogaClass> classes;

  final String eventType;
  final double latitude;
  final double longitude;
  final String onlineUrl;

  YogaCourseVO({
    required this.id,
    required this.dayOfWeek,
    required this.time,
    required this.duration,
    required this.capacity,
    required this.pricePerClass,
    required this.typeOfClass,
    required this.description,
    required this.difficultyLevel,
    required this.classes,
    required this.eventType,
    required this.latitude,
    required this.longitude,
    required this.onlineUrl,
  });

  String get displayPrice {
    final formatter = NumberFormat("#.##");
    String formattedValue = formatter.format(pricePerClass);
    if (formattedValue.endsWith(".00")) {
      return formattedValue.substring(0, formattedValue.length - 3);
    }
    return formattedValue;
  }

  factory YogaCourseVO.fromJson(Map<String, dynamic> json) {
    return YogaCourseVO(
      id: json['id'],
      dayOfWeek: json['dayOfWeek'],
      time: json['time'],
      duration: json['duration'],
      capacity: json['capacity'],
      pricePerClass: json['pricePerClass'],
      typeOfClass: json['typeOfClass'],
      description: json['description'],
      difficultyLevel: json['difficultyLevel'],
      classes: (json['classes'] as List).map((e) => YogaClass.fromJson(e)).toList(),
      eventType: json['eventType'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      onlineUrl: json['onlineUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayOfWeek': dayOfWeek,
      'time': time,
      'duration': duration,
      'capacity': capacity,
      'pricePerClass': pricePerClass,
      'typeOfClass': typeOfClass,
      'description': description,
      'difficultyLevel': difficultyLevel,
      'classes': classes.map((e) => e.toJson()).toList(),
      'eventType': eventType,
      'latitude': latitude,
      'longitude': longitude,
      'onlineUrl': onlineUrl,
    };
  }
}

class YogaClass {
  final String id;
  final String date; // Stored as a String in "dd/MM/yyyy" format
  final String courseId;
  final String comment;
  final List<String> teachers;

  YogaClass({
    required this.id,
    required this.date,
    required this.courseId,
    required this.comment,
    required this.teachers,
  });

  String get teacherNames => teachers.join(", ");

  String get dayOfWeek {
    final dateFormat = DateFormat("dd/MM/yyyy");
    final parsedDate = dateFormat.parse(date);
    return DateFormat.EEEE().format(parsedDate);
  }

  factory YogaClass.fromJson(Map<String, dynamic> json) {
    return YogaClass(
      id: json['id'],
      date: json['date'],
      courseId: json['courseId'],
      comment: json['comment'],
      teachers: List<String>.from(json['teachers']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'courseId': courseId,
      'comment': comment,
      'teachers': teachers,
    };
  }
}
