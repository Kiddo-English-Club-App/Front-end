import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:test_app/views/games_screens/utilities/feedback_screen.dart';
import 'package:test_app/views/games_screens/utilities/pauseButton.dart';
import 'package:test_app/views/global_utilities/app_colors.dart';
import 'package:test_app/views/global_utilities/game_image_service.dart';
import 'package:test_app/views/global_utilities/global_variables.dart';
import '../../../services/theme/theme_service.dart';
import '../../global_utilities/container_image_service_widget.dart';

class WordySoundsScreen extends StatefulWidget {
  @override
  _WordySoundsScreenState createState() => _WordySoundsScreenState();
}

class _WordySoundsScreenState extends State<WordySoundsScreen> {
  late Soundpool _soundpool;
  late Map<String, int> _soundIds;
  String _backgroundPath = ''; 
  List<Item> _vocabulary = []; // Lista de ítems del tema
  List<Item> _selectedItems = []; // Inicializar como una lista vacía
  Item? _currentSound = null;
  int _round = 1;
  int _score = 0;
  Map<String, bool> _selected = {};
  Timer? _timer;
  double _elapsedTime = 0; // Tiempo transcurrido en segundos

  @override
  void initState() {
    super.initState();
    _soundpool = Soundpool();
    _soundIds = {};
    _loadThemeItems(); // Cargar ítems del tema
    _startTimer(); // Iniciar el cronómetro
  }

  @override
  void dispose() {
    _soundpool.release();
    _timer?.cancel(); // Detener el cronómetro al salir de la pantalla
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    // Asegurarse de que _selectedItems no esté vacío antes de usarlo
    if (_selectedItems.isNotEmpty && _currentSound != null) {
      _playSound(_currentSound!.sound);
    }

    return Scaffold(
      body: Stack(
        children: [
          Expanded(child: ContainerImageService(filename: _backgroundPath, sizeImage: double.infinity)),
          PauseButtonPositioned(redirectWidget: this.widget),
          Positioned(
            top: deviceHeight * 0.5,
            left: deviceWidth * 0.05,
            child: InkWell(
              onTap: () {
                if (_currentSound != null) {
                  _playSound(_currentSound!.sound); // Reproducir sonido al presionar el botón
                }
              },
              child: Image.asset(
                'assets/img/items/bubble.png',
                height: deviceHeight * 0.2,
              ),
            ),
          ),
          if (_selectedItems.isNotEmpty) // Asegurarse de que _selectedItems no esté vacío
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Round $_round',
                    style: TextStyle(fontFamily: 'OPTIVagRound-Bold', fontSize: deviceHeight * 0.1, color: AppColors.blackColor),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _selectedItems.sublist(0, 2).expand((item) {
                          return [
                            GestureDetector(
                              onTap: () {
                                _handleItemClick(item);
                              },
                              child: _buildImageContainer(item),
                            ),
                            SizedBox(width: deviceWidth * 0.05), // SizedBox agregado entre cada imagen
                          ];
                        }).toList(),
                      ),
                      SizedBox(height: deviceHeight * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _selectedItems.sublist(2, 4).expand((item) {
                          return [
                            GestureDetector(
                              onTap: () {
                                _handleItemClick(item);
                              },
                              child: _buildImageContainer(item),
                            ),
                            SizedBox(width: deviceWidth * 0.05), // SizedBox agregado entre cada imagen
                          ];
                        }).toList(),
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

  Widget _buildImageContainer(Item item) {
    double containerHeight = MediaQuery.of(context).size.height * 0.35;
    double containerWidth = MediaQuery.of(context).size.width * 0.2;
    return Container(
      height: containerHeight,
      width: containerWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.yellowColor,
        border: Border.all(color: AppColors.cianColor, width: 8),
      ),
      child: Transform.rotate(
        angle: _selected[item.image] == true ? -pi / 12 : 0, // Rotación de 7 grados a la derecha
        child: Opacity(
          opacity: _selected[item.image] == true ? 0.5 : 1.0, // Opacidad reducida si está seleccionado
          child: GameImageService(filename: item.image, sizeImage: containerHeight * 0.3),
        ),
      ),
    );
  }

  void _loadThemeItems() async {
    ThemeService themeService = ThemeService();
    await themeService.fetchThemeById(GlobalVariables.themeID); // Cargar el tema por ID
    // Asignar los ítems del tema cargado
    setState(() {
      _backgroundPath = themeService.selectedTheme!.background;
      _vocabulary = themeService.selectedTheme?.items ?? [];
      _selectedItems = _getRandomItems(4);
      _currentSound = _getRandomSound();
    });
  }

  List<Item> _getRandomItems(int count) {
    List<Item> items = List.from(_vocabulary);
    items.shuffle();
    return items.sublist(0, min(count, _vocabulary.length));
  }

  Item _getRandomSound() {
    return _selectedItems[Random().nextInt(_selectedItems.length)];
  }

  void _handleItemClick(Item item) {
    if (_round <= 5) {
      if (item == _currentSound) {
        setState(() {
          _score += 10;
          _round++;
          if (_round <= 5) {
            _selectedItems = _getRandomItems(4);
            _currentSound = _getRandomSound();
            _selected.clear();
            _playSound(_currentSound!.sound); // Reproducir automáticamente el sonido al inicio de la próxima ronda
          } else {
            _stopTimer(); // Detener el cronómetro al finalizar las rondas
            _showFeedbackScreen();
          }
        });
      } else {
        setState(() {
          _score = max(0, _score - 5);
          _selected[item.image] = true;
        });
      }
    }
  }

  void _playSound(String key) async {
    if (key.isNotEmpty) {
      ByteData soundData = await rootBundle.load('assets/sounds/$key');
      int soundId = await _soundpool.load(soundData);
      await _soundpool.play(soundId);
    }
  }

  void _showFeedbackScreen() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FeedbackWidget(
          vocabulary: _vocabulary,
          gameScreen: WordySoundsScreen(),
          points: _score,
          time: _elapsedTime, // Enviar el tiempo transcurrido a la pantalla de feedback
        );
      },
    );
    _soundpool.release(); // Liberar Soundpool al finalizar las 5 rondas
  }
}
