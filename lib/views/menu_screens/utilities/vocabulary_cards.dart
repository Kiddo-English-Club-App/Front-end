import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/services/file/file_service.dart';
import 'package:test_app/services/theme/theme_service.dart';
import 'package:test_app/utility/secure_storage_helper.dart';
import 'package:test_app/view_model/file/ifile_view_model.dart';
import 'package:test_app/view_model/file/file_view_model.dart';
import 'package:test_app/views/menu_screens/interfaces/select_game.dart';
import 'package:test_app/views/global_utilities/global_variables.dart';

class CustomCardCarousel extends StatefulWidget {
  const CustomCardCarousel({Key? key}) : super(key: key);

  @override
  State<CustomCardCarousel> createState() => _CustomCardCarouselState();
}

class _CustomCardCarouselState extends State<CustomCardCarousel> {
  late final ThemeService _themesProvider;

  @override
  void initState() {
    super.initState();
    _themesProvider = ThemeService();
    _themesProvider.fetchThemes();
  }
  
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: _themesProvider.fetchThemes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _themesProvider.themes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.0), // 50px padding on each side
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomCard(
                    id: _themesProvider.themes[index].id,
                    description: _themesProvider.themes[index].description,
                    image: _themesProvider.themes[index].image,
                    width: screenWidth * 0.4, // 45% of screen width
                    screenHeight: screenHeight,
                    name: _themesProvider.themes[index].name,
                    backgroundImage: _themesProvider.themes[index].background,
                    items: _themesProvider.themes[index].items,
                  ),
                  SizedBox(height: 10),
                  Text(
                    _themesProvider.themes[index].name,
                    style: TextStyle(
                      fontSize: screenHeight * 0.08, // Adjust font size based on screen height
                      fontFamily: "OPTIVagRound-Bold",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }
}

class CustomCard extends StatefulWidget {
  final String description;
  final String image;
  final double width;
  final double screenHeight;
  final String name;
  final String? backgroundImage;
  final String id;
  final List<Item> items;

  const CustomCard({
    Key? key,
    required this.id,
    required this.description,
    required this.image,
    required this.width,
    required this.screenHeight,
    required this.name,
    required this.backgroundImage,
    required this.items,
  }) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double height = widget.width * 2 / 3; // Maintain 3:2 aspect ratio
    return GestureDetector(
      onTap: () {
        setState(() {
          isPressed = !isPressed;
        });
      },
      child: Stack(
        children: [
          _buildCardContent(height, widget.image), //change it to test different images
          if (isPressed) _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildCardContent(double height, String filename) {
    return ChangeNotifierProvider<IFileViewModel>(
      create:(_) => FileViewModel(
        FileService(),
        SecureStorageHelper(),
      )..fetchFile(filename),
      child: Consumer<IFileViewModel>(
        builder: ((context, viewModel, child) {
          if (viewModel.isLoading) {
            return SizedBox(
              width: 100,
              height: height,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (viewModel.hasError || viewModel.fileData == null) {
            return SizedBox(
              width: 100,
              height: height,
              child: Center(child: Icon(Icons.error)),
            );
          } else {
            return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: widget.width,
                        height: height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          image: DecorationImage(
                            image: MemoryImage(viewModel.fileData!),
                            fit: BoxFit.cover,
                            colorFilter: isPressed
                                ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
                                : null,
                          ),
                        ),
                      );
          }          
        }
      ),
    ));
  }

  Widget _buildDescription() {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.width * 0.09),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDescriptionText(),
              SizedBox(height: widget.screenHeight * 0.05), // Adjust spacing based on screen height
              _buildPlayButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionText() {
    return Text(
      widget.description,
      style: TextStyle(
        color: Colors.white,
        fontSize: widget.screenHeight * 0.07, 
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPlayButton() {
    return IconButton(
      onPressed: () {
        GlobalVariables.backgroundImageGamePath = widget.id;
        GlobalVariables.themeID = widget.id;
        print('Theme ID: ${GlobalVariables.themeID}');
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => SelectGameScreen()),
        );
      },
      icon: const Icon(Icons.play_circle_fill),
      iconSize: widget.screenHeight * 0.14,
      color: Colors.white,
    );
  }
}

extension on Item {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'sound': sound,
    };
  }
}
