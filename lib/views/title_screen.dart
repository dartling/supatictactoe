import 'package:flutter/material.dart';
import 'package:supatictactoe/services.dart';
import 'package:supatictactoe/views/game/host_game_view.dart';
import 'package:supatictactoe/views/game/search_game_view.dart';
import 'package:supatictactoe/widgets/app_button.dart';
import 'package:supatictactoe/widgets/screen_loader.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Supa Tic Tac Toe',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        AppButton.expanded(
          label: 'Join game',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SearchGameView(),
              ),
            );
          },
        ),
        AppButton.expanded(
          label: 'Host game',
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Container(
                  child: ScreenLoader(
                    future: Services.of(context).gameService.newGame(),
                    builder: (context, game) => HostGameView(
                      game: game,
                      gameService: Services.of(context).gameService,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
