import 'package:flutter/material.dart';
import 'package:supatictactoe/dependencies.dart';
import 'package:supatictactoe/services.dart';
import 'package:supatictactoe/theme.dart';
import 'package:supatictactoe/views/title_screen.dart';
import 'package:supatictactoe/widgets/app_screen.dart';
import 'package:supatictactoe/widgets/screen_loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = await Dependencies.init;
  runApp(SupaTicTacToeApp(dependencies: dependencies));
}

class SupaTicTacToeApp extends StatelessWidget {
  final Dependencies dependencies;

  const SupaTicTacToeApp({super.key, required this.dependencies});

  @override
  Widget build(BuildContext context) {
    return Services(
      dependencies: dependencies,
      child: MaterialApp(
        title: 'Supa Tic Tac Toe',
        theme: theme,
        home: AppScreen(
          child: ScreenLoader(
            future: dependencies.authService.signIn(),
            builder: (context, snapshot) {
              return TitleScreen();
            },
          ),
        ),
      ),
    );
  }
}
