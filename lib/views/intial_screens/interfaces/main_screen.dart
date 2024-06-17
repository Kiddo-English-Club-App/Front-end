import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/views/intial_screens/interfaces/login/login.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';
import 'package:test_app/views/intial_screens/utilities/background_widget.dart';
import 'package:test_app/views/intial_screens/utilities/logo_widget.dart';

class MainScreen extends StatefulWidget {
  
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, 
      DeviceOrientation.portraitDown]);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    double logoHeight = MediaQuery.of(context).size.height*0.65;
    double logoWidth = MediaQuery.of(context).size.width*0.65;
    
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
        return Stack(
          children: [
            BackgroundImage(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LogoImage(height: logoHeight, width: logoWidth,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(3),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                    minimumSize: MaterialStateProperty.all<Size>(Size(300, 60)),
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.cianColor),
                  ),
                  child: const Text(
                    'Touch to Continue!',
                    style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'OPTIVagRound-Bold'),
                  ),
                ),
              ],
            ),),
          ],
        );
        }
      ),
    );
  }
}

