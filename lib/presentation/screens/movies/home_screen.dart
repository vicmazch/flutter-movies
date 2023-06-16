import 'package:flutter/material.dart';
import 'package:sec_twelve_app/config/constants/environment.dart';


class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(child: Text(Enviroment.theMovieDBKey),),
    );
  }
}