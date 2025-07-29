import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/HomePage/learn_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/BottomNavigationBar/HomeTab/home_header.dart';
import 'package:gkmarts/View/BottomNavigationBar/LearnTab/learn_details_page.dart';
import 'package:gkmarts/Widget/network_status_banner.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class LearnTab extends StatefulWidget {
  const LearnTab({super.key});

  @override
  State<LearnTab> createState() => _LearnTabState();
}

class _LearnTabState extends State<LearnTab> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
void dispose() {
  _tabController?.dispose();
  super.dispose();
}


  @override
  void initState() {
    super.initState();

    final provider = context.read<LearnProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.getListOfGames();

      _tabController = TabController(
        length: provider.gameList.length,
        vsync: this,
        initialIndex: provider.selectedIndex,
      );

      _tabController?.addListener(() {
        final newIndex = _tabController!.index;

        // ✅ Only update if it’s different
        if (provider.selectedIndex != newIndex) {
          provider.updateSelectedIndex(newIndex);
        }
      });

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LearnProvider>();

    if (_tabController == null) {
      return const Center(child: CupertinoActivityIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          const NetworkStatusBanner(),
           HomeHeader(),
          vSizeBox(20),
          Consumer<LearnProvider>(
            builder: (_, provider, __) {
              return GameChipList(
                tabController: _tabController!,
                provider: provider,
              );
            },
          ),

          vSizeBox(20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children:
                  provider.gameList.map((game) {
                    return const VlogListSection(); // will auto change based on provider
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class GameChipList extends StatelessWidget {
  final TabController tabController;
  final LearnProvider provider;

  const GameChipList({
    super.key,
    required this.tabController,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: provider.gameList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 25),
        itemBuilder: (context, index) {
          final game = provider.gameList[index];
          final isSelected = index == provider.selectedIndex;

          return GestureDetector(
            onTap: () {
              tabController.animateTo(index);
             
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  game.title,
                  style: AppTextStyle.blackText(
                    color: isSelected ? AppColors.white : AppColors.borderColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class VlogListSection extends StatelessWidget {
  const VlogListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LearnProvider>(
      builder: (context, provider, _) {
        if (provider.isGameListDataLaoding) {
          return CupertinoActivityIndicator();
        }

        if (provider.vlogList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text("No vlogs available."),
          );
        }

        return ListView.separated(
          // shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: provider.vlogList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final vlog = provider.vlogList[index];

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LearnDetailsPage(vlog: vlog),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          vlog.imageUrl,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Text section (70%)
                    Flexible(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vlog.title,
                            style: AppTextStyle.blackText(
                              fontSize: 15,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            vlog.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.greytext(fontSize: 13),
                          ),
                          const SizedBox(height: 12),

                          // Bottom Row: Date + Share
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                vlog.datePost,
                                style: AppTextStyle.greytext(fontSize: 12),
                              ),
                              InkWell(
                                onTap: () {
                                  // TODO: Add share functionality
                                },
                                borderRadius: BorderRadius.circular(
                                  4,
                                ), // optional: ripple shape
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.share,
                                        size: 16,
                                        color: Color(0xFF1C274C),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Share",
                                        style: AppTextStyle.blackText(
                                          fontSize: 12,
                                          color: const Color(0xFF1C274C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class VlogListShimmer extends StatelessWidget {
  const VlogListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Image placeholder
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 12),

                // Text placeholder
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: MediaQuery.of(context).size.width * 0.3,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 10,
                            width: 60,
                            color: Colors.grey[300],
                          ),
                          Container(
                            height: 10,
                            width: 50,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
