import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/views/menu_screens/utilities/top_navigation_bar.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';

import '../../../view_model/achievement/iachievement_view_model.dart';

class TrophiesScreen extends StatefulWidget {
  
  @override
  State<TrophiesScreen> createState() => _TrophiesScreenState();
}

class _TrophiesScreenState extends State<TrophiesScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IAchievementViewModel>(context, listen: false).fetchAchievements();
    });
  }

  @override
  Widget build(BuildContext context) {
    final achievementViewModel = Provider.of<IAchievementViewModel>(context);
    return Scaffold(
      body: Column(
        children: [
          TopNavigationBar(isTrophies: true,),
          Expanded(
                  child: achievementViewModel.isLoading
                    ? const Center(
                      child: CircularProgressIndicator(),
                    )
                    : achievementViewModel.errorMessage.isNotEmpty
                      ? Center(
                          child: Text('Error: ${achievementViewModel.errorMessage}', style: TextStyle(color: AppColors.redColor, fontSize: 20),),
                      )
                      : achievementViewModel.errorMessage.isNotEmpty
                        ? Text('Error: ${achievementViewModel.errorMessage}')
                        : ListView.builder(
                            itemCount: (achievementViewModel.achievements.length / 2).ceil(),
                            itemBuilder: (BuildContext context, int index) {
                              final int startIndex = index * 2;
                              final bool isOdd = startIndex + 1 >= achievementViewModel.achievements.length;
                              print(achievementViewModel.achievements.length);
                              return Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                                  TrophieContainer(
                                    theme: achievementViewModel.achievements[startIndex].theme,
                                    message: achievementViewModel.achievements[startIndex].message,
                                  ),
                                  if (!isOdd) SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                                  if (!isOdd)
                                    TrophieContainer(
                                      theme: achievementViewModel.achievements[startIndex + 1].theme,
                                      message: achievementViewModel.achievements[startIndex + 1].message,
                                    ),
                                ],
                              );
                            },
                          ),
                )
        ],
      ),
    );
  }
}


class TrophieContainer extends StatelessWidget {
  final String theme;
  final String message;

  const TrophieContainer({Key? key, required this.theme, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double titleContainer = screenHeight * 0.15;
    final double heightContainerTrophie = screenHeight * 0.275;
    final double widthContainerTrophie = screenWidth * 0.4;

    return Container(
      width: screenWidth * 0.47,
      height: screenHeight * 0.4,
      alignment: Alignment.topLeft,
      child: Stack(
        children: [
          Positioned(
            top: titleContainer * 0.5,
            left: 0,
            child: Container(
              height: heightContainerTrophie,
              width: widthContainerTrophie,
              decoration: BoxDecoration(
                color: AppColors.cianColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(screenWidth * 0.02)),
              ),
              child: Container(
                height: heightContainerTrophie,
                width: widthContainerTrophie,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: widthContainerTrophie * 0.75,
                      child: Padding(
                        padding: EdgeInsets.only(left: widthContainerTrophie * 0.02, bottom: heightContainerTrophie * 0.01),
                        child: Text(
                          message,
                          style: TextStyle(
                            fontSize: screenHeight * 0.06,
                            color: Colors.white,
                            fontFamily: 'OPTIVagRound-Bold',
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: titleContainer,
              width: screenWidth * 0.17,
              decoration: BoxDecoration(
                color: AppColors.greenColor,
                borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.02)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  theme,
                  style: TextStyle(
                    fontSize: screenHeight * 0.05,
                    color: Colors.white,
                    fontFamily: 'OPTIVagRound-Bold',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            top: heightContainerTrophie * 0.1,
            left: screenWidth * 0.31,
            child: Container(
              height: screenHeight * 0.35,
              width: screenHeight * 0.35,
              decoration: BoxDecoration(
                color: AppColors.yellowColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(screenHeight * 0.6 / 2),
                child: Image.asset(
                  'assets/img/items/trophie.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
