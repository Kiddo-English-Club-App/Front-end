import 'package:flutter/material.dart';
import 'package:test_app/views/menu_screens/interfaces/home_screen.dart';
import 'package:test_app/views/menu_screens/interfaces/trophies_screen.dart';
import 'package:test_app/views/menu_screens/utilities/user_button.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';

import 'parental_control_button.dart';

class TopNavigationBar extends StatelessWidget {
  final bool isHome;
  final bool isTrophies;

  TopNavigationBar({
    this.isHome = false,
    this.isTrophies = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.1;
    final buttonHeight = screenHeight * 0.17;
    final iconSize = buttonHeight * 0.6;
    final paddingSize = screenWidth * 0.02;
    final innerPaddingSize = screenWidth * 0.00;
    final textSize = buttonHeight * 0.26;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: paddingSize,
          child: ParentalControlButton(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildNavBarButton(
              icon: Icons.home,
              text: 'Home',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              isActive: isHome, // Indicador de botón activo
              buttonWidth: buttonWidth,
              buttonHeight: buttonHeight,
              iconSize: iconSize,
              paddingSize: innerPaddingSize,
              textSize: textSize,
            ),
            SizedBox(width: paddingSize), // Espacio horizontal entre los botones
            _buildNavBarButton(
              icon: Icons.emoji_events,
              text: 'Trophies',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TrophiesScreen()),
                );
              },
              isActive: isTrophies, // Indicador de botón inactivo
              buttonWidth: buttonWidth,
              buttonHeight: buttonHeight,
              iconSize: iconSize,
              paddingSize: innerPaddingSize,
              textSize: textSize,
            ),
            SizedBox(width: paddingSize), // Espacio horizontal entre el último botón y el botón de usuario
            SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: UserProfileButton(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavBarButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    required bool isActive,
    required double buttonWidth,
    required double buttonHeight,
    required double iconSize,
    required double paddingSize,
    required double textSize,
  }) {
    final Color backgroundColor = isActive ? AppColors.cianColor : AppColors.unselectedColor;

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: paddingSize),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: AppColors.whiteColor,
            ),
            SizedBox(height: paddingSize * 0.5),
            Text(
              text,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: textSize,
                fontFamily: 'OPTIVagRound-Bold',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
