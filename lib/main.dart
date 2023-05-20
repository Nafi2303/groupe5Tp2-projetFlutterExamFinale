import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:taskmanager/Services/AuthService.dart';
import 'package:taskmanager/pages/HomePage.dart';
import 'package:taskmanager/pages/SignInPage.dart';
import 'package:taskmanager/pages/SignUpPage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);//gerer l'icone au moment de l'init
  FlutterNativeSplash.remove();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = SignUpPage();
  AuthClass authClass = AuthClass();

  void initState(){
    super.initState();
    checkLogin();
  }

  void checkLogin() async{
    String token = authClass.getToken() as String;//recupere tous les identifiants de connexion
    if(token!=null){
      setState(() {
        currentPage = HomePage();
      }); 
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}
