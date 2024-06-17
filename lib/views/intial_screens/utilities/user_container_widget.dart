import 'package:flutter/material.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';

class UserContainer extends StatelessWidget {
  final String imageUrl;
  final String username;
  final Function onPressed;
  final Function onDeletePressed;

  const UserContainer({
    Key? key,
    required this.imageUrl,
    required this.username,
    required this.onPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: deviceWidth * 0.04,
            height: deviceWidth * 0.04,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.redColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackColor.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              iconSize: deviceWidth * 0.02,
              icon: const Icon(Icons.remove, color: AppColors.whiteColor),
              onPressed: () {
                onDeletePressed();
              },
            ),
          ),
          SizedBox(height: deviceHeight * 0.02),
          CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
            radius: deviceWidth * 0.09,
          ),
          SizedBox(height: deviceHeight * 0.05),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
            ),
            onPressed: () {
              onPressed();
            },
            child: Text(
              username,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "OPTIVagRound-Bold",
                  fontSize: deviceHeight * 0.08),
            ),
          ),
        ],
      ),
    );
  }
}
