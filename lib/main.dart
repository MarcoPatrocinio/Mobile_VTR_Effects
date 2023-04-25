import 'package:flutter/material.dart';
import 'package:vtr_effects/colors/primaria.dart';
import 'package:vtr_effects/pages/page_fale_conosco.dart';
import 'package:vtr_effects/pages/page_login.dart';
import 'package:vtr_effects/pages/page_produtos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const primaria = mapPrimaryColor;



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile VTR-Effects',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF04121F),
        primarySwatch: const MaterialColor(0xFFBDB133, primaria),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PageLogin(),
      routes: {
        '/home': (context) => const PageLogin(),
        '/produtos': (context) => const PageProdutos(),
        '/faleconosco': (context) => const PageFaleConosto()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
