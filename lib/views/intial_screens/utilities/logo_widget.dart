import 'package:flutter/widgets.dart';

class LogoImage extends StatelessWidget {
  final double width;
  final double height;

  const LogoImage({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/logo.png'),
        ),
      ),
      width: width,
      height: height,
    );
  }
}