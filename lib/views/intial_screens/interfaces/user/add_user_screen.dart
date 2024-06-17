import 'package:flutter/material.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';
import 'package:test_app/views/global_utilities/global_variables.dart';
import 'package:test_app/views/intial_screens/interfaces/user/select_user_screen.dart';
import 'package:test_app/views/intial_screens/utilities/background_widget.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  String? _selectedImage;
  String _userName = '';

  @override
  void initState() {
    _selectedImage = null;
    _userName = '';
    super.initState();
  }

  final List<String> _userImages = [
    'assets/img/avatars/female/female_1.png',
    'assets/img/avatars/female/female_2.png',
    'assets/img/avatars/female/female_3.png',
    'assets/img/avatars/male/male_1.png',
    'assets/img/avatars/male/male_2.png',
    'assets/img/avatars/male/male_3.png',
  ];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: BackgroundImage(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight*0.05),
              Text('Add User', style: TextStyle(fontSize: screenHeight*0.08, color: AppColors.blackColor, fontFamily: 'OPTIVagRound-Bold'),),
              SizedBox(height: screenHeight*0.05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _userImages.map((imageUrl) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImage = imageUrl;
                        });
                      },
                      child: Container(
                        color: _selectedImage == imageUrl ? AppColors.cianColor : Colors.transparent,
                        child: Image.asset(
                          imageUrl,
                          height: screenHeight*0.3
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: screenHeight*0.05),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.yellowColor,
                  borderRadius: BorderRadius.circular(screenWidth*0.08),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                width: screenWidth * 0.4,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario',
                    labelStyle: TextStyle(fontSize: screenHeight*0.05, color: AppColors.blackColor, fontFamily: 'OPTIVagRound-Bold'),
                  ),
                  style: TextStyle(fontSize: screenHeight*0.05, fontFamily: 'OPTIVagRound-Bold'),
                  onChanged: (value) {
                    setState(() {
                      _userName = value;
                    });
                  },
                ),
              ),
              SizedBox(height: screenHeight*0.05),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cianColor
                ),
                onPressed: () {
                  _addUser();
                },
                child: Text('Add', style: TextStyle(fontSize: screenHeight*0.08, fontFamily: 'OPTIVagRound-Bold', color: AppColors.whiteColor),),
              ),
              SizedBox(height: screenHeight*0.05),
            ],
          ),
        ),
      ),
    );
  }

  void _addUser() {
    if (_selectedImage != null && _userName.isNotEmpty) {
      // Crear un nuevo usuario con los datos ingresados
      Map<String, dynamic> newUser = {
        "host": "d36ff756-f696-4f69-8916-cef1a1601942",
        "id": UniqueKey().toString(), // Generar un ID único para el nuevo usuario
        "image": _selectedImage!,
        "name": _userName,
      };

      // Agregar el nuevo usuario al JSON userData
      GlobalVariables.userData.add(newUser);
      // Actualizar UserScreen después de agregar un usuario
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserScreen()),
      );
    } else {
      // Mostrar un diálogo de alerta si no se han ingresado todos los datos necesarios
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Por favor selecciona una imagen y escribe un nombre de usuario.',style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.07, fontFamily: 'OPTIVagRound-Bold'),),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK',style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.05, fontFamily: 'OPTIVagRound-Bold')),
              ),
            ],
          );
        },
      );
    }
  }
}
