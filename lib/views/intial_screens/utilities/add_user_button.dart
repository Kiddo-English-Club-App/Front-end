import 'package:flutter/material.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';
import 'package:test_app/views/intial_screens/interfaces/user/add_user_screen.dart';

class AddUserButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double rightOffset = screenWidth * 0.03;
    final double bottomOffset = screenHeight * 0.05;

    return Positioned(
      bottom: bottomOffset,
      right: rightOffset,
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
          icon: const Icon(Icons.person_add, color: AppColors.whiteColor),
          onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserScreen()),
          );
          },
        ),
      ),
    );
  }
}
