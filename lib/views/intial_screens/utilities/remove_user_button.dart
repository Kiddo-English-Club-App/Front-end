import 'package:flutter/material.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';

class RemoveUserButton extends StatelessWidget {
  final Function onPressed;

  const RemoveUserButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double leftOffset = screenWidth * 0.03;
    final double bottomOffset = screenHeight * 0.05;

    return Positioned(
      bottom: bottomOffset,
      left: leftOffset,
      child: Container(
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
          icon: Icon(Icons.person_remove, color: AppColors.whiteColor),
          onPressed: onPressed(),
        ),
      ),
    );
  }
}
