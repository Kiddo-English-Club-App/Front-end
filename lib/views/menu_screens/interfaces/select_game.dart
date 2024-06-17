// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_app/services/file/file_service.dart';
import 'package:test_app/utility/secure_storage_helper.dart';
import 'package:test_app/view_model/file/ifile_view_model.dart';
import 'package:test_app/view_model/file/file_view_model.dart';
import 'package:test_app/views/games_screens/interfaces/letter_puzzle.dart';
import 'package:test_app/views/games_screens/interfaces/matchy_pals.dart';
import 'package:test_app/views/games_screens/interfaces/wordy_sounds.dart';
import 'package:test_app/views/games_screens/utilities/backButton.dart';
import 'package:test_app/views/global_utilities/global_variables.dart';
import 'package:test_app/views/menu_screens/utilities/game_container_widget.dart';

class SelectGameScreen extends StatefulWidget {

  @override
  State<SelectGameScreen> createState() => _SelectGameScreenState();
}

class _SelectGameScreenState extends State<SelectGameScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          ChangeNotifierProvider<IFileViewModel>(
            create: (_) => FileViewModel(
              FileService(), 
              SecureStorageHelper()
              )..fetchFile(
                GlobalVariables.backgroundImagePath),
            child: Consumer<IFileViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (viewModel.hasError || viewModel.fileData == null) {
                  return SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(child: Icon(Icons.error)),
                  );
                } else{
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(viewModel.fileData!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Positioned(
            top: deviceHeight * 0.03,
            left: deviceWidth * 0.02,
            child: BackButtonWidget(),
          ),
          // Envuelve el Row con un ListView
          Center(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GameContainer(
                      gameName: 'Matchy Pals',
                      gameDescription: 'Match the image with its word and learn in a FUN WAY!',
                      redirectWidget: MatchyPalsScreen(),
                    ),
                    GameContainer(
                      gameName: 'Wordy Sounds',
                      gameDescription: 'Listen to the words and choose the correct image to learn English!',
                      redirectWidget: WordySoundsScreen(),
                    ),
                    GameContainer(
                      gameName: 'Letter Puzzle Fun',
                      gameDescription: 'Sort the letters and make fun words while you enjoy learning English!',
                      redirectWidget: LetterPuzzle(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
