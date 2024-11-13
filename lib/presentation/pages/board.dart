import 'package:cryptogram_game/app/colors.dart';
import 'package:cryptogram_game/domain.dart';
import 'package:cryptogram_game/presentation/bloc/game/game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class GameBoard extends StatelessWidget {
  GameBoard({Key? key}) : super(key: key);
  List<UniqueKey> list = [];

  void _setActiveLetter(BuildContext context, int index) {
    BlocProvider.of<GameBloc>(context).add(BoardLetterPressed(index));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameBloc>().state;
    final playerGuesses = state.playerGuesses;
    final quote = state.quote;
    final activeLetter = state.activeLetter;
    final textTheme = Theme.of(context).textTheme;

    List<String> words = getWordListOfSentence(quote.text);
    double screenWidth = MediaQuery.of(context).size.width - 40;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Wrap(
              alignment: WrapAlignment.center,
              children: AnimateList(
                interval: const Duration(milliseconds: 150),
                effects: const [
                  FadeEffect(duration: Duration(milliseconds: 150)),
                  ScaleEffect(duration: Duration(milliseconds: 200))
                ],
                children: words.map((word) {
                  if (word.isNotEmpty) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(right: 8, left: 8, bottom: 8),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: getLetterListOfSentence(word).map(
                            (letter) {
                              UniqueKey key = UniqueKey();
                              list.add(key);
                              return SizedBox(
                                width: (screenWidth /
                                            getLongestWordLength(quote)) >
                                        25
                                    ? 25
                                    : (screenWidth /
                                        getLongestWordLength(quote)),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    InkWell(
                                      onTap: isPunctuationMark(letter)
                                          ? null
                                          : isLetterHidden(
                                                  letter: letter,
                                                  hiddenLetters:
                                                      state.hiddenLetters)
                                              ? () => _setActiveLetter(
                                                  context, list.indexOf(key))
                                              : null,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6)),
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 2, vertical: 1),
                                        color: isPunctuationMark(letter)
                                            ? AppColors.shade1
                                            : null,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(6)),
                                          side: activeLetter == letter
                                              ? BorderSide(
                                                  color: AppColors.highlight,
                                                  width: 1.0)
                                              : BorderSide.none,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text(
                                              isPunctuationMark(letter)
                                                  ? letter
                                                  : isLetterHidden(
                                                          letter: letter,
                                                          hiddenLetters: state
                                                              .hiddenLetters)
                                                      ? playerGuesses
                                                              .firstWhereOrNull(
                                                                  (x) =>
                                                                      x.letter ==
                                                                      letter)
                                                              ?.letter
                                                              ?.toUpperCase() ??
                                                          ''
                                                      : letter.toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: textTheme.titleMedium),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    InkWell(
                                      onTap: isPunctuationMark(letter)
                                          ? null
                                          : isLetterHidden(
                                                  letter: letter,
                                                  hiddenLetters:
                                                      state.hiddenLetters)
                                              ? () => _setActiveLetter(
                                                  context, list.indexOf(key))
                                              : null,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6)),
                                      child: Text(
                                          isPunctuationMark(letter)
                                              ? ''
                                              : !isLetterHidden(
                                                      letter: letter,
                                                      hiddenLetters:
                                                          state.hiddenLetters)
                                                  ? ''
                                                  : state.lettersCode
                                                      .firstWhere((x) =>
                                                          x.letter == letter)
                                                      .code!
                                                      .toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: textTheme.titleMedium!
                                              .copyWith(
                                                  color: state.activeLetter ==
                                                          letter
                                                      ? AppColors.highlight
                                                      : Colors.grey)),
                                    )
                                  ],
                                ),
                              );
                            },
                          ).toList()),
                    );
                  } else {
                    return const SizedBox(
                      width: 30.0,
                    );
                  }
                }).toList(),
              )),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("- ${quote.author ?? "Autor nieznany"}",
                  textAlign: TextAlign.end,
                  style: textTheme.titleMedium!.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey)),
              if (quote.source?.isNotEmpty ?? false)
                Text("\"${quote.source!}\"",
                    textAlign: TextAlign.end,
                    style: textTheme.bodySmall!.copyWith(
                        fontStyle: FontStyle.italic, color: Colors.grey)),
              if (quote.categories?.isNotEmpty ?? false)
                Text(quote.categories!.join(', '),
                    textAlign: TextAlign.end,
                    style: textTheme.titleMedium!.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey)),
            ],
          ),
        )
      ],
    );
  }
}
