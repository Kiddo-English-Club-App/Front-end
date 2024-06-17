import 'package:flutter/material.dart';
import 'package:test_app/views/global_utilities/avatar_image_service_widget.dart';
import 'package:test_app/views/global_utilities/global_variables.dart';
import 'package:test_app/views/intial_screens/interfaces/main_screen.dart';
import 'package:test_app/views/intial_screens/interfaces/user/select_user_screen.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';

class UserProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: Colors.black.withOpacity(0.5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    tileColor: AppColors.cianColor, // Establece el color de fondo del ListTile
                    title: const Text(
                      'Select another user',
                      style: TextStyle(color: AppColors.whiteColor), // Establece el color del texto dentro del ListTile
                    ),
                    onTap: () {
                      GlobalVariables.userSelectedImagePath = null;
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UserScreen()),);
                    },
                  ),
                  ListTile(
                    tileColor: AppColors.cianColor, // Establece el color de fondo del ListTile
                    title: const Text(
                      'Log Out',
                      style: TextStyle(color: AppColors.whiteColor), // Establece el color del texto dentro del ListTile
                    ),
                    onTap: () {
                      GlobalVariables.userSelectedImagePath = null;
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: CircleAvatarImageService(
        filename: GlobalVariables.userSelectedImagePath != null 
          ? GlobalVariables.userSelectedImagePath!
          : 'male_1.png',
      ),           
    );
  }
}
