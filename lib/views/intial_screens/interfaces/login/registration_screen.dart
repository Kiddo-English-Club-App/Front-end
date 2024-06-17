// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/view_model/register/iregister_view_model.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';
import 'package:test_app/views/intial_screens/interfaces/login/login.dart';
import 'package:test_app/views/intial_screens/utilities/backbutton_widget.dart';
import 'package:test_app/views/intial_screens/utilities/background_widget.dart';
import 'package:test_app/views/intial_screens/utilities/logo_widget.dart';

// ignore: use_key_in_widget_constructors
class RegisterScreen extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textFieldFontSize = screenHeight * 0.02;
    final buttonFontSize = screenHeight * 0.03;
    final paddingSize = screenWidth * 0.02;
    final logoSize = screenHeight * 0.3;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(paddingSize),
                child: Column(
                  children: [
                    LogoImage(width: logoSize, height: logoSize),
                    Container(
                      width: screenWidth*0.6,
                      height: screenHeight*0.1,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.whiteColor,
                          width: screenWidth * 0.01,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        color: AppColors.cianColor,
                        boxShadow: [
                                BoxShadow(
                                  color: AppColors.blackColor.withOpacity(0.2), // Shadow color
                                  spreadRadius: 2, 
                                  blurRadius: 7, 
                                  offset: Offset(0, 3),
                                ),
                              ],
                      ),
                      child: Text(
                        'Ingrese sus datos personales', 
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: textFieldFontSize*1.5,
                          fontFamily: 'OPTIVagRound-Bold'),
                        )),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: paddingSize),
                          TextInputField(controller: firstNameController, fontSize: textFieldFontSize, textHint: 'Ingrese su nombre',),
                          SizedBox(height: paddingSize),
                          TextInputField(controller: lastNameController, fontSize: textFieldFontSize, textHint: 'Ingrese su apellido',),
                          SizedBox(height: paddingSize*3),
                          Container(
                            width: screenWidth*0.6,
                            height: screenHeight*0.1,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.blackColor.withOpacity(0.2), // Shadow color
                                  spreadRadius: 2, 
                                  blurRadius: 7, 
                                  offset: Offset(0, 3),
                                ),
                              ],
                              border: Border.all(
                                color: AppColors.whiteColor,
                                width: screenWidth * 0.01,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                              color: AppColors.cianColor,
                            ),
                            child: Text(
                              'Ingrese su correo y contraseña', 
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: textFieldFontSize*1.5,
                                fontFamily: 'OPTIVagRound-Bold'),
                              )),
                          SizedBox(height: paddingSize),    
                          EmailInputField(controller: emailController, fontSize: textFieldFontSize),
                          SizedBox(height: paddingSize),
                          PasswordInputField(controller: passwordController, fontSize: textFieldFontSize, textHint: 'Ingrese su contraseña',),
                          SizedBox(height: paddingSize),
                          Consumer<IRegisterViewModel>(
                            builder: (context, registerViewModel, child) {
                              return registerViewModel.isLoading
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          registerViewModel.register(
                                            context,
                                            firstNameController.text,
                                            lastNameController.text,
                                            emailController.text,
                                            passwordController.text,
                                          );
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Account Created Successfully'),
                                                content: const Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Su cuenta se ha credo exitosamente ^^'),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => LoginScreen()),
                                                      );
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      style: ButtonStyle(
                                        elevation: MaterialStateProperty.all<double>(3),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                                        minimumSize: MaterialStateProperty.all<Size>(Size(screenWidth*0.22, screenHeight*0.05)),
                                        backgroundColor: MaterialStateProperty.all<Color>(AppColors.cianColor),
                                      ),
                                      child: Text('Registrarse', style: TextStyle(color: AppColors.whiteColor, fontFamily: 'OPTIVagRound-Bold', fontSize: buttonFontSize)),
                                    );
                            },
                          ),
                          SizedBox(height: paddingSize),
                          Consumer<IRegisterViewModel>(
                            builder: (context, registerViewModel, child) {
                              return Text(
                                registerViewModel.errorMessage,
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final double fontSize;
  final String textHint;

  // ignore: use_key_in_widget_constructors
  const PasswordInputField({required this.controller, required this.fontSize, required this.textHint});

  @override
  _PasswordInputFieldState createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.textHint,
        prefixIcon: const Icon(Icons.lock, color: AppColors.blackColor,),
        suffixIcon: IconButton(
          icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
        filled: true,
        fillColor: AppColors.yellowColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      obscureText: _isObscured,
      style: TextStyle(fontSize: widget.fontSize, fontFamily: 'OPTIVagRound-Bold'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese su contraseña';
        }
        return null;
      },
    );
  }
}

class EmailInputField extends StatelessWidget {
  final TextEditingController controller;
  final double fontSize;

  const EmailInputField({required this.controller, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Email',
        prefixIcon: const Icon(Icons.person, color: AppColors.blackColor,),
        filled: true,
        fillColor: AppColors.yellowColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: fontSize, fontFamily: 'OPTIVagRound-Bold'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese su correo electrónico';
        }
        bool isValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
        if (!isValidEmail) {
          return 'Por favor ingrese un correo electrónico válido';
        }
        return null;
      },
    );
  }
}

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final double fontSize;
  final String textHint; 

  const TextInputField({required this.controller, required this.fontSize, required this.textHint});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: textHint,
        prefixIcon: const Icon(Icons.person, color: AppColors.blackColor,),
        filled: true,
        fillColor: AppColors.yellowColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: fontSize, fontFamily: 'OPTIVagRound-Bold'),
    );
  }
}