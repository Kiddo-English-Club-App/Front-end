import 'package:flutter/material.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';

class CustomCianElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomCianElevatedButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: customButtonStyle(),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontFamily: 'OPTIVagRound-Bold',
        ),
      ),
    );
  }

  ButtonStyle customButtonStyle({
    double elevation = 3,
    Color shadowColor = Colors.black,
    Size minimumSize = const Size(100, 35),
    Color backgroundColor = AppColors.cianColor,
  }) {
    return ButtonStyle(
      elevation: MaterialStateProperty.all<double>(elevation),
      shadowColor: MaterialStateProperty.all<Color>(shadowColor),
      minimumSize: MaterialStateProperty.all<Size>(minimumSize),
      backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
    );
  }
}
