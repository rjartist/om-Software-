import 'package:flutter/widgets.dart';
import 'package:gkmarts/Models/Learn/learn_model.dart';

class LearnProvider extends ChangeNotifier {
  bool isLearnDataLaoding = false;
  bool isGameListDataLaoding = false;

  List<GameModel> gameList = [];

  Future<void> getListOfGames() async {
    isLearnDataLaoding = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // simulate API

    final dummyGames = [
      {"id": 1, "title": "Cricket"},
      {"id": 2, "title": "Football"},
      {"id": 3, "title": "Tennis"},
    ];

    gameList = dummyGames.map((e) => GameModel.fromJson(e)).toList();

    isLearnDataLaoding = false;
    notifyListeners();
  }

  Future<void> getGameListData(int gameId) async {
    isGameListDataLaoding = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); 

    final dummyDetailData = {
      1: {
        "id": 1,
        "title": "5 Classic shots you Must try.",
        "description":
            "Cricket is turning into batsman’sgame with every passing year",

        "history": "Originated in England, played worldwide today.",
      },
      2: {
        "id": 2,
        "title": "Football",
        "description":
            "Football involves two teams of 11 trying to score goals.",
        "rules": [
          "90-minute game",
          "No hand touch (except goalie)",
          "Fouls penalized",
        ],
        "history": "Modern football developed in the 19th century in England.",
      },
      3: {
        "id": 3,
        "title": "Tennis",
        "description":
            "Tennis is played with a racket and ball on a rectangular court.",
        "rules": [
          "Singles or Doubles",
          "Game, Set, Match scoring",
          "Alternate serves",
        ],
        "history": "Evolved from a French handball game in the 12th century.",
      },
    };

    isGameListDataLaoding = false;
    notifyListeners();
  }
}
