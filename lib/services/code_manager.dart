import 'package:hashids2/hashids2.dart';

class CodeManager {
  final HashIds _hashIds;

  CodeManager() : _hashIds = _initHashIds;

  String toCode(int gameId) {
    return _hashIds.encode(gameId).padLeft(4, 'a');
  }

  int? toId(String gameCode) {
    final decoded =
        _hashIds.decode(gameCode.replaceAll('O', '0').replaceAll('l', '1'));
    return decoded.isNotEmpty ? decoded.first : null;
  }

  /// Setup an instance of `HashIds`. Removes 'O' and 'l' from the alphabet
  /// as they look too similar to 0 and 1 respectively.
  static HashIds get _initHashIds {
    return HashIds(
      minHashLength: 4,
      alphabet: HashIds.DEFAULT_ALPHABET.replaceAll(RegExp('[Ol]'), ''),
    );
  }
}
