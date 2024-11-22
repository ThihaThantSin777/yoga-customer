import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_customer/bloc/yoga_provider.dart';
import 'package:yoga_customer/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => YogaProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yoga App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MainPage(),
      ),
    );
  }
}
