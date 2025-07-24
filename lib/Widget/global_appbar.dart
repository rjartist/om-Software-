import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final List<Widget>? actions;
  final IconData backIcon;
  final Color backgroundColor;
  final TextStyle? titleStyle;
  final bool isHomeScreen;

  const GlobalAppBar({
    Key? key,
    required this.title,
    this.centerTitle = false,
    this.showBackButton = false,
    this.onBackTap,
    this.actions,
    this.backIcon = Icons.arrow_back,
    this.backgroundColor = AppColors.white,
    this.titleStyle,
    this.isHomeScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 56,
      centerTitle: centerTitle,
      titleSpacing: 0,
      leading:
          showBackButton
              ? IconButton(
                icon: Icon(backIcon, color: Colors.black, size: 23),
                onPressed: onBackTap ?? () => Navigator.of(context).pop(),
              )
              : null,
      title:
          isHomeScreen == true
              ? Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  title,
                  style:
                      titleStyle ??
                      AppTextStyle.blackText(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
              : Text(
                title,
                style:
                    titleStyle ??
                    AppTextStyle.blackText(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
