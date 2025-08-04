import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gkmarts/Models/BookTabModel/venue_detail_model.dart';
import 'package:gkmarts/Provider/HomePage/HomeTab/home_tab_provider.dart';
import 'package:gkmarts/Provider/HomePage/book_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/apply_coupen_book.dart';
import 'package:gkmarts/View/BottomNavigationBar/BookTab/congratulation_booking.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookingProceedPayPage extends StatelessWidget {
  final VenueDetailModel model;
  final int totalAmount;

  const BookingProceedPayPage({
    super.key,
    required this.model,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookTabProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: GlobalAppBar(title: "Booking", showBackButton: true),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookingInfoCard(model: model, provider: provider),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ApplyCouponPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Apply Coupon",
                              style: AppTextStyle.primaryText(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppColors.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const RedeemCoinsWidget(),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSummaryRow(
                            "Court Fee",
                            "₹${provider.courtFee.toStringAsFixed(2)}",
                            icon: Icons.payments_rounded,
                          ),

                          _buildSummaryRow(
                            "Coupon Discount",
                            "- ₹${provider.offerDiscount.toStringAsFixed(2)}",
                            icon: Icons.local_offer_outlined,
                          ),
                          // if (provider.useCoins && provider.appliedCoins > 0)
                          _buildSummaryRow(
                            "Coin Redemption",
                            "- ₹${provider.coinDiscount.toStringAsFixed(2)}",
                            icon: Icons.monetization_on_outlined,
                          ),

                          const Divider(height: 24),

                          _buildSummaryRow(
                            "Sub Total",
                            "₹${provider.subTotal.toStringAsFixed(2)}",
                            isTotal: true,
                          ),

                          const SizedBox(height: 12),

                          // Convenience Fee with toggle
                          InkWell(
                            onTap: () => provider.toggleConvenienceBreakdown(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Convenience Fee",
                                      style: AppTextStyle.blackText(
                                        fontSize: 14,
                                        // fontWeight: FontWeight.5,
                                      ),
                                    ),

                                    const SizedBox(width: 6),
                                    Icon(
                                      provider.showConvenienceBreakdown
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      size: 20,
                                      color: Colors.grey[600],
                                    ),
                                  ],
                                ),
                                Text(
                                  "₹${provider.convenienceFee.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (provider.showConvenienceBreakdown) ...[
                            const SizedBox(height: 8),
                            _buildSummaryRow(
                              "Platform Fee (2%)",
                              "₹${provider.platformFee.toStringAsFixed(2)}",
                              color: Colors.grey[700],
                              // icon: Icons.foundation,
                            ),
                            _buildSummaryRow(
                              "GST (18% of Platform Fee)",
                              "₹${provider.gstOnPlatformFee.toStringAsFixed(2)}",
                              color: Colors.grey[700],
                              // icon: Icons.receipt_long,
                            ),
                          ],

                          const Divider(height: 24),

                          _buildSummaryRow(
                            "Total Amount",
                            "₹${provider.finalPayableAmount.toStringAsFixed(2)}",
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80), // space for bottom bar
                  ],
                ),
              ),
            ),
          );
        },
      ),

      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      //   child: GestureDetector(
      //     onTap: () {
      //       // provider.proceedToPay(model);
      //       provider.initiatePaymentAndProceed(model);
      //     },
      //     child: Container(
      //       height: 50,
      //       decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //           begin: Alignment.topCenter,
      //           end: Alignment.bottomCenter,
      //           colors: [
      //             AppColors.profileSectionButtonColor,
      //             AppColors.profileSectionButtonColor2,
      //           ],
      //         ),
      //         borderRadius: BorderRadius.circular(10),
      //       ),
      //       padding: const EdgeInsets.symmetric(horizontal: 16),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Text(
      //             "₹${provider.finalPayableAmount}",
      //             style: const TextStyle(
      //               color: Colors.white,
      //               fontSize: 16,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //           Row(
      //             children: const [
      //               Text(
      //                 "PROCEED TO PAY",
      //                 style: TextStyle(
      //                   color: Colors.white,
      //                   fontWeight: FontWeight.w600,
      //                   fontSize: 14,
      //                 ),
      //               ),
      //               SizedBox(width: 6),
      //               Icon(
      //                 Icons.arrow_forward_ios,
      //                 size: 16,
      //                 color: Colors.white,
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      bottomNavigationBar: Consumer<BookTabProvider>(
        builder:
            (_, provider, __) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: GestureDetector(
                onTap:
                    provider.isProceedToPlay
                        ? null
                        : () => provider.initiatePaymentAndProceed(model),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.profileSectionButtonColor,
                        AppColors.profileSectionButtonColor2,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${provider.finalPayableAmount}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      provider.isProceedToPlay
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                          : Row(
                            children: const [
                              Text(
                                "PROCEED TO PAY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.white,
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? color,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) Icon(icon, size: 18, color: Colors.grey[700]),
              if (icon != null) const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyle.base(
                  fontSize: 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: AppTextStyle.base(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: color ?? (isTotal ? Colors.black : Colors.grey[800]!),
            ),
          ),
        ],
      ),
    );
  }
}

class RedeemCoinsWidget extends StatefulWidget {
  const RedeemCoinsWidget({super.key});

  @override
  State<RedeemCoinsWidget> createState() => _RedeemCoinsWidgetState();
}

class _RedeemCoinsWidgetState extends State<RedeemCoinsWidget> {
  final GlobalKey _infoKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    final coinsModel = context.read<HomeTabProvider>().coinsModel;
    final coinWalletId = coinsModel?.coinwalletid;
    if (coinWalletId != null) {
      context.read<BookTabProvider>().setCoinWalletId(coinWalletId);
    }
  }

  void _showTooltip(int availableCoins, bool canUseCoins) {
    final renderBox = _infoKey.currentContext!.findRenderObject() as RenderBox;
    final targetPosition = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: targetPosition.dy + 24,
            left: targetPosition.dx - 150 + 10, // adjust for center alignment
            width: 250,
            child: Material(
              color: Colors.transparent,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: 1,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Available Balance: $availableCoins coins",
                        style: AppTextStyle.whiteText(fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "This booking will use exactly 500 coins (worth ₹500).",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      if (!canUseCoins) ...[
                        const SizedBox(height: 4),
                        const Text(
                          "You need at least 500 coins.",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 3), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeTabProvider, BookTabProvider>(
      builder: (context, homeProvider, bookProvider, _) {
        final availableCoins =
            homeProvider.coinsModel?.remainingBonusCoins ?? 0;
        final isToggleOn = bookProvider.useCoins;
        final canUseCoins = availableCoins >= 500;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Title + Info Button
              Row(
                children: [
                  Text(
                    "Apply Bonus Coins",
                    style: AppTextStyle.primaryText(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    key: _infoKey,
                    onTap: () => _showTooltip(availableCoins, canUseCoins),
                    child: const Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              /// Toggle
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: isToggleOn,
                  activeColor: AppColors.primaryColor,
                  onChanged:
                      canUseCoins
                          ? (value) {
                            bookProvider.toggleUseCoins(value, availableCoins);
                            bookProvider.setCoins(
                              value ? 500 : 0,
                              availableCoins,
                            );
                          }
                          : (value) {
                            _showTooltip(
                              availableCoins,
                              false,
                            ); // optional fallback
                          },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BookingInfoCard extends StatelessWidget {
  final VenueDetailModel model;
  final BookTabProvider provider;

  const BookingInfoCard({
    super.key,
    required this.model,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        model.modifiedFacility.facilityImages.isNotEmpty
            ? model.modifiedFacility.facilityImages.first.image
            : '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ClipRRect(
          //   borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          //   child:
          //       imageUrl.isNotEmpty
          //           ? Image.network(
          //             imageUrl,
          //             width: double.infinity,
          //             height: 180,
          //             fit: BoxFit.cover,
          //             errorBuilder:
          //                 (context, error, stackTrace) => const SizedBox(
          //                   height: 180,
          //                   child: Center(
          //                     child: Icon(Icons.image_not_supported),
          //                   ),
          //                 ),
          //           )
          //           : const SizedBox(
          //             height: 180,
          //             child: Center(child: Icon(Icons.image_not_supported)),
          //           ),
          // ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildBookingDetails(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.modifiedFacility.facilityName,
          style: AppTextStyle.primaryText(),
        ),
        const SizedBox(height: 4),
        Text(
          model.modifiedFacility.address,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          Icons.flag,
          provider.selectedSport ?? "Selected Sport",
          isBold: true,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(Icons.calendar_today, _formatDate(provider.selectedDate)),
        const SizedBox(height: 8),
        _buildInfoRow(Icons.access_time, _getFormattedTimeRange(context)),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isBold = false}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyle.blackText(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat("dd MMM, yyyy (EEE)").format(date);
  }

  // String _getFormattedTimeRange(BuildContext context) {
  //   final start = provider.selectedStartTime;
  //   final endHour = (start.hour + provider.selectedDurationInHours) % 24;
  //   final end = TimeOfDay(hour: endHour, minute: start.minute);

  //   return "${_formatTime(context, start)} - ${_formatTime(context, end)}";
  // }
  String _getFormattedTimeRange(BuildContext context) {
    final start = provider.selectedStartTime;

    // Add minMinutesSport to start time
    final totalStartMinutes = start.hour * 60 + start.minute;
    final endTotalMinutes =
        totalStartMinutes + (provider.minMinutesSport ?? 60);

    final endHour = (endTotalMinutes ~/ 60) % 24;
    final endMinute = endTotalMinutes % 60;

    final end = TimeOfDay(hour: endHour, minute: endMinute);

    return "${_formatTime(context, start)} - ${_formatTime(context, end)}";
  }

  String _formatTime(BuildContext context, TimeOfDay time) {
    return time.format(context);
  }
}
