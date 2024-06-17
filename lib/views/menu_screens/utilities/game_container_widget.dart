import 'package:flutter/material.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';

class GameContainer extends StatelessWidget {
  final String gameName;
  final String gameDescription;
  final Widget redirectWidget;

  const GameContainer({
    Key? key,
    required this.gameName,
    required this.gameDescription,
    required this.redirectWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * 0.6;
    double containerWidth = MediaQuery.of(context).size.width * 0.25;

    return Container(
      height: containerHeight,
      width: containerWidth,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.cianColor,
          width: containerWidth * 0.03,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: AppColors.yellowColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            gameName,
            style: TextStyle(
              fontSize: containerHeight * 0.1,
              fontFamily: 'OPTIVagRound-Bold',
            ),
          ),
          SizedBox(height: containerHeight * 0.07),
          Text(
            gameDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: containerHeight * 0.07,
              fontFamily: 'VAG_Rounded_Regular',
            ),
          ),
          SizedBox(height: containerHeight * 0.07),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cianColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => redirectWidget),
              );
            },
            child: Text(
              'Play',
              style: TextStyle(
                fontSize: containerHeight * 0.07,
                color: AppColors.whiteColor,
                fontFamily: 'OPTIVagRound-Bold',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
