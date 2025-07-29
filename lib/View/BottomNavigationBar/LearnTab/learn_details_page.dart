import 'package:flutter/material.dart';
import 'package:gkmarts/Models/Learn/learn_model.dart';

import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:share_plus/share_plus.dart';

class LearnDetailsPage extends StatelessWidget {
  final VlogModel vlog;

  const LearnDetailsPage({super.key, required this.vlog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          vlog.title,
          style: AppTextStyle.blackText(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full width image
            ClipRRect(
              // borderRadius: const BorderRadius.only(
              //   bottomLeft: Radius.circular(12),
              //   bottomRight: Radius.circular(12),
              // ),
              child: Image.network(
                vlog.imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Material(
                  elevation: 0,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () {
                      SharePlus.instance.share(
                        ShareParams(
                          text: '${vlog.title}\n\n${vlog.description}',
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.share,
                            size: 16,
                            color: Color(0xFF1C274C),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Share",
                            style: AppTextStyle.blackText(
                              fontSize: 13,
                              color: const Color(0xFF1C274C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Title & Date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vlog.title, style: AppTextStyle.titleText()),
                  const SizedBox(height: 6),
                  Text(
                    vlog.datePost,
                    style: AppTextStyle.greytext(fontSize: 12),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    vlog.description,
                    style: AppTextStyle.greytext(
                      fontSize: 14,
                      color: AppColors.borderColor,
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
