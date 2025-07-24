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

          if (coinsModel == null)
            const Expanded(child: Center(child: Text("No coin data available")))
          else
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
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

    return Container(
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
                SvgPicture.asset(
                  "assets/images/coins.svg",
                  height: 28,
                  width: 28,
                ),
                const SizedBox(width: 10),
                Text("My Coins", style: AppTextStyle.titleText()),
              ],
            ),

            const SizedBox(height: 16),

            // Current Balance
            _infoRow(
              title: "Current Balance",
              value: "${model.remainingBonusCoins} / ${model.totalCoins} coins",
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "You can use up to 500 coins per booking. "
                      "Coins can be used across up to 10 bookings.",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
