// ignore_for_file: sort_child_properties_last

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:soundpool/soundpool.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';
import 'package:test_app/views/global_utilities/container_image_service_widget.dart';
import 'package:test_app/views/global_utilities/game_image_service.dart';
import 'package:test_app/views/games_screens/utilities/feedback_screen.dart';
import 'package:test_app/views/games_screens/utilities/pauseButton.dart';
import '../../../services/theme/theme_service.dart';
import '../../global_utilities/global_variables.dart';

class LetterPuzzle extends StatefulWidget {
  @override
  _LetterPuzzleState createState() => _LetterPuzzleState();
}

class _LetterPuzzleState extends State<LetterPuzzle> {
  List<String> shuffledLetters = [];
  List<String> orderedLetters = [];
  List<String> originalShuffledLetters = [];
  List<Item> selectedItems = [];
  int currentWordIndex = 0;
  String currentItemImage = '';
  String word = '';
  late Soundpool _soundpool;
  int points = 0;
  double timeLeft = 120; // 120 seconds

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeTheme();
    _soundpool = Soundpool();
    _startTimer();
  }

  @override
  void dispose() {
    _soundpool.release();
    _timer.cancel();
    super.dispose();
  }

  void _initializeTheme() async {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    await themeService.fetchThemeById(GlobalVariables.themeID);
    final theme = themeService.selectedTheme;
    if (theme != null) {
      setState(() {
        _selectRandomItems(theme.items);
        _initializeGame(selectedItems[currentWordIndex].name);
      });
    }
  }

  void _selectRandomItems(List<Item> items) {
    final random = Random();
    while (selectedItems.length < 5 && items.isNotEmpty) {
      int randomIndex = random.nextInt(items.length);
      Item randomItem = items[randomIndex];
      if (!selectedItems.contains(randomItem)) {
        selectedItems.add(randomItem);
        items.removeAt(randomIndex);
      }
    }
  }

  void _initializeGame(String word) {
    setState(() {
      this.word = word;
      shuffledLetters = word.split('')..shuffle();
      orderedLetters = List.generate(word.length, (_) => '');
      originalShuffledLetters = List.from(shuffledLetters); 
      currentItemImage = selectedItems[currentWordIndex].image;
    });
  }

  Widget _buildLetter(String letter) {
    bool isEmpty = letter.isEmpty;
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isEmpty ? AppColors.blackColor.withOpacity(0.75) : AppColors.purpleColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cianColor, width: 4.0),
      ),
      child: Text(
        letter,
        style: const TextStyle(
          fontSize: 24,
          color: AppColors.whiteColor,
          fontFamily: 'OPTIVagRound-Bold',
        ),
        textAlign: TextAlign.center,
      ),
      width: 50,
      height: 50,
      alignment: Alignment.center,
    );
  }

  void _moveLetterToOrdered(String letter) {
    setState(() {
      int index = shuffledLetters.indexOf(letter);
      if (index != -1) {
        shuffledLetters[index] = '';
        orderedLetters[orderedLetters.indexOf('')] = letter;
      }
    });
  }

  void _moveLetterToShuffled(String letter) {
    setState(() {
      int index = orderedLetters.indexOf(letter);
      if (index != -1) {
        orderedLetters[index] = '';
        shuffledLetters[shuffledLetters.indexOf('')] = letter;
      }
    });
  }

  bool _isCorrectOrder() {
    return orderedLetters.join('') == word;
  }

  Future<void> _playSound(String soundPath) async {
    if (soundPath.isNotEmpty) {
      ByteData soundData = await rootBundle.load(soundPath);
      int soundId = await _soundpool.load(soundData);
      await _soundpool.play(soundId);
    }
  }

  void _showSuccessMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return FeedbackWidget(
          vocabulary: selectedItems,
          gameScreen: LetterPuzzle(), // Pasar la referencia del juego actual
          points: points,
          time: timeLeft,
        );
      },
    ).then((_) {
      _resetGame();
    });
  }

  void _resetGame() {
    setState(() {
      points = 0;
      currentWordIndex = 0;
      shuffledLetters.clear();
      orderedLetters.clear();
      originalShuffledLetters.clear();
      selectedItems.clear();
      timeLeft = 120;
    });
    _initializeTheme();
    _startTimer(); // Reiniciar el timer al reiniciar el juego
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (timeLeft <= 0) {
        timer.cancel();
        _timerEnded();
      } else {
        setState(() {
          timeLeft -= 1;
        });
      }
    });
  }

  void _timerEnded() {
    _showSuccessMessage(); // Mostrar el mensaje de éxito al finalizar el tiempo
  }

  void _checkWordOrder() {
    if (_isCorrectOrder()) {
      _playSound('assets/sounds/${selectedItems[currentWordIndex].sound}');
      _updatePoints(20);
      if (currentWordIndex < selectedItems.length - 1) {
        currentWordIndex++;
        _initializeGame(selectedItems[currentWordIndex].name);
      } else {
        _timer.cancel();
        _showSuccessMessage();
      }
    } else {
      _playSound('assets/sounds/answers/wrong.mp3');
      _updatePoints(-5); // Penalización de 5 puntos por error
      setState(() {
        shuffledLetters = List.from(originalShuffledLetters);
        orderedLetters.clear();
        orderedLetters = List.generate(word.length, (_) => '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      body: themeService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : themeService.errorMessage.isNotEmpty
              ? Center(child: Text(themeService.errorMessage))
              : themeService.selectedTheme == null
                  ? const Center(child: Text('No theme found.'))
                  : Stack(
                      children: [
                        Expanded(child: ContainerImageService(filename: themeService.selectedTheme!.background, sizeImage: double.infinity)),
                        PauseButtonPositioned(redirectWidget: LetterPuzzle()),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Time left: ${timeLeft.toInt()} seconds',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Points: $points',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.cianColor, width: 7),
                                color: AppColors.yellowColor
                              ),
                              child: GameImageService(
                                filename: currentItemImage,
                                sizeImage: 150,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: shuffledLetters.map((letter) {
                                return GestureDetector(
                                  onTap: () => _moveLetterToOrdered(letter),
                                  child: _buildLetter(letter),
                                );
                              }).toList(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: orderedLetters.map((letter) {
                                return GestureDetector(
                                  onTap: () => _moveLetterToShuffled(letter),
                                  child: _buildLetter(letter),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _checkWordOrder,
                              child: const Text('Check'),
                            ),
                          ],
                        ),
                      ],
                    ),
    );
  }

  void _updatePoints(int additionalPoints) {
    setState(() {
      points += additionalPoints;
    });
  }
}
