import 'package:flutter/material.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';

class ExitParentalControlButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double leftOffset = screenWidth * 0.02;
    final double topOffset = screenHeight * 0.02;

    return Positioned(
      top: topOffset,
      left: leftOffset,
      child: Container(
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
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.exit_to_app_rounded, color: AppColors.whiteColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
