import 'package:e_lawyer_app/ui/homescreendata/HomeScreen.dart';
import 'package:e_lawyer_app/ui/select_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 892),
      builder: (context, child){
        return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.yellow,
          ),
          debugShowCheckedModeBanner: false,
          home: SelectUser(),
        );
      },
    );
  }
}

