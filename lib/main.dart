import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vtr_effects/colors/primaria.dart';
import 'package:vtr_effects/pages/page_cadastro.dart';
import 'package:vtr_effects/pages/page_login.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  await Firebase.initializeApp();
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
        primarySwatch: const MaterialColor(0x00000000, primaria),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PageLogin(),
      routes: {
        '/home': (context) => const PageLogin(),
        '/cadastrar': (context) => const PageCadastro(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
