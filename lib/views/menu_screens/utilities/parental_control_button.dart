import 'dart:math';
import 'package:flutter/material.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';
import 'package:test_app/views/parental_screens/interfaces/kids_report_screen.dart';

class ParentalControlButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double buttonHeight = screenHeight * 0.1;
    final double iconSize = screenHeight * 0.1;
    final double fontSize = screenHeight * 0.08;

    return Positioned(
      top: 0,
      left: 20,
      child: ElevatedButton(
        onPressed: () {
          final Random random = Random();

          int operand1 = random.nextInt(10) + 1;
          int operand2 = random.nextInt(10) + 1;
          int operand3 = random.nextInt(10) + 1;

          List<String> operators = ['+', '*'];
          String operator1 = operators[random.nextInt(operators.length)];
          String operator2 = operators[random.nextInt(operators.length)];

          String operation = '$operand1 $operator1 $operand2 $operator2 $operand3';
          int correctResult = calculateOperationResult(operation);
          List<int> options = generateOptions(correctResult);

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ParentalControlPopup(operation: operation, options: options, correctResult: correctResult);
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orangeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: buttonHeight * 0.2,
            horizontal: buttonHeight * 0.3,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.family_restroom,
              size: iconSize,
              color: Colors.white,
            ),
            SizedBox(width: buttonHeight * 0.5),
            Text(
              'For parents',
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontFamily: 'OPTIVagRound-Bold',
              ),
            ),
          ],
        ),
      ),
    );
  }

  int calculateOperationResult(String operation) {
    List<String> parts = operation.split(' ');
    int operand1 = int.parse(parts[0]);
    String operator1 = parts[1];
    int operand2 = int.parse(parts[2]);
    String operator2 = parts[3];
    int operand3 = int.parse(parts[4]);

    int result;
    if (operator2 == '*') {
      int tempResult = operator1 == '*' ? operand1 * operand2 : operand1 + operand2;
      result = tempResult * operand3;
    } else {
      int tempResult = operator1 == '*' ? operand1 * operand2 : operand1 + operand2;
      result = tempResult + operand3;
    }

    return result;
  }

  List<int> generateOptions(int correctResult) {
    final Random random = Random();
    Set<int> options = {correctResult};

    while (options.length < 3) {
      int option = correctResult + random.nextInt(10) - 5;
      if (option != correctResult && option > 0) {
        options.add(option);
      }
    }

    return options.toList()..shuffle();
  }
}

class ParentalControlPopup extends StatefulWidget {
  final String operation;
  final List<int> options;
  final int correctResult;

  ParentalControlPopup({required this.operation, required this.options, required this.correctResult});

  @override
  _ParentalControlPopupState createState() => _ParentalControlPopupState();
}

class _ParentalControlPopupState extends State<ParentalControlPopup> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.yellowColor,
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Para continuar, pídele ayuda a un adulto',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontFamily: 'OPTIVagRound-Bold',
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Escribe el resultado de:',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontFamily: 'OPTIVagRound-Bold',
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.operation,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontFamily: 'OPTIVagRound-Bold',
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.options.map((option) {
                  return ElevatedButton(
                    onPressed: () {
                      if (option == widget.correctResult) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => KidReportScreen()),
                        );
                      } else {
                        setState(() {
                          _errorMessage = 'La respuesta ingresada no es correcta. Inténtalo de nuevo.';
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.cianColor),
                    child: Text(
                      option.toString(),
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontFamily: 'OPTIVagRound-Bold',
                        fontSize: 18,
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 20),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: AppColors.blackColor),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
