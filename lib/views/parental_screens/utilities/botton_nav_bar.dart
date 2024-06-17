import 'package:flutter/material.dart';
import 'package:test_app/views/parental_screens/interfaces/account_screen.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';
import 'package:test_app/views/parental_screens/interfaces/kids_report_screen.dart';

class CustomBottonNavigationBar extends StatelessWidget {
  final bool isChildren;
  final bool isAccount;

  const CustomBottonNavigationBar({
    this.isChildren = false,
    this.isAccount = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.1;
    final buttonHeight = screenHeight * 0.13;
    final iconSize = buttonHeight * 0.6;
    final paddingSize = screenWidth * 0.15;
    final innerPaddingSize = screenWidth * 0.00;
    final textSize = buttonHeight * 0.25;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavBarButton(
              icon: Icons.child_friendly,
              text: 'Niños',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => KidReportScreen()),
                );
              },
              isActive: isChildren, // Indicador de botón activo
              buttonWidth: buttonWidth,
              buttonHeight: buttonHeight,
              iconSize: iconSize,
              paddingSize: innerPaddingSize,
              textSize: textSize,
            ),
            SizedBox(width: paddingSize), // Espacio horizontal entre los botones
            _buildNavBarButton(
              icon: Icons.account_circle,
              text: 'Cuenta',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                );
              },
              isActive: isAccount, // Indicador de botón inactivo
              buttonWidth: buttonWidth,
              buttonHeight: buttonHeight,
              iconSize: iconSize,
              paddingSize: innerPaddingSize,
              textSize: textSize,
            ),
          ],
        ),
      ),
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

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
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
