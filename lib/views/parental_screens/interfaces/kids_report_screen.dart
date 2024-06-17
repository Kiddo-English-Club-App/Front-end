// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/models/report/report_model.dart';
import 'package:test_app/view_model/report/ireport_view_model.dart';
import 'package:test_app/views/global_utilities/global_variables.dart';
import 'package:test_app/views/parental_screens/utilities/botton_nav_bar.dart';
import 'package:test_app/views/parental_screens/utilities/exitControlParentalButton.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';

class KidReportScreen extends StatefulWidget {
  @override
  _KidReportScreenState createState() => _KidReportScreenState();
}

class _KidReportScreenState extends State<KidReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IReportViewModel>(context, listen: false).fetchReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportViewModel = Provider.of<IReportViewModel>(context);

    if (reportViewModel.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (reportViewModel.error != null) {
      return Scaffold(
        body: Center(
          child: Text('Error: ${reportViewModel.error}'),
        ),
      );
    }

    final report = reportViewModel.report;

    if (report == null) {
      return const Scaffold(
        body: Center(
          child: Text('No report data available.'),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final titleFontSize = screenWidth * 0.04;
    final reportTitleFontSize = screenWidth * 0.025;
    final reportTextFontSize = screenWidth * 0.02;
    final containerHeight = screenHeight * 0.69;
    final containerWidth = screenWidth * 0.26;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Centro de Progreso de: ',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontFamily: "OPTIVagRound-Bold",
                      ),
                    ),
                    Text(
                      GlobalVariables.userSelectedName ?? 'Usuario',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontFamily: "OPTIVagRound-Bold",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildScoreContainer(
                      containerHeight,
                      containerWidth,
                      reportTitleFontSize,
                      report.topScores,
                      'Temas Favoritos',
                      reportTextFontSize,
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    _buildScoreContainer(
                      containerHeight,
                      containerWidth,
                      reportTitleFontSize,
                      report.bottomScores,
                      'Temas Difíciles',
                      reportTextFontSize,
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    _buildTimeContainer(
                      containerHeight,
                      containerWidth,
                      reportTitleFontSize,
                      report.avgTime,
                      reportTextFontSize,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ExitParentalControlButton(),
          const CustomBottonNavigationBar(isChildren: true),
        ],
      ),
    );
  }

  Widget _buildScoreContainer(double containerHeight, double containerWidth,
      double reportTitleFontSize, List<Score> scores, String title, double reportTextFontSize) {
    return Container(
      height: containerHeight,
      width: containerWidth,
      decoration: BoxDecoration(
        color: AppColors.yellowColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: reportTitleFontSize,
              fontFamily: "OPTIVagRound-Bold",
            ),
          ),
          SizedBox(height: containerHeight * 0.02),
          Image.asset('assets/img/items/${title == 'Temas Favoritos' ? 'podium_star' : 'podium'}.png',
              height: containerHeight * 0.5),
          SizedBox(height: containerHeight * 0.02),
          Container(
            width: containerWidth * 0.9,
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: scores
                  .map((score) => Row(
                        children: [
                          SizedBox(width: containerWidth * 0.03),
                          CircleAvatar(
                            radius: containerHeight * 0.04,
                            backgroundColor: _getCircleColor(scores.indexOf(score)),
                          ),
                          SizedBox(width: containerWidth * 0.05),
                          Text(
                            score.themeName,
                            style: TextStyle(
                              fontSize: reportTextFontSize,
                              fontFamily: "OPTIVagRound-Bold",
                            ),
                          )
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeContainer(double containerHeight, double containerWidth,
      double reportTitleFontSize, double avgTime, double reportTextFontSize) {
    return Container(
      height: containerHeight,
      width: containerWidth,
      decoration: BoxDecoration(
        color: AppColors.yellowColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Tiempo de respuesta',
            style: TextStyle(
              fontSize: reportTitleFontSize,
              fontFamily: "OPTIVagRound-Bold",
            ),
          ),
          SizedBox(height: containerHeight * 0.01),
          Image.asset('assets/img/items/clock.png', height: containerHeight * 0.5),
          SizedBox(height: containerHeight * 0.02),
          Container(
            width: containerWidth * 0.9,
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: containerHeight * 0.02),
                Text(
                  avgTime.toString(),
                  style: TextStyle(
                    fontSize: reportTextFontSize,
                    fontFamily: "OPTIVagRound-Bold",
                  ),
                ),
                SizedBox(height: containerHeight * 0.01),
                Text(
                  'segundos',
                  style: TextStyle(
                    fontSize: reportTextFontSize,
                    fontFamily: "OPTIVagRound-Bold",
                  ),
                ),
                SizedBox(height: containerHeight * 0.01),
                Text(
                  'Por actividad',
                  style: TextStyle(
                    fontSize: reportTextFontSize,
                    fontFamily: "OPTIVagRound-Bold",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCircleColor(int index) {
    switch (index % 3) {
      case 0:
        return AppColors.orangeColor;
      case 1:
        return AppColors.cianColor;
      case 2:
        return AppColors.redColor;
      default:
        return Colors.black;
    }
  }
}
