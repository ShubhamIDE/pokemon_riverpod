import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon_riverpod/Services/database_service.dart';
import 'package:pokemon_riverpod/Services/http_services.dart';
import 'package:pokemon_riverpod/pages/HomePage.dart';

void main() async {
  await _setUpServices();
  runApp(const MyApp());
}

Future<void> _setUpServices() async {
  GetIt.instance.registerSingleton<HttpServices>(HttpServices());
  GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
          title: 'PokeDex',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
              useMaterial3: true,
              textTheme: GoogleFonts.quattrocentoSansTextTheme()),
          home: const HomePage()),
    );
  }
}
