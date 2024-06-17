import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/views/menu_screens/utilities/top_navigation_bar.dart';
import 'package:test_app/views/menu_screens/utilities/vocabulary_cards.dart';

class HomeScreen extends StatelessWidget {  
  
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double paddingValue = screenHeight * 0.2;

    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
          }else{
            SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
          }
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TopNavigationBar(isHome: true),
            ),
            Padding(
              padding: EdgeInsets.only(top: paddingValue),
              child: const CustomCardCarousel(),
            ),
          ],
        );
        },
      ),
    );
  }
}