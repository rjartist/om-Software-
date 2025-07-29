import 'package:flutter/widgets.dart';
import 'package:gkmarts/Models/Learn/learn_model.dart';

class LearnProvider extends ChangeNotifier {
  bool isLearnDataLaoding = false;
  bool isGameListDataLaoding = false;

  List<GameModel> gameList = [];
  List<VlogModel> vlogList = [];

  int selectedIndex = 0;

  void updateSelectedIndex(int index) {
    if (index < 0 || index >= gameList.length) return;

    selectedIndex = index;
    getGameListData(gameList[index].id);
    notifyListeners();
  }

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

    if (gameList.isNotEmpty) {
      getGameListData(gameList[selectedIndex].id);
    }

    isLearnDataLaoding = false;
    notifyListeners();
  }

  Future<void> getGameListData(int gameId) async {
    isGameListDataLaoding = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final Map<int, List<Map<String, dynamic>>> dummyDetailData = {
      1: [
        // Cricket
        {
          "id": 1,
          "title": "5 Classic Cricket Shots",
          "description":
              "Cricket is turning into a batsman’s game every year. Learn how to play the cover drive, straight drive, pull shot, square cut, and the helicopter shot with modern techniques used by pros.",
          "datePost": "Sat 16 Mar",
          "imageUrl":
              "https://www.shutterstock.com/image-photo/kids-playing-cricket-summer-park-600nw-2502089443.jpg",
        },
        {
          "id": 2,
          "title": "Top Spin Techniques",
          "description":
              "Master the art of spin bowling with techniques like off-spin, leg-spin, and the doosra. Learn grip, delivery, and mind games to deceive any batsman on the pitch.",
          "datePost": "Sat 16 Mar",
          "imageUrl":
              "https://www.shutterstock.com/image-photo/kids-playing-cricket-summer-park-600nw-2502089443.jpg",
        },
        {
          "id": 3,
          "title": "Power Hitting Drills",
          "description":
              "Improve your hitting with drills designed for range hitting, lofted shots, and timing. These advanced drills are used by players in T20 leagues.",
          "datePost": "Sat 16 Mar",
          "imageUrl":
              "https://www.shutterstock.com/image-photo/kids-playing-cricket-summer-park-600nw-2502089443.jpg",
        },
        {
          "id": 4,
          "title": "How to Field Like a Pro",
          "description":
              "Sharpen your fielding with these agility, reflex, and catching exercises. Learn how to anticipate shots and reduce boundaries.",
          "datePost": "Sat 16 Mar",
          "imageUrl":
              "https://www.shutterstock.com/image-photo/kids-playing-cricket-summer-park-600nw-2502089443.jpg",
        },
        {
          "id": 5,
          "title": "Winning Mindset in Cricket",
          "description":
              "Explore the mental side of cricket: handling pressure, staying focused, and making quick decisions that win matches.Explore the mental side of cricket: handling pressure, staying focused, and making quick decisions that win matches.Explore the mental side of cricket: handling pressure, staying focused, and making quick decisions that win matches.Explore the mental side of cricket: handling pressure, staying focused, and making quick decisions that win matches.Explore the mental side of cricket: handling pressure, staying focused, and making quick decisions that win matches.",
          "datePost": "Sat 16 Mar",
          "imageUrl":
              "https://www.shutterstock.com/image-photo/kids-playing-cricket-summer-park-600nw-2502089443.jpg",
        },
      ],
      2: [
        // Football
        {
          "id": 6,
          "title": "Master Football Dribbling",
          "description":
              "Tips to improve your footwork and control using cone drills, close control training, and body feints. Learn how to dribble past defenders like Messi.",
          "datePost": "Sat 16 Mar",
          "imageUrl":
              "https://www.shutterstock.com/image-photo/kids-playing-cricket-summer-park-600nw-2502089443.jpg",
        },
        {
          "id": 7,
          "title": "5 Iconic World Cup Goals",
          "description":
              "Revisit the most legendary goals in football history with context, build-up play, and the emotional moments they created for fans worldwide.",
          "datePost": "Sat 16 Mar",
          "imageUrl":
              "https://www.shutterstock.com/image-photo/kids-playing-cricket-summer-park-600nw-2502089443.jpg",
        },
        {
          "id": 8,
          "title": "Goalkeeping Basics",
          "description":
              "Learn the core skills for becoming a goalkeeper: shot-stopping, diving techniques, and positioning from top professionals.",
          "datePost": "Sat 16 Mar",
          "imageUrl":
              "https://www.shutterstock.com/image-photo/kids-playing-cricket-summer-park-600nw-2502089443.jpg",
        },
        {
          "id": 9,
          "title": "Understanding Football Formations",
          "description":
              "Dive into how 4-3-3, 4-2-3-1, and 3-5-2 formations affect play style, player roles, and tactics in modern football.",
          "datePost": "Sat 16 Mar",
          "imageUrl":
              "https://www.shutterstock.com/image-photo/kids-playing-cricket-summer-park-600nw-2502089443.jpg",
        },
        {
          "id": 10,
          "title": "Top Fitness Drills for Footballers",
          "description":
              "Speed, stamina, and strength are vital in football. These drills focus on agility ladders, sprint intervals, and resistance training.",
          "datePost": "Sat 16 Mar",
          "imageUrl":
              "https://www.shutterstock.com/image-photo/kids-playing-cricket-summer-park-600nw-2502089443.jpg",
        },
      ],
      3: [
        // Tennis
        {
          "id": 11,
          "title": "Serve like a Pro",
          "description":
              "Break down the perfect tennis serve with stance, toss, swing path, and follow-through. Learn how to serve with power and precision.",
          "datePost": "Sat 16 Mar",
          "imageUrl":
              "https://www.shutterstock.com/image-photo/kids-playing-cricket-summer-park-600nw-2502089443.jpg",
        },
        {
          "id": 12,
          "title": "Grand Slam Facts",
          "description":
              "Discover the history and prestige behind the Grand Slams. Dive into legendary matches, records, and unforgettable moments.",
          "datePost": "Sat 16 Mar",
          "imageUrl":
              "https://www.shutterstock.com/image-photo/kids-playing-cricket-summer-park-600nw-2502089443.jpg",
        },
        {
          "id": 13,
          "title": "Tennis Footwork Secrets",
          "description":
              "Footwork makes champions. Learn how to move efficiently on the court using split steps, lateral movement, and recovery drills.",
          "datePost": "Sat 16 Mar",
          "imageUrl":
              "https://www.shutterstock.com/image-photo/kids-playing-cricket-summer-park-600nw-2502089443.jpg",
        },
        {
          "id": 14,
          "title": "One-Handed vs Two-Handed Backhand",
          "description":
              "Explore the pros and cons of each backhand style with guidance on grip, timing, and swing mechanics for both techniques.",
          "datePost": "Sat 16 Mar",
          "imageUrl":
              "https://www.shutterstock.com/image-photo/kids-playing-cricket-summer-park-600nw-2502089443.jpg",
        },
        {
          "id": 15,
          "title": "Mental Toughness in Tennis",
          "description":
              "Win more matches by developing mental resilience, managing pressure, and staying focused throughout long rallies and tie-breaks.",
          "datePost": "Sat 16 Mar",
          "imageUrl":
              "https://www.shutterstock.com/image-photo/kids-playing-cricket-summer-park-600nw-2502089443.jpg",
        },
      ],
    };

    vlogList =
        dummyDetailData[gameId]
            ?.map((json) => VlogModel.fromJson(json))
            .toList() ??
        [];

    isGameListDataLaoding = false;
    notifyListeners();
  }
}
