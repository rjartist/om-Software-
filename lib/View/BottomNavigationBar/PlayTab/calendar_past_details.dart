import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:gkmarts/Widget/global_textfiled.dart' show GlobalTextField;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CalendarPastDetails extends StatefulWidget {
  const CalendarPastDetails({super.key});

  @override
  State<CalendarPastDetails> createState() => _CalendarPastDetailsState();
}

class _CalendarPastDetailsState extends State<CalendarPastDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabs = ["Request", "Invited", "Playing", "Retired"];

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
        appBar: GlobalAppBar(title: "Calendar", showBackButton: true),
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
}

Widget buildList(String label) {
  return ListView.builder(
    padding: const EdgeInsets.all(15),
    itemCount: 2,
    itemBuilder:
        (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Container(
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
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
                          Text(
                            "Gaurav Mahajan",
                            style: AppTextStyle.blackText(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      Text(
                        "2 hours ago",
                        style: AppTextStyle.blackText(
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                          color: AppColors.greytext,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label == "Playing" || label == "Retired"
                              ? Text(
                                "Total Players : 11",
                                style: AppTextStyle.blackText(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                              : SizedBox(),
                          Text(
                            "Total Matches : 0",
                            style: AppTextStyle.blackText(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      label == "Request" || label == "Invited"
                          ? GlobalGreySmallButton(text: "RETIRE", onTap: () {})
                          : SizedBox(),
                      SizedBox(width: 5),
                      label == "Request"
                          ? GlobalPrimarySmallButton(
                            text: "ACCEPT",
                            onTap: () {},
                          )
                          : label == "Playing"
                          ? GlobalPrimarySmallButton(
                            text: "PLAYING",
                            onTap: () {},
                          )
                          : GlobalPrimarySmallButton(
                            text: "INVITE",
                            onTap: () {},
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

class RequestTabWidget extends StatelessWidget {
  const RequestTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Request Tab"));
  }
}

class InvitedTabWidget extends StatelessWidget {
  const InvitedTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Invited Tab"));
  }
}

class PlayingTabWidget extends StatelessWidget {
  const PlayingTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Playing Tab"));
  }
}

class RetiredTabWidget extends StatelessWidget {
  const RetiredTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Retired Tab"));
  }
}
