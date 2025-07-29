import 'package:flutter/material.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart';

class SelectSport extends StatefulWidget {
  const SelectSport({super.key});

  @override
  State<SelectSport> createState() => _SelectSportState();
}

class _SelectSportState extends State<SelectSport> {
  final searchController = TextEditingController();
  int? selectedIndex;
  List<String> sports = ["Cricket", "Football", "Badminton"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(
        title: "Select Sport",
        showBackButton: true,
        onBackTap: () {
          Navigator.pop(context, 'Cricket');
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: 'Type Sport',
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.5),
                    child: Image.asset(
                      "assets/images/search.png",
                      height: 5,
                      width: 5,
                      color: AppColors.grey,
                    ),
                  ),
                  hintStyle: AppTextStyle.greytext(),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 15),
                itemCount: sports.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/badmintonIcon.png",
                            height: 20,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            sports[index],
                            style: AppTextStyle.blackText(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color:
                                  isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.profileSectionButtonColor,
                AppColors.profileSectionButtonColor2,
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ElevatedButton(
            onPressed: () {
              if (selectedIndex != null) {
                Navigator.pop(context, sports[selectedIndex!]);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please select a sport")),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "SELECT",
              style: AppTextStyle.whiteText(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
