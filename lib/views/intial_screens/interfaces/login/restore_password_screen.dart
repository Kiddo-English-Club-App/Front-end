import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/views/intial_screens/utilities/backbutton_widget.dart';
import 'package:test_app/views/intial_screens/utilities/background_widget.dart';
import 'package:test_app/views/intial_screens/interfaces/login/login.dart';
import 'package:test_app/views/intial_screens/utilities/logo_widget.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';
import 'package:test_app/views/global_utilities/cian_custom_button.dart';

class RestorePasswordScreen extends StatefulWidget {
  @override
  _RestorePasswordScreenState createState() => _RestorePasswordScreenState();
}

class _RestorePasswordScreenState extends State<RestorePasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Email is valid, show popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hemos enviado un correo a la siguiente dirección:\n'),
            content: Text('Email: ${_emailController.text}\nSiga las direcciones para restaurar su contraseña'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('Entendido'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, 
      DeviceOrientation.portraitDown
      ]);
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LogoImage(
                      width: 300,
                      height: 300,
                    ), // Add the Logo widget here
                    SizedBox(height: 10),
                    MessageContainer(),
                    SizedBox(height: 10), // Adjust spacing as needed
                    EmailInputField(controller: _emailController),
                    SizedBox(height: 20),
                    CustomCianElevatedButton(text:'Submit', onPressed: _submitForm)
                  ],
                ),
              ),
            ),
          ),
          BackButtonPositioned()
        ],
      ),
    );
  }
}

class EmailInputField extends StatelessWidget {
  final TextEditingController controller;

  const EmailInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: AppColors.yellowColor,
      ),
      width: 374,
      height: 60,
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontFamily: 'VAG_Rounded_Regular',),
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: 'Email', // Set hint text instead of label
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingrese su email';
          }
          // Basic email validation
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Por favor ingrese un correo válido';
          }
          return null;
        },
      ),
    );
  }
}

class MessageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: AppColors.whiteColor), // Border color
      boxShadow: [
        BoxShadow(
          color: AppColors.blackColor.withOpacity(0.2), // Shadow color
          spreadRadius: 2, // Spread radius
          blurRadius: 7, // Blur radius
          offset: Offset(0, 3), // Offset
        ),
      ],
      color: AppColors.cianColor, // Container color
    ),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: const Text(
        'Ingresa tu email para resetear su contraseña',
        style: TextStyle(fontSize: 24.0, fontFamily: 'OPTIVagRound-Bold', color: AppColors.whiteColor),
      ),
    );
  }
}
