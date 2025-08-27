import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gkmarts/Models/GenaralModels/coins_model.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:provider/provider.dart';

class MyCoins extends StatelessWidget {
  const MyCoins({super.key});

  @override
  Widget build(BuildContext context) {
    final coinsModel = context.watch<HomeTabProvider>().coinsModel;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          const GlobalAppBar(title: "My Coins", showBackButton: true),

          // if (coinsModel == null)
          //   const Expanded(child: Center(child: Text("No coin data available")))
          // else
          //   Expanded(
          //     child: SingleChildScrollView(
          //       padding: const EdgeInsets.all(16),
          //       child: MyCoinsCard(coinsModel: coinsModel),
          //     ),
          //   ),
          if (coinsModel == null)
            const Expanded(child: Center(child: Text("No coin data available")))
          else
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: MyCoinsCard(coinsModel: coinsModel),
              ),
            ),
        ],
      ),
    );
  }
}

class MyCoinsCard extends StatefulWidget {
  final CoinsModel coinsModel;

  const MyCoinsCard({super.key, required this.coinsModel});

  @override
  State<MyCoinsCard> createState() => _MyCoinsCardState();
}

class _MyCoinsCardState extends State<MyCoinsCard> {
  late Timer _timer;
  String countdown = "";

  final List<Map<String, dynamic>> referrals = [
    {
      "coins": "500",
      "name": "Sahil Khambe",
      "status": "Available",
      "expiry": "1 August, 2025",
    },
    {
      "coins": "500",
      "name": "Sahil Khambe",
      "status": "Used",
      "expiry": "1 August, 2025",
    },
    {
      "coins": "500",
      "name": "Sahil Khambe",
      "status": "Expired",
      "expiry": "1 August, 2025",
    },
  ];

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateCountdown(),
    );
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final remaining = widget.coinsModel.bonusExpiry.difference(now);

    setState(() {
      countdown =
          remaining.isNegative
              ? "Expired"
              : "${remaining.inDays}d "
                  "${remaining.inHours % 24}h "
                  "${remaining.inMinutes % 60}m "
                  "${remaining.inSeconds % 60}s";
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.coinsModel;
    final formattedDate = formatFullDate(model.bonusExpiry);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Increased opacity
                blurRadius: 8, // Increased blur to match search field shadow
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text("Welcome Bonus Coins", style: AppTextStyle.titleText()),
                  ],
                ),

                const SizedBox(height: 16),

                // Current Balance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Current Balance",
                      style: AppTextStyle.blackText(fontSize: 14),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${model.remainingBonusCoins}",
                            style: AppTextStyle.blackText(
                              fontSize: 12,
                              fontWeight: FontWeight.w600, // bold part
                            ),
                          ),
                          TextSpan(
                            text: " / ${model.totalCoins} coins",
                            style: AppTextStyle.blackText(
                              fontSize: 12,
                              fontWeight: FontWeight.w400, // normal part
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Bookings Used
                _infoRow(
                  title: "Bookings Used",
                  value: "${model.bonusBookingsUsed} / 10 bookings",
                ),

                const SizedBox(height: 8),

                // Expiry Date
                _infoRow(
                  title: "Coins Expire On",
                  value: formattedDate,
                  valueStyle: const TextStyle(fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 8),

                // Countdown
                if (countdown != "Expired") ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Time Left",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          countdown,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                // Usage Info Box
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.redAccent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "You can use up to 500 coins per booking. "
                          "you can used exactly 500 coins per booking .",
                          style: AppTextStyle.blackText(
                            fontSize: 13,
                            color: AppColors.greytext,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Referred Coins",
              style: AppTextStyle.titleText(
                // fontSize: 14,
                // color: AppColors.black,
              ),
            ),
          ],
        ),
        // SizedBox(height: 20),
        Column(
          children:
              referrals.map((user) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Card(
                    elevation: 3,
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      spacing: 5,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.monetization_on,
                                  size: 16,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    "Coins Earned:",
                                    style: AppTextStyle.blackText(
                                      fontSize: 14,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  user['coins'],
                                  style: AppTextStyle.blackText(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 2,
                            bottom: 2,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 16,
                                color: AppColors.black,
                              ),
                              SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  "Refered User:",
                                  style: AppTextStyle.blackText(fontSize: 14),
                                ),
                              ),
                              Spacer(),
                              Text(
                                user['name'],
                                style: AppTextStyle.blackText(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  // color: AppColors.greytext,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 2,
                            bottom: 2,
                          ),
                          child: Row(
                            children: [
                              // user['status'] == ""
                              Icon(
                                Icons.redeem,
                                size: 16,
                                color: AppColors.black,
                              ),
                              SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  "Redeem Status:",
                                  style: AppTextStyle.blackText(fontSize: 14),
                                ),
                              ),
                              Spacer(),
                              Text(
                                user['status'],
                                style: AppTextStyle.blackText(
                                  fontSize: 14,
                                  color:
                                      user['status'] == "Used"
                                          ? AppColors.successColor
                                          : user['status'] == "Expired"
                                          ? AppColors.primaryColor
                                          : AppColors.greytext,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 2,
                            bottom: 8,
                          ),
                          child:
                              user['status'] == "Used"
                                  ? SizedBox()
                                  : Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        size: 16,
                                        color: AppColors.black,
                                      ),
                                      SizedBox(width: 2),
                                      Expanded(
                                        child: Text(
                                          "Expiry Date:",
                                          style: AppTextStyle.blackText(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        user['expiry'],
                                        style: AppTextStyle.blackText(
                                          fontSize: 14,
                                          color: AppColors.greytext,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _infoRow({
    required String title,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyle.blackText(fontSize: 14)),
        Text(
          value,
          style:
              valueStyle ??
              AppTextStyle.blackText(fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
