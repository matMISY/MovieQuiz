import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/game/pages/game_page.dart';
import 'features/game/services/game_engine.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Warning: Could not load .env file: $e');
  }

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MovieQuizApp());
}

class MovieQuizApp extends StatelessWidget {
  const MovieQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameEngine(),
      child: MaterialApp(
        title: 'Movie Quiz',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.amber,
          scaffoldBackgroundColor: const Color(0xFF1a1a1a),
          colorScheme: ColorScheme.dark(
            primary: Colors.amber,
            secondary: Colors.amber,
            surface: const Color(0xFF2a2a2a),
          ),
          useMaterial3: true,
        ),
        home: const GamePage(),
      ),
    );
  }
}
