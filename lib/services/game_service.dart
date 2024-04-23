import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supatictactoe/models/game.dart';
import 'package:supatictactoe/models/game_state.dart';
import 'package:supatictactoe/models/game_status.dart';
import 'package:supatictactoe/services/code_manager.dart';

class GameService {
  final SupabaseClient _supabaseClient;
  final CodeManager _codeManager;

  GameService(this._supabaseClient, this._codeManager);

  Future<Game> newGame() async {
    final game =
        await _supabaseClient.from('games').insert({}).select().single();
    final gameId = game['id'];
    final gameCode = _codeManager.toCode(gameId);
    log('Created game with code $gameCode (ID $gameId)');
    return Game(gameId, gameCode, 1);
  }

  Future<Game> joinGame(String gameCode) async {
    final gameId = _codeManager.toId(gameCode);
    log('Searching for game with code $gameCode (ID $gameId)');

    if (gameId == null) {
      throw InvalidGameCodeException('Invalid code');
    }

    final game = await _supabaseClient
        .from('games')
        .select()
        .eq('id', gameId)
        .maybeSingle();
    if (game == null) {
      throw InvalidGameCodeException('Invalid code');
    }

    final status = game['status'];
    log('Found game with status $status');
    if (status != 'pending') {
      throw InvalidGameCodeException('Game has already started');
    }

    await _supabaseClient
        .from('games')
        .update({'status': 'started'}).eq('id', gameId);

    return Game(gameId, gameCode, 2);
  }

Future<void> playMove(Game game, GameState state, int index) async {
  if (state.lastPlayed == game.player || state.board[index] != 0) {
    return;
  }
  state.board[index] = game.player;
  await _supabaseClient.from('games').update({
    'board': state.board.join(),
    'last_played': game.player,
  }).eq('id', game.id);
}

  Stream<GameState> streamState(int gameId) {
    return _supabaseClient
        .from('games')
        .stream(primaryKey: ['id'])
        .eq('id', gameId)
        .map((e) => toGameState(e.first));
  }

  GameState toGameState(Map<String, dynamic> game) {
    final status = GameStatus.fromString(game['status']);
    print(game['board']);
    final board = (game['board'] as String)
        .split('')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();
    return GameState(status, board, game['last_played'], game['winner']);
  }
}

class InvalidGameCodeException implements Exception {
  final String message;

  InvalidGameCodeException(this.message);
}
