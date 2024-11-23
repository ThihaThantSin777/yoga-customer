import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yoga_customer/data/vos/booking_vo.dart';
import 'package:yoga_customer/data/vos/yoga_course_vo.dart';

class YogaProvider with ChangeNotifier {
  List<YogaCourseVO> _classes = [];
  List<YogaCourseVO> _cart = [];

  List<YogaCourseVO> get classes => _classes;

  List<YogaCourseVO> get cart => _cart;

  YogaProvider() {
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    final snapshot = await FirebaseFirestore.instance.collection('yoga_courses').get();
    _classes = snapshot.docs.map((doc) => YogaCourseVO.fromJson(doc.data())).toList();
    notifyListeners();
  }

  void addToCart(YogaCourseVO yogaClass) {
    _cart.add(yogaClass);
    notifyListeners();
  }

  void removeFromCart(YogaCourseVO yogaClass) {
    _cart.remove(yogaClass);
    notifyListeners();
  }

  Future<void> submitBooking(String email) async {
    final booking = BookingVO(email: email, classes: _cart);
    await FirebaseFirestore.instance.collection('bookings').add(booking.toJson());
    _cart.clear();
    notifyListeners();
  }
}
