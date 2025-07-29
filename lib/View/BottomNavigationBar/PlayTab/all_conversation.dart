import 'package:flutter/material.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/game_chat_screen.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/games_detail.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:page_transition/page_transition.dart';

class AllConversation extends StatefulWidget {
  const AllConversation({super.key});

  @override
  State<AllConversation> createState() => _AllConversationState();
}

class _AllConversationState extends State<AllConversation>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedTab = 0;

  final List<String> tabs = ["Games", "Requests"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: GlobalAppBar(title: "Conversations", showBackButton: true),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ), // total margin
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primaryColor,
                  unselectedLabelColor: AppColors.black,
                  labelStyle: AppTextStyle.blackText(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                  indicatorColor: AppColors.primaryColor,
                  indicatorWeight: 4.0,
                  padding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: tabs.map((tab) => buildList(tab)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildList(String label) {
    return label == "Games"
        ? ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: 1,
          itemBuilder:
              (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 300),
                                child: GamesDetail(playTab: false),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(
                                  "assets/images/dummyProfile1.jpg",
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Cricket",
                                      style: AppTextStyle.blackText(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "11:00 AM - 12:00 PM, 22 Mar, Mon",
                                      style: AppTextStyle.blackText(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Football, Pune, Maharashtra India.",
                                      style: AppTextStyle.blackText(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppColors.profileSectionButtonColor,
                                        AppColors.profileSectionButtonColor2,
                                      ],
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          child: GameChatScreen(),
                                        ),
                                      );
                                    },
                                    child: Image.asset(
                                      'assets/images/Vector.png', // use same logo as login
                                      fit: BoxFit.scaleDown,
                                      height: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(),
                      ],
                    ),
                  ),
                ),
              ),
        )
        : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.profileSectionButtonColor,
                            AppColors.profileSectionButtonColor2,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () => setState(() => selectedTab = 0),
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor:
                              selectedTab == 0
                                  ? Colors.transparent
                                  : Colors.white,
                          foregroundColor:
                              selectedTab == 0 ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color:
                                selectedTab == 0
                                    ? Colors.transparent
                                    : AppColors.black, // 👈 border color
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          "ALL",
                          style: AppTextStyle.blackText(
                            color:
                                selectedTab == 0
                                    ? AppColors.white
                                    : AppColors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.profileSectionButtonColor,
                            AppColors.profileSectionButtonColor2,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () => setState(() => selectedTab = 1),
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor:
                              selectedTab == 1
                                  ? Colors.transparent
                                  : Colors.white,
                          foregroundColor:
                              selectedTab == 1 ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color:
                                selectedTab == 1
                                    ? Colors.transparent
                                    : AppColors.black, // 👈 border color
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          "SENT",
                          style: AppTextStyle.blackText(
                            color:
                                selectedTab == 1
                                    ? AppColors.white
                                    : AppColors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.profileSectionButtonColor,
                            AppColors.profileSectionButtonColor2,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () => setState(() => selectedTab = 2),
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor:
                              selectedTab == 2
                                  ? Colors.transparent
                                  : Colors.white,
                          foregroundColor:
                              selectedTab == 2 ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color:
                                selectedTab == 2
                                    ? Colors.transparent
                                    : AppColors.black, // 👈 border color
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          "REQUESTED",
                          style: AppTextStyle.blackText(
                            color:
                                selectedTab == 2
                                    ? AppColors.white
                                    : AppColors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            tabSelected(selectedTab),
          ],
        );
  }

  Widget tabSelected(int tabSelected) {
    return Expanded(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder:
            (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: InkWell(
                onTap: () {
                  if (tabSelected == 2) {
                    showCustomPopup(context);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // shadow color
                        blurRadius: 8, // softening the shadow
                        offset: Offset(0, 4), // x and y direction
                        spreadRadius: 1, // how much the shadow spreads
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                "assets/images/dummyProfile1.jpg",
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5,
                              children: [
                                Text(
                                  "Gaurav Mahajan",
                                  style: AppTextStyle.blackText(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                tabSelected == 0
                                    ? Text(
                                      "Hi Mayur, can i join tomorrow’s game?",
                                      style: AppTextStyle.blackText(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                    : tabSelected == 1
                                    ? SizedBox()
                                    : Text(
                                      "Hi Mayur, can i join tomorrow’s game?",
                                      style: AppTextStyle.blackText(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  void showCustomPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "Nikhil Jadhav",
                      style: AppTextStyle.blackText(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Hi Mayur, can i join tomorrow’s game?",
                  style: AppTextStyle.blackText(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "REJECT",
                            style: AppTextStyle.blackText(
                              color: AppColors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.profileSectionButtonColor,
                              AppColors.profileSectionButtonColor2,
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "ACCEPT",
                            style: AppTextStyle.blackText(
                              color: AppColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
