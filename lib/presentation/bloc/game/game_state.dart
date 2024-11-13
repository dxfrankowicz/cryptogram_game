part of 'game_bloc.dart';

enum GameStatus { initial, inProgress, success, failure }

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object> get props => [];
}

class GameEmpty extends GameState {}

class GameInitial extends GameState {
  final Quote quote;
  final GameStatus gameStatus;
  final List<LetterCode> playerGuesses;
  final List<LetterCode> lettersCode;
  final Level level;
  final String activeLetter;
  final int activeIndex;
  final List<String> hiddenLetters;
  final List<String> hintedLetters;
  final List<String> lettersOfQuoteInOrder;
  final Duration gameDuration;
  final String chosenAuthor;
  final String chosenCategory;

  const GameInitial(
      {this.quote = const Quote(text: ''),
      this.level = Level.easy,
      this.lettersCode = const <LetterCode>[],
      this.gameStatus = GameStatus.initial,
      this.activeLetter = '',
      this.activeIndex = -1,
      this.chosenAuthor = '',
      this.chosenCategory = '',
      this.hiddenLetters = const <String>[],
      this.hintedLetters = const <String>[],
      this.lettersOfQuoteInOrder = const <String>[],
      this.playerGuesses = const <LetterCode>[],
      this.gameDuration = Duration.zero})
      : super();

  @override
  List<Object> get props => [
        gameStatus,
        quote,
        playerGuesses,
        lettersCode,
        level,
        activeLetter,
        lettersOfQuoteInOrder,
        hiddenLetters,
        hintedLetters,
        activeIndex,
        gameDuration,
        chosenAuthor,
        chosenCategory
      ];

  /// Provides a copied instance.
  GameInitial copyWith({
    GameStatus? gameStatus,
    Quote? quote,
    String? activeLetter,
    int? activeIndex,
    Level? level,
    List<String>? hiddenLetters,
    List<LetterCode>? lettersCode,
    List<String>? hintedLetters,
    List<String>? lettersOfQuoteInOrder,
    Duration? gameDuration,
    List<LetterCode>? playerGuesses,
    String? chosenAuthor,
    String? chosenCategory
  }) =>
      GameInitial(
          gameStatus: gameStatus ?? this.gameStatus,
          quote: quote ?? this.quote,
          activeIndex: activeIndex ?? this.activeIndex,
          activeLetter: activeLetter ?? this.activeLetter,
          playerGuesses: playerGuesses ?? this.playerGuesses,
          hintedLetters: hintedLetters ?? this.hintedLetters,
          hiddenLetters: hiddenLetters ?? this.hiddenLetters,
          gameDuration: gameDuration ?? this.gameDuration,
          chosenAuthor: chosenAuthor ?? this.chosenAuthor,
          chosenCategory: chosenCategory ?? this.chosenCategory,
          level: level ?? this.level,
          lettersOfQuoteInOrder:
              lettersOfQuoteInOrder ?? this.lettersOfQuoteInOrder,
          lettersCode: lettersCode ?? this.lettersCode);
}
