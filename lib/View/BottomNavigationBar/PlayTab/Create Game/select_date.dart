import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart'
    show AppTextStyle;
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/select_sport.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/Create%20Game/select_venue.dart';
import 'package:gkmarts/View/BottomNavigationBar/PlayTab/game_chat_details_screen.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_textfiled.dart' show GlobalTextField;
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectDate extends StatefulWidget {
  const SelectDate({super.key});

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "Select Date", showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.gradientGreyStart,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date", style: AppTextStyle.primaryText()),
                    Text(
                      _selectedDay != null
                          ? DateFormat("d MMM yyyy").format(
                            _selectedDay!,
                          ) //"Selected Date: ${_selectedDay!.toLocal().toString().split(' ')[0]}"
                          : "No date selected",
                      style: AppTextStyle.blackText(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat.yMMMM().format(_focusedDay), // "July 2025"
                    style: AppTextStyle.blackText(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime(
                              _focusedDay.year,
                              _focusedDay.month - 1,
                            );
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime(
                              _focusedDay.year,
                              _focusedDay.month + 1,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TableCalendar(
              headerVisible: false,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              enabledDayPredicate: (day) {
                // Allow only today and future dates
                return !day.isBefore(DateTime.now());
              },
              calendarStyle: CalendarStyle(
                selectedTextStyle: AppTextStyle.whiteText(),
                todayTextStyle: AppTextStyle.blackText(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                weekendTextStyle: AppTextStyle.blackText(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                outsideTextStyle: AppTextStyle.greytext(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                todayDecoration: BoxDecoration(
                  // color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.black, width: 0.5),
                ),
                selectedDecoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: AppTextStyle.blackText(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: AppTextStyle.blackText(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                weekendStyle: AppTextStyle.blackText(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  // color: Colors.red,
                ),
                decoration: BoxDecoration(color: Colors.grey.shade100),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: false,
                leftChevronVisible: false,
                rightChevronVisible: false,
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
              if (_selectedDay != null) {
                Navigator.pop(
                  context,
                  DateFormat("d MMM, yyyy").format(_selectedDay!).toString(),
                );
              } else {
                // Optionally show a warning if no date is selected
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Please select a date")));
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
