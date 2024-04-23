import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supatictactoe/models/game.dart';
import 'package:supatictactoe/models/game_status.dart';
import 'package:supatictactoe/navigation.dart';
import 'package:supatictactoe/services/game_service.dart';
import 'package:supatictactoe/theme.dart';
import 'package:supatictactoe/views/game/game_view.dart';
import 'package:supatictactoe/widgets/app_screen.dart';

class HostGameView extends StatefulWidget {
  final Game game;
  final GameService gameService;

  const HostGameView({
    Key? key,
    required this.game,
    required this.gameService,
  }) : super(key: key);

  @override
  State<HostGameView> createState() => _HostGameViewState();
}

class _HostGameViewState extends State<HostGameView> {
  late StreamSubscription _statusSubscription;

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'GAME CODE',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.game.code,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: supabaseGreen),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Waiting for Player 2...',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _statusSubscription =
        widget.gameService.streamState(widget.game.id).listen((state) async {
      if (state.status == GameStatus.started) {
        switchScreen(context, GameView(game: widget.game));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _statusSubscription.cancel();
    super.dispose();
  }
}
