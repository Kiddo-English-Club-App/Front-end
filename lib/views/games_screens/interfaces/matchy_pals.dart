import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';
import 'package:test_app/views/global_utilities/global_variables.dart';
import 'dart:math';

import '../../../services/theme/theme_service.dart';
import '../../../services/file/file_service.dart';
import '../../../utility/secure_storage_helper.dart';
import '../../../view_model/file/file_view_model.dart';
import '../../global_utilities/container_image_service_widget.dart';
import '../utilities/feedback_screen.dart';
import '../utilities/pauseButton.dart';

class MatchyPalsScreen extends StatefulWidget {
  @override
  _MatchyPalsScreenState createState() => _MatchyPalsScreenState();
}

class _MatchyPalsScreenState extends State<MatchyPalsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ThemeService>(context, listen: false).fetchThemeById(GlobalVariables.themeID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          if (themeService.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (themeService.errorMessage.isNotEmpty) {
            return Center(child: Text(themeService.errorMessage));
          }

          final theme = themeService.selectedTheme;
          if (theme == null) {
            return Center(child: Text('No theme selected.'));
          }

          return Stack(
            children: [
              Expanded(child: ContainerImageService(filename: themeService.selectedTheme!.background, sizeImage: double.infinity)),
              PauseButtonPositioned(redirectWidget: MatchyPalsScreen()),
              MatchGame(theme: theme),
            ],
          );
        },
      ),
    );
  }
}

class MatchGame extends StatefulWidget {
  final ThemeVocabulary theme;

  MatchGame({required this.theme});

  @override
  _MatchGameState createState() => _MatchGameState();
}

class _MatchGameState extends State<MatchGame> {
  List<Item> items = [];
  List<Item> shuffledItems = [];
  Map<String, String> selectedMatches = {};
  int points = 0;
  double startTime = 0;
  late double pointsPerCorrectMatch;

  @override
  void initState() {
    super.initState();
    items = widget.theme.items;
    shuffledItems = List.from(items)..shuffle(Random());
    startTime = DateTime.now().millisecondsSinceEpoch / 1000;
    pointsPerCorrectMatch = 100 / items.length;  // Calcular puntos por match correcto
  }

  void _onItemSelected(String itemId, String name) {
    final item = items.firstWhere((item) => item.id == itemId);
    if (item.name == name) {
      points += pointsPerCorrectMatch.toInt();  // Sumar puntos correctos
    } else {
      points = max(0, points - 5);  // Restar 5 puntos por match incorrecto, sin permitir negativos
    }
    
    setState(() {
      selectedMatches[itemId] = name;
    });

    if (selectedMatches.length == items.length) {
      double endTime = DateTime.now().millisecondsSinceEpoch / 1000;
      double timeTaken = endTime - startTime;
      _showCompletionDialog(timeTaken);
    }
  }

  void _showCompletionDialog(double timeTaken) {
    showDialog(
      context: context,
      builder: (context) {
        return FeedbackWidget(
          vocabulary: items,
          gameScreen: MatchyPalsScreen(),
          points: points,
          time: timeTaken,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: shuffledItems.map((item) {
                return DragTarget<String>(
                  onAccept: (itemId) {
                    _onItemSelected(itemId, item.name);
                  },
                  builder: (context, candidateData, rejectedData) {
                    bool isMatched = selectedMatches[item.id] == item.name;
                    return isMatched
                        ? SizedBox(width: deviceHeight*0.25, height: deviceHeight*0.25)
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.yellowColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.cianColor, width: 7)
                              ),
                              child: GameImageService(filename: item.image, sizeImage: deviceHeight*0.25)),
                          );
                  },
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20), // Espacio entre las filas
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: items.map((item) {
                return Draggable<String>(
                  data: item.id,
                  feedback: Material(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        border: Border.all(color: AppColors.cianColor, width: 7),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        item.name,
                        style: TextStyle(fontSize: deviceHeight*0.075, color: AppColors.blackColor, fontFamily: 'JUA'),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    width: 100,
                    margin: EdgeInsets.all(8.0),
                    color: AppColors.cianColor,
                    child: Center(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 16.0, 
                          color: AppColors.blackColor,
                          fontFamily: 'JUA'),
                      ),
                    ),
                  ),
                  child: selectedMatches.containsValue(item.name)
                      ? Container(width: 100, margin: EdgeInsets.all(8.0), color: Colors.transparent)
                      : Container(
                          width: 100,
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(color: AppColors.cianColor, width: 7),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              item.name,
                              style: TextStyle(fontSize: deviceHeight*0.075, color: AppColors.blackColor, fontFamily: 'JUA'),
                            ),
                          ),
                        ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class GameImageService extends StatefulWidget {
  final String filename;
  final double sizeImage;

  GameImageService({required this.filename, required this.sizeImage});

  @override
  State<GameImageService> createState() => _GameImageServiceState();
}

class _GameImageServiceState extends State<GameImageService> {
  late FileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = FileViewModel(FileService(), SecureStorageHelper());
    _viewModel.fetchFile(widget.filename);
  }

  @override
  void didUpdateWidget(GameImageService oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filename != widget.filename) {
      _viewModel.fetchFile(widget.filename);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<FileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (viewModel.hasError || viewModel.fileData == null) {
            return Container(
              child: Center(child: Icon(Icons.error)),
            );
          } else {
            return Container(
              height: widget.sizeImage,
              width: widget.sizeImage,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: MemoryImage(viewModel.fileData!),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
