import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/home.dart';
import 'package:todo_app/shared/bloc-observer.dart';
void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[400],
        appBarTheme:AppBarTheme(
          backwardsCompatibility:false,
          systemOverlayStyle:SystemUiOverlayStyle(
            statusBarColor: Colors.grey[500],
            statusBarIconBrightness:Brightness.dark,
          ),
          backgroundColor: Colors.grey[500],
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[500],
          splashColor: Colors.black,

        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[500],
          selectedItemColor: Colors.white,
        ),


      ),

      home: HomeScreen(),
    );
  }
}
