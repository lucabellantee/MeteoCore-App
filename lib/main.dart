import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // ⬅️ importa dotenv
import 'screens/home_screen.dart';
import 'services/thingspeak_service.dart';

Future<void> main() async {
  // ⬇️ Carica il file .env PRIMA di usare dotenv.env
  await dotenv.load(fileName: ".env");

  // ⬇️ Poi avvia l'app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThingSpeakService()),
      ],
      child: MaterialApp(
        title: 'ThingSpeak Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
