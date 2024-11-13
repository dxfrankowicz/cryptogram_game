import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';
import 'data.dart';

void main() {
  runApp(RepositoryProvider(
    create: (context) => GameStatsRepository(GameStatsSharedPrefProvider()),
    child: const CryptogramApp(),
  ));
}

///do dodania cytaty

///https://cytatybaza.pl/cytaty/ekonomiczne/o-pieniadzach/


///https://refleksja.info/kategorie
