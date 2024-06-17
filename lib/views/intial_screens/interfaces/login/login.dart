import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_app/view_model/login/ilogin_view_model.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';
import 'package:test_app/views/intial_screens/interfaces/login/restore_password_screen.dart';
import 'package:test_app/views/intial_screens/interfaces/login/registration_screen.dart';
import 'package:test_app/views/intial_screens/utilities/background_widget.dart';
import 'package:test_app/views/intial_screens/utilities/logo_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft, 
      DeviceOrientation.landscapeRight]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textFieldFontSize = screenHeight * 0.02;
    final buttonFontSize = screenHeight * 0.03;
    final paddingSize = screenWidth * 0.02;
    final logoSize = screenHeight * 0.4;

    return Scaffold(
      body: BackgroundImage(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(paddingSize),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LogoImage(width: logoSize, height: logoSize),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.person, color: AppColors.blackColor,),
                      filled: true,
                      fillColor: AppColors.yellowColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: textFieldFontSize, fontFamily: 'OPTIVagRound-Bold'),
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
                  ),
                ),
                SizedBox(height: paddingSize),
                PasswordInputField(controller: passwordController, fontSize: textFieldFontSize),
                SizedBox(height: paddingSize),
                Consumer<ILoginViewModel>(
                  builder: (context, loginViewModel, child) {
                    return loginViewModel.isLoading
                       ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              loginViewModel.login(context, emailController.text, passwordController.text);
                            },
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(3),
                              shadowColor: MaterialStateProperty.all<Color>(AppColors.blackColor),
                              minimumSize: MaterialStateProperty.all<Size>(Size(100,35)),
                              backgroundColor: MaterialStateProperty.all<Color>(AppColors.cianColor)
                            ),
                            child: Text('Ingresar', style: TextStyle(fontSize: buttonFontSize, color: AppColors.whiteColor, fontFamily: 'OPTIVagRound-Bold'), ),
                          );
                  },
                ),
                SizedBox(height: paddingSize),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(Size(screenWidth*0.22, screenHeight*0.05)),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      ),
                      child: Text('Registrarse', style: TextStyle(color: AppColors.blackColor, fontFamily: 'OPTIVagRound-Bold', fontSize: buttonFontSize)),
                    ),
                    const SizedBox(width: 10.0),
                  ],
                ),
                SizedBox(height: paddingSize),
                Consumer<ILoginViewModel>(
                  builder: (context, loginViewModel, child) {
                    return Text(
                      loginViewModel.errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'OPTIVagRound-Bold', 
                        fontSize: textFieldFontSize
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final double fontSize;

  const PasswordInputField({required this.controller, required this.fontSize});

  @override
  _PasswordInputFieldState createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: 'Contraseña',
          prefixIcon: Icon(Icons.lock, color: AppColors.blackColor,),
          suffixIcon: IconButton(
            icon: Icon(_isObscured? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isObscured =!_isObscured;
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
      ),
    );
  }
}