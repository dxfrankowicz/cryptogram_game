/// Copyright (c) 2022 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to
/// deal in the Software without restriction, including without limitation the
/// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
/// sell copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge,
/// publish, distribute, sublicense, create a derivative work, and/or sell
/// copies of the Software in any work that is designed, intended, or marketed
/// for pedagogical or instructional purposes related to programming, coding,
/// application development, or information technology.  Permission for such
/// use, copying, modification, merger, publication, distribution, sublicensing,
///  creation of derivative works, or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
///  IN THE SOFTWARE.
///
import 'dart:convert';
import 'dart:developer';

import 'package:cryptogram_game/presentation/bloc/quotes/quotes_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain.dart';
import 'models/quote.dart';

/// Interacts with shared preferences to store and retrieve data
/// about statistics of the game.
class GameStatsSharedPrefProvider {
  /// Key for retrieving data that indicates the amount of games played.
  static const quotes = 'GET_QUOTES';

  /// Key for retrieving data that indicates the amount of games played.
  static const kGamesPlayed = 'GAMES_PLAYED';

  /// Key for retrieving data that indicates the amount of games won.
  static const kGamesWon = 'GAMES_WON';

  /// Key for retrieving data that indicates the longest streak of games won.
  static const kLongestStreak = 'GAMES_LONGEST_STREAK';

  /// Key for retrieving data that indicates the current streak of games won.
  static const kCurrentStreak = 'GAMES_CURRENT_STREAK';

  List<Quote> _quotesList = [];

  /// Updates the value of a given stat.
  Future<bool> updateStat(String key, int value) async {
    final _prefs = await SharedPreferences.getInstance();

    return _prefs.setInt(key, value);
  }

  Future<bool> setQuotesList(List<Quote> value) async {
    final _prefs = await SharedPreferences.getInstance();

    _quotesList = List.of(value);
    return _prefs.setStringList(
        quotes, value.map((e) => jsonEncode(e)).toList());
  }

  /// Updates the value of a given stat.
  Future<int> fetchStat(String key) async {
    final _prefs = await SharedPreferences.getInstance();

    return _prefs.getInt(key) ?? 0;
  }

  Future<List<Quote>> getQuotesList({String? author, String? category}) async {
    if (quotes.isNotEmpty) {
      log("GETTING QUOTES FROM SAVED LIST");
      if (author?.isNotEmpty ?? false) {
        return _quotesList.where((q) => q.author == author).toList();
      } else if (category?.isNotEmpty ?? false) {
        return _quotesList
            .where((q) => q.categories?.contains(category) ?? false)
            .toList();
      }
      return _quotesList;
    }
    log("GETTING QUOTES FROM SHARED PREFS");
    final _prefs = await SharedPreferences.getInstance();
    List<String> list = _prefs.getStringList(quotes) ?? [];
    final decodedList = list.map((e) => Quote.fromJson(jsonDecode(e))).toList();
    if (author?.isNotEmpty ?? false) {
      return decodedList.where((q) => q.author == author).toList();
    } else if (category?.isNotEmpty ?? false) {
      return decodedList
          .where((q) => q.categories?.contains(category) ?? false)
          .toList();
    }
    return _quotesList;
  }
}

/// Provides information about statistics of the games played.
class GameStatsRepository {
  /// Constructor
  GameStatsRepository(this.provider);

  /// Interacts with shared preferences to store and retrieve data.
  final GameStatsSharedPrefProvider provider;

  /// Fetches the game stats.
  Future<GameStats> fetchStats() async {
    return GameStats(
      gamesPlayed:
          await provider.fetchStat(GameStatsSharedPrefProvider.kGamesPlayed),
      gamesWon: await provider.fetchStat(GameStatsSharedPrefProvider.kGamesWon),
      longestStreak:
          await provider.fetchStat(GameStatsSharedPrefProvider.kLongestStreak),
      currentStreak:
          await provider.fetchStat(GameStatsSharedPrefProvider.kCurrentStreak),
    );
  }

  /// Adds a new game to the count of games played, and if won it also adds it
  /// to the games won stat. It also updates the current streak and longest
  /// streak as needed.
  Future<void> addGameFinished({
    bool hasWon = false,
  }) async {
    final current = await fetchStats();

    await provider.updateStat(
      GameStatsSharedPrefProvider.kGamesPlayed,
      current.gamesPlayed + 1,
    );

    if (hasWon) {
      await provider.updateStat(
        GameStatsSharedPrefProvider.kGamesWon,
        current.gamesWon + 1,
      );

      await provider.updateStat(
        GameStatsSharedPrefProvider.kCurrentStreak,
        current.currentStreak + 1,
      );

      if (current.currentStreak == current.longestStreak) {
        await provider.updateStat(
          GameStatsSharedPrefProvider.kLongestStreak,
          current.longestStreak + 1,
        );
      }
    } else {
      await provider.updateStat(
        GameStatsSharedPrefProvider.kCurrentStreak,
        0,
      );
    }
  }

  /// Resets the stats stored locally.
  Future<void> resetStats() async {
    await provider.updateStat(
      GameStatsSharedPrefProvider.kGamesWon,
      0,
    );
    await provider.updateStat(
      GameStatsSharedPrefProvider.kGamesPlayed,
      0,
    );
    await provider.updateStat(
      GameStatsSharedPrefProvider.kCurrentStreak,
      0,
    );
    await provider.updateStat(
      GameStatsSharedPrefProvider.kLongestStreak,
      0,
    );
  }

  /// Init fetch quotes list.
  Future<void> fetchQuotesList(BuildContext context) async {
    final list = await provider.getQuotesList();
    if (list.isEmpty) {
      context.read<QuotesBloc>().add(GetQuotes());
    }
  }

  /// Saves quotes list.
  Future<void> saveQuotesList(List<Quote> quotes) async {
    await provider.setQuotesList(quotes);
  }
}
