// ignore_for_file: must_be_immutable
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';
import 'package:test_app/views/global_utilities/container_image_service_widget.dart';
import 'package:test_app/views/global_utilities/global_variables.dart';
import 'package:test_app/views/menu_screens/interfaces/select_game.dart';

import '../../../services/report/score_service.dart';
import '../../../services/theme/theme_service.dart';

class FeedbackWidget extends StatefulWidget {
  final List<Item> vocabulary;
  final Widget gameScreen;
  late Soundpool _soundpool;
  int points;
  double time;

  FeedbackWidget({Key? key, required this.vocabulary, required this.gameScreen, required this.points, required this.time}) : super(key: key) {
    _soundpool = Soundpool();
  }

  @override
  State<FeedbackWidget> createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        backgroundColor: AppColors.yellowColor,
        content: SingleChildScrollView(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildRow(context, widget.vocabulary.take(4).toList()),
                  SizedBox(height: screenHeight * 0.025),
                  _buildRow(context, widget.vocabulary.skip(4).take(3).toList()),
                ],
              ),
              SizedBox(width: screenWidth * 0.02),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: screenHeight * 0.1,
                    width: screenHeight * 0.1,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cianColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.blackColor.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ]),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => widget.gameScreen),
                        );
                      },
                      child: const Icon(
                        Icons.replay,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.05),
                  Container(
                    height: screenHeight * 0.1,
                    width: screenHeight * 0.1,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cianColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.blackColor.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ]),
                    child: GestureDetector(
                      onTap: () async {
                        print('Score: ${widget.points}| Time: ${widget.time} secs| theme ID: ${GlobalVariables.themeID}');
                        ScoreService scoreService = ScoreService();
                        await scoreService.sendScore(
                          themeId: GlobalVariables.themeID,
                          points: widget.points,
                          time: widget.time,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SelectGameScreen()),
                        );
                      },
                      child: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<Item> entries) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: entries.map((entry) {
        return _buildVocabularyItem(context, entry);
      }).toList(),
    );
  }

  Widget _buildVocabularyItem(BuildContext context, Item entry) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _playSound(entry.sound);
          },
          child: ContainerImageService(filename: entry.image, sizeImage: screenHeight * 0.25),
        ),
        Text(
          entry.name,
          style: TextStyle(color: AppColors.blackColor, fontSize: screenHeight * 0.05, fontFamily: 'JUA'),
        ),
      ],
    );
  }

  void _playSound(String soundPath) async {
    print(soundPath);
    ByteData soundData = await rootBundle.load('assets/sounds/$soundPath');
    int soundId = await widget._soundpool.load(soundData);
    widget._soundpool.play(soundId);
  }
}
