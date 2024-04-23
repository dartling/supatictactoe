class Game {
  final int id;
  final String code;
  final int player;

  int get secondPlayer => player == 1 ? 2 : 1;

  Game(this.id, this.code, this.player);
}
