import 'package:flutter/material.dart';
import 'package:supatictactoe/navigation.dart';
import 'package:supatictactoe/services.dart';
import 'package:supatictactoe/services/game_service.dart';
import 'package:supatictactoe/views/game/game_view.dart';
import 'package:supatictactoe/widgets/app_button.dart';
import 'package:supatictactoe/widgets/app_input_field.dart';
import 'package:supatictactoe/widgets/app_screen.dart';
import 'package:supatictactoe/widgets/heading.dart';

class SearchGameView extends StatelessWidget {
  final _gameCodeController = TextEditingController();

  SearchGameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Heading(text: 'Enter game code'),
          AppInputField(controller: _gameCodeController),
          const SizedBox(height: 8.0),
          AppButton.expanded(
            label: 'Join game',
            onPressed: () async {
              try {
                final gameService = Services.of(context).gameService;
                final game =
                    await gameService.joinGame(_gameCodeController.text);
                switchScreen(context, GameView(game: game));
              } on InvalidGameCodeException catch (ex) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ex.message.toUpperCase() + '.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
