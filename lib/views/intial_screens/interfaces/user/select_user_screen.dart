import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_app/view_model/kid/ikid_view_model.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';
import 'package:test_app/views/global_utilities/container_image_service_widget.dart';
import 'package:test_app/views/global_utilities/global_variables.dart';
import 'package:test_app/views/intial_screens/utilities/add_user_button.dart';
import 'package:test_app/views/intial_screens/utilities/background_widget.dart';
import '../../../menu_screens/interfaces/home_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IKidViewModel>(context, listen: false).fetchKids();
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final kidViewModel = Provider.of<IKidViewModel>(context);
    return Scaffold(
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Stack(
            children: [
              BackgroundImage(
                child: Center(
                  child: kidViewModel.isLoading
                      ? const CircularProgressIndicator()
                      : kidViewModel.error != null
                          ? Text(
                              'Error: ${kidViewModel.error}',
                              style: TextStyle(
                                color: AppColors.redColor,
                                fontSize: deviceHeight * 0.05,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : (kidViewModel.kids == null || kidViewModel.kids!.isEmpty)
                              ? AddUserButton()
                              : SizedBox(
                                  height: deviceHeight * 0.8, // Ajusta el tamaño según sea necesario
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: kidViewModel.kids!.length,
                                    itemBuilder: (context, index) {
                                      final kid = kidViewModel.kids![index];
                                      return Container(
                                        margin: EdgeInsets.symmetric(horizontal: deviceWidth*0.065),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: deviceWidth * 0.05,
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
                                                iconSize: deviceWidth * 0.03,
                                                icon: const Icon(Icons.remove, color: AppColors.whiteColor),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text('Confirm Delete'),
                                                        content: Text('Are you sure you want to delete this user?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text('Cancel'),
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: Text('Delete'),
                                                            onPressed: () {
                                                              // Delete user service
                                                              Navigator.of(context).pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(height: deviceHeight * 0.02),
                                            ContainerImageService(
                                              filename: kid.image,
                                              sizeImage: deviceHeight * 0.4,
                                            ),
                                            SizedBox(height: deviceHeight * 0.05),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.cyan, // Cambiar el color de fondo del botón a cian
                                              ),
                                              onPressed: () {
                                                kidViewModel.storeKidId(kid.id);
                                                GlobalVariables.userSelectedImagePath = kid.image;
                                                GlobalVariables.userSelectedName = kid.name;
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => HomeScreen()),
                                                );
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                                child: Text(
                                                  kid.name,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "OPTIVagRound-Bold",
                                                    fontSize: deviceHeight * 0.075,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                ),
              ),
              Positioned(
                bottom: deviceHeight * 0.05,
                right: deviceHeight * 0.05,
                child: AddUserButton(),
              ),
            ],
          );
        },
      ),
    );
  }
}
