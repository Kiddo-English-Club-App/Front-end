import 'package:flutter/material.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';
import 'package:test_app/views/menu_screens/interfaces/select_game.dart';

class PauseButtonPositioned extends StatefulWidget {
  final Widget redirectWidget; // Widget a redirigir al presionar el botón

  PauseButtonPositioned({required this.redirectWidget});

  @override
  _PauseButtonPositionedState createState() => _PauseButtonPositionedState();
}

class _PauseButtonPositionedState extends State<PauseButtonPositioned> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      top: screenHeight*0.03,
      left: screenWidth*0.02,
      child: Container(
        height: screenHeight*0.1,
        width: screenHeight*0.1,
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
          ]
        ),
        child: GestureDetector(
        onTap: () {
          _showPauseMenu(context);
        },
        child: Icon(
          Icons.pause,
          color: AppColors.whiteColor,
        ),
      ),
      )
    );
  }

  void _showPauseMenu(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.yellowColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Paused', textAlign: TextAlign.center, style: TextStyle(fontSize: screenHeight*0.08, fontFamily: 'OPTIVagRound-Bold', color: AppColors.blackColor),),
              SizedBox(height: screenHeight*0.05,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cianColor
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Continue', textAlign: TextAlign.center, style: TextStyle(fontSize: screenHeight*0.05, fontFamily: 'OPTIVagRound-Bold', color: AppColors.whiteColor)),
              ),
              SizedBox(height: screenHeight*0.025,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cianColor
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => widget.redirectWidget),
                  );
                },
                child: Text('Restart', textAlign: TextAlign.center, style: TextStyle(fontSize: screenHeight*0.05, fontFamily: 'OPTIVagRound-Bold', color: AppColors.whiteColor)),
              ),
              SizedBox(height: screenHeight*0.025,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cianColor
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectGameScreen()),
                  );
                },
                child: Text('Quit', textAlign: TextAlign.center, style: TextStyle(fontSize: screenHeight*0.05, fontFamily: 'OPTIVagRound-Bold', color: AppColors.whiteColor)),
              ),
            ],
          ),
        );
      },
    );
  }
}
