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

  const GlobalAppBar({
    Key? key,
    required this.title,
    this.centerTitle = false,
    this.showBackButton = false,
    this.onBackTap,
    this.actions,
    this.backIcon = Icons.arrow_back,
    this.backgroundColor = AppColors.bgColor,
    this.titleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading:
          showBackButton
              ? IconButton(
                icon: Icon(backIcon, color: Colors.black, size: 23),
                onPressed: onBackTap ?? () => Navigator.of(context).pop(),
              )
              : null,
      title: Text(
        title,
        style:
            titleStyle ??
            AppTextStyle.blackText(fontSize: 17.h, fontWeight: FontWeight.w600),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
