import 'package:yoga_customer/data/vos/yoga_course_vo.dart';

class BookingVO {
  final String email;
  final List<YogaCourseVO> classes;

  BookingVO({required this.email, required this.classes});

  Map<String, dynamic> toJson() => {
        'email': email,
        'classes': classes.map((c) => c.toJson()).toList(),
      };

  factory BookingVO.fromJson(Map<String, dynamic> json) {
    return BookingVO(
      email: json['email'] as String,
      classes: (json['classes'] as List<dynamic>).map((item) => YogaCourseVO.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }
}
