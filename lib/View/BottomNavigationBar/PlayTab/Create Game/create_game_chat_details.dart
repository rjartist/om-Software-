import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_textfiled.dart' show GlobalTextField;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CreateGameChatDetails extends StatefulWidget {
  const CreateGameChatDetails({super.key});

  @override
  State<CreateGameChatDetails> createState() => _CreateGameChatDetailsState();
}

class _CreateGameChatDetailsState extends State<CreateGameChatDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabs = ["Images", "Videos", "Files"];
  final List<IconData> iconTabs = [
    Icons.image,
    Icons.video_collection,
    Icons.file_copy,
  ];

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
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "Chat Details", showBackButton: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: 10,
            ),
            child: Row(
              children: [
                Image.asset("assets/images/football.png", height: 25),
                SizedBox(width: 10),
                Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Cricket",
                      style: AppTextStyle.blackText(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "1 Players",
                      style: AppTextStyle.greytext(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "PLAYERS",
                  style: AppTextStyle.blackText(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(
                        "assets/images/dummyProfile1.jpg",
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Mayur Patil",
                      style: AppTextStyle.blackText(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Admin",
                      style: AppTextStyle.greytext(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(
                        "assets/images/dummyProfile2.jpg",
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Mayur Patil",
                      style: AppTextStyle.blackText(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(
                        "assets/images/dummyProfile3.jpg",
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Mayur Patil",
                      style: AppTextStyle.blackText(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SHARED MEDIA",
                  style: AppTextStyle.blackText(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  color: Color(0xFFE7E7E7),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primaryColor,
                    unselectedLabelColor: AppColors.black,
                    labelStyle: AppTextStyle.blackText(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    indicatorColor: AppColors.primaryColor,
                    indicatorWeight: 4.0,
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    tabs:
                        iconTabs
                            .map((iconTabs) => Tab(icon: Icon(iconTabs)))
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children:
                  iconTabs.map((iconTabs) => buildListIcon(iconTabs)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListIcon(IconData icon) {
    return icon == Icons.image || icon == Icons.video_collection
        ? Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: GridView.builder(
            padding: EdgeInsets.only(top: 15),
            itemCount: 5, // Set your count here
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.image, // Use different icons per label if needed
                    size: 40,
                    color: Colors.grey.shade600,
                  ),
                ),
              );
            },
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: 5,
          itemBuilder:
              (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/google-docs.png",
                              height: 40,
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "File Name",
                                  style: AppTextStyle.blackText(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "500 KB | File Type",
                                  style: AppTextStyle.greytext(
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
        );
  }

  Widget buildList(String label) {
    return label == "Images" || label == "Videos"
        ? Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: GridView.builder(
            padding: EdgeInsets.only(top: 15),
            itemCount: 5, // Set your count here
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.image, // Use different icons per label if needed
                    size: 40,
                    color: Colors.grey.shade600,
                  ),
                ),
              );
            },
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: 5,
          itemBuilder:
              (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/google-docs.png",
                              height: 40,
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "File Name",
                                  style: AppTextStyle.blackText(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "500 KB | File Type",
                                  style: AppTextStyle.greytext(
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
        );
  }
}
