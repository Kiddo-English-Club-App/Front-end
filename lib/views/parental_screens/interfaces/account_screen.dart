// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/views/intial_screens/interfaces/login/login.dart';
import 'package:test_app/views/parental_screens/utilities/botton_nav_bar.dart';
import 'package:test_app/views/parental_screens/utilities/exitControlParentalButton.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';

import '../../../utility/secure_storage_helper.dart';
import '../../../view_model/profile/iprofile_view_model.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IProfileViewModel>(context, listen: false).fetchProfile();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final titleFontSize = screenWidth * 0.03;
    final buttonFontSize = screenWidth * 0.025;
    final containerHeight = screenHeight * 0.58;
    final containerWidth = screenWidth * 0.35;
    final buttonPadding = screenWidth * 0.15;
    final buttonHeight = screenHeight * 0.04;
    final buttonWidth = containerWidth * 0.4;
    final buttonSpacing = screenHeight * 0.05;

    final commonTextStyle = TextStyle(fontSize: buttonFontSize, fontFamily: "OPTIVagRound-Bold", color: AppColors.whiteColor);
    final orangeButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppColors.orangeColor,
      padding: EdgeInsets.all(screenWidth * 0.02),
      minimumSize: Size(buttonWidth, buttonHeight),
    );
    final profileViewModel = Provider.of<IProfileViewModel>(context);
    final SecureStorageHelper secureStorageHelper = SecureStorageHelper();
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Text(
                  'Cuenta',
                  style: TextStyle(fontSize: titleFontSize, fontFamily: "OPTIVagRound-Bold"),
                ),
                SizedBox(height: screenHeight * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: containerHeight,
                      width: containerHeight,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/img/items/family.png'),
                          fit: BoxFit.fill
                          ),
                      ),
                      ),
                    SizedBox(width: buttonPadding),
                    Column(
                      children: [
                        profileViewModel.isLoading
                          ? const CircularProgressIndicator()
                          : profileViewModel.errorMessage.isNotEmpty
                              ? Text('Error: ${profileViewModel.errorMessage}')
                              : profileViewModel.profile == null
                                  ? const Text('No profile data available.')
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(profileViewModel.profile!.fullName, style: TextStyle(fontSize: titleFontSize, fontFamily: 'OPTIVagRound-Bold'),),
                                        SizedBox(height: buttonSpacing),
                                        Text(profileViewModel.profile!.email, style: TextStyle(fontSize: titleFontSize*0.75, fontFamily: 'VAG_Rounded_Regular'),),
                                        SizedBox(height: buttonSpacing),
                                      ],
                                    ),
                        ElevatedButton(
                          onPressed: () {                            
                            secureStorageHelper.storeValue('access_token', 'Invalid token');
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          style: orangeButtonStyle,
                          child: Text('Log Out', style: commonTextStyle),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          ExitParentalControlButton(),
          const CustomBottonNavigationBar(isAccount: true, )
        ],
      ),
    );
  }
}
