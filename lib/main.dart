import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_app/services/achievement/achievement_service.dart';
import 'package:test_app/services/kid/kid_service.dart';
import 'package:test_app/services/login/login_service.dart';
import 'package:test_app/services/profile/profile_service.dart';
import 'package:test_app/services/register/register_service.dart';
import 'package:test_app/services/report/report_service.dart';
import 'package:test_app/services/theme/theme_service.dart';
import 'package:test_app/view_model/achievement/achievement_view_model.dart';
import 'package:test_app/view_model/achievement/iachievement_view_model.dart';
import 'package:test_app/view_model/kid/ikid_view_model.dart';
import 'package:test_app/view_model/kid/kid_view_model.dart';
import 'package:test_app/view_model/login/ilogin_view_model.dart';
import 'package:test_app/view_model/login/login_view_model.dart';
import 'package:test_app/view_model/profile/iprofile_view_model.dart';
import 'package:test_app/view_model/profile/profile_view_model.dart';
import 'package:test_app/view_model/register/iregister_view_model.dart';
import 'package:test_app/view_model/register/register_view_model.dart';
import 'package:test_app/view_model/report/ireport_view_model.dart';
import 'package:test_app/view_model/report/report_view_model.dart';
import 'package:test_app/views/intial_screens/interfaces/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ILoginViewModel>(create: (context) => LoginViewModel(LoginService())),
        ChangeNotifierProvider<IRegisterViewModel>(create: (context) => RegisterViewModel(RegisterService())),
        ChangeNotifierProvider(create: (context) => ThemeService()),
        ChangeNotifierProvider<IProfileViewModel>(create: (context) => ProfileViewModel(ProfileService())),
        ChangeNotifierProvider<IKidViewModel>(create: (context) => KidViewModel(KidService())),
        ChangeNotifierProvider<IAchievementViewModel>(create: (context) => AchievementViewModel(AchievementService())),
        ChangeNotifierProvider<IReportViewModel>(create: (context) => ReportViewModel(ReportService())),
      ],
      child: MyApp(),
    ),
);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiddo English Club',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
