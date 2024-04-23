import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supatictactoe/models/game.dart';
import 'package:supatictactoe/models/game_state.dart';
import 'package:supatictactoe/models/game_status.dart';
import 'package:supatictactoe/services.dart';

class GameView extends StatelessWidget {
  final Game game;

  const GameView({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontSize: 40);
    final colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<GameState>(
        stream: Services.of(context).gameService.streamState(game.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active ||
              snapshot.data == null) {
            return const SizedBox();
          }
          final state = snapshot.data!;
          log('Game status ${state.status}');
          if (state.status == GameStatus.complete) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    state.winner != null
                        ? 'Player ${state.winner!} wins!'
                        : 'It\'s a tie!',
                    textAlign: TextAlign.center,
                    style: textStyle.copyWith(color: colorScheme.primary)),
                Text(
                    state.winner == game.player
                        ? 'Congratulations!'
                        : 'Better luck next time!',
                    textAlign: TextAlign.center,
                    style: textStyle),
              ],
            );
          }
          log('Game state updated with board ${state.board}');
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.lastPlayed != game.player) Text('Your turn'),
              if (state.lastPlayed == game.player)
                Text('Waiting for Player ${game.secondPlayer}...'),
              GridView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: 9,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => _onTap(context, state, index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.secondary),
                      ),
                      child: Center(
                        child: Text(
                          state.getSquareLabel(index),
                          style: textStyle.copyWith(
                            color: state.board[index] == game.player
                                ? colorScheme.primary
                                : null,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

  void _onTap(BuildContext context, GameState state, int index) {
    Services.of(context).gameService.playMove(game, state, index);
  }
}
