import 'package:flutter/material.dart';
import 'package:gkmarts/Models/HomeTab_Models/Venue_detail_model.dart';
import 'package:gkmarts/Provider/HomePage/book_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/booking_proceed_pay.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingDateTimePage extends StatelessWidget {
  final VenueDetailModel model;

  const BookingDateTimePage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookTabProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "Booking", showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 25,
          children: [
            buildAvailableSports(context, model, provider),

            buildDateSelector(context, provider),

            buildSlotDropdown(context, provider),

            buildTimeAndDuration(context, provider),

            buildTurfSelector(context, model, provider),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total: ₹${provider.totalPriceBeforeDiscountall}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            GlobalSmallButton(
              text: "Next",
              onTap: () {
                if (provider.selectedTurfIndexes.isEmpty) {
                  GlobalSnackbar.error(context, "Please select a turf.");
                  return;
                }

                if (provider.selectedStartTime.hour == 16 &&
                    provider.selectedStartTime.minute == 0) {
                  GlobalSnackbar.error(context, "Please select a time.");
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BookingProceedPayPage(
                          model: model,
                          totalAmount: provider.totalPriceBeforeDiscountall,
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTurfSelector(
    BuildContext context,
    VenueDetailModel model,
    BookTabProvider provider,
  ) {
    final maxTurf = model.turfCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Turf(s)", style: AppTextStyle.titleSmallText()),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(maxTurf, (index) {
            final count = index + 1;
            final isSelected = provider.selectedTurfIndexes.contains(index);

            return GestureDetector(
              onTap: () => provider.toggleTurfSelection(index),
              child: Container(
                width: 80,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Text(
                  "Turf $count",
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget buildTimeAndDuration(BuildContext context, BookTabProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // TIME Box
        GestureDetector(
          onTap: () async {
            final now = TimeOfDay.now();
            final picked = await showTimePicker(
              context: context,
              initialTime: provider.selectedStartTime,
            );

            if (picked != null) {
              // Only prevent past time if selected date is today
              final isToday = DateUtils.isSameDay(
                provider.selectedDate,
                DateTime.now(),
              );

              if (isToday) {
                final nowMinutes = now.hour * 60 + now.minute;
                final pickedMinutes = picked.hour * 60 + picked.minute;

                if (pickedMinutes >= nowMinutes) {
                  provider.setStartTime(picked);
                } else {
                  GlobalSnackbar.error(
                    navigatorKey.currentContext!,
                    "Please select a time in the future",
                  );
                }
              } else {
                // Allow any time for future dates
                provider.setStartTime(picked);
              }
            }
          },

          child: Container(
            width: 170,
            height: 69,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "TIME",
                  style: AppTextStyle.primaryText(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.timeRangeString,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // DURATION Box
        Container(
          width: 170,
          height: 69,

          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "DURATION",
                style: AppTextStyle.primaryText(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: provider.decrementDuration,
                    child: const Icon(Icons.remove_circle_outline, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "${provider.selectedDurationInHours} hr",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: provider.incrementDuration,
                    child: const Icon(Icons.add_circle_outline, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSlotDropdown(BuildContext context, BookTabProvider provider) {
    final List<String> slotOptions = ["8:00 AM", "10:00 AM", "12:00 PM"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Slot", style: AppTextStyle.titleSmallText()),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: provider.selectedSlot,
              hint: Text(
                "Choose a slot",
                style: AppTextStyle.blackText(fontSize: 14),
              ),
              items:
                  slotOptions.map((String slot) {
                    return DropdownMenuItem<String>(
                      value: slot,
                      child: Text(
                        slot,
                        style: AppTextStyle.blackText(fontSize: 14),
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  provider.selectSlot(value);
                }
              },
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDateSelector(BuildContext context, BookTabProvider provider) {
    final now = DateTime.now();
    final days = List.generate(5, (index) => now.add(Duration(days: index)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Select Date", style: AppTextStyle.titleSmallText()),
            IconButton(
              icon: const Icon(
                Icons.calendar_month,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  isScrollControlled:
                      true, // Allows full height control with FractionallySizedBox
                  builder: (_) {
                    return FractionallySizedBox(
                      heightFactor: 0.55, // Adjust height (0.0 - 1.0)
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Drag handle
                            Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),

                            // Title
                            Text(
                              "Select a Date",
                              style: AppTextStyle.titleSmallText(),
                            ),
                            const SizedBox(height: 12),

                            // Calendar
                            Expanded(
                              child: TableCalendar(
                                firstDay: DateTime.now(),
                                lastDay: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                                focusedDay: provider.selectedDate,
                                selectedDayPredicate:
                                    (day) =>
                                        isSameDay(provider.selectedDate, day),
                                onDaySelected: (selectedDay, _) {
                                  provider.selectDate(selectedDay);
                                  Navigator.pop(
                                    context,
                                  ); // Close after selection
                                },
                                calendarStyle: const CalendarStyle(
                                  selectedDecoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  todayDecoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                headerStyle: const HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                  // titleText: TextStyle(
                                  //   fontWeight: FontWeight.bold,
                                  //   fontSize: 16,
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (_, index) {
              final date = days[index];
              final isSelected = isSameDay(provider.selectedDate, date);

              return GestureDetector(
                onTap: () => provider.selectDate(date),
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? AppColors.primaryColor
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('MMM').format(date).toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('E').format(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.black,
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
    );
  }

  Widget buildAvailableSports(
    BuildContext context,
    VenueDetailModel model,
    BookTabProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: model.availableSports.length,
              itemBuilder: (_, index) {
                final sport = model.availableSports[index];
                final isSelected = provider.selectedSport == sport.sportName;
                return GestureDetector(
                  onTap: () => provider.selectSport(sport.sportName),
                  child: Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isSelected
                              ? AppColors.primaryColor
                              : Colors.transparent,
                      border: Border.all(
                        color: AppColors.borderColor,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.network(
                            sport.image,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sport.sportName,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
