import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supatictactoe/secrets.dart';
import 'package:supatictactoe/services/auth_service.dart';
import 'package:supatictactoe/services/code_manager.dart';
import 'package:supatictactoe/services/game_service.dart';

class Dependencies {
  final AuthService authService;
  final GameService gameService;

  Dependencies._(this.authService, this.gameService);

  static Future<Dependencies> get init async {
    final supabase = await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    final authService = AuthService(supabase.client.auth);
    final gameService = GameService(supabase.client, CodeManager());
    return Dependencies._(authService, gameService);
  }
}
