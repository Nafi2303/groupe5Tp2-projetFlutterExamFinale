import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskmanager/Services/AuthService.dart';
import 'package:taskmanager/pages/AddTask.dart';
import 'package:taskmanager/pages/HomePage.dart';
import 'package:taskmanager/pages/SignInPage.dart';


class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade400,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle:
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        toolbarHeight: 80,
        backgroundColor: Colors.deepPurple.shade400,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text("Task Manager"),
        ),
        titleTextStyle: GoogleFonts.fruktur(
          color: Colors.white,
          fontSize: 25,
          fontStyle: FontStyle.italic,
          letterSpacing: 2,
        ),
      ),
     body: SafeArea(
       child: SingleChildScrollView(
         child: Column(
           children: [
             Container(
               height: MediaQuery.of(context).size.height *0.45,
               decoration: BoxDecoration(
                 color: Colors.deepPurpleAccent.shade100,
                 image: DecorationImage(image:
                 AssetImage("assets/images/5.png"),
                   fit: BoxFit.contain,
                 ),
               ),
             ),
             SizedBox(height: 20),
             Text(
               "Task Manager qu'est ce que c'est ?",
               style: GoogleFonts.fruktur(
                 color: Colors.white,
                 fontSize: 25,
                 fontStyle: FontStyle.italic,
                 letterSpacing: 2,
               ),
               textAlign: TextAlign.center,
             ),

             Container(
               width: MediaQuery.of(context).size.width -30,
               child: Text(
                 "Task Manager est une application qui vous permet de consulter et gérer des tâches. "
                     "L'application vous permet également de créer vos "
                     "propres tâches, de modifier et/ou de les supprimer.",
                 style: GoogleFonts.ebGaramond(
                   color: Colors.white,
                   fontSize: 25,
                 ),
                 textAlign: TextAlign.justify,
               ),
             ),
             SizedBox(height: 40),
           ],
         ),
       ),
     ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.deepPurple.shade50,
          items: [
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => HomePage()));
                },
                child: Icon(
                  Icons.task_sharp,
                  size: 35,
                  color: Colors.deepPurple.shade400,
                ),
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => AddTaskPage()));
                },
                child: Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        Colors.indigoAccent,
                        Colors.purple,
                      ])),
                  child: Icon(
                    Icons.add,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  showMenu(
                    elevation: 30,
                    color: Colors.deepPurpleAccent.shade200,
                    context: context,
                    position: RelativeRect.fromLTRB(60, 650, 0, 0),
                    items: <PopupMenuEntry>[
                  PopupMenuItem(
                  child: ListTile(
                    leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 20,
                  ),
                  title: Text(
                  'Déconnexion',
                  style: GoogleFonts.ebGaramond(
                  color: Colors.white,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                  authClass.logout();
                  Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                  builder: (builder) => SignInPage()),
                  (route) => false);
                  },
                  ),
                  ),
                  PopupMenuItem(
                  child: ListTile(
                  leading: Icon(Icons.close_sharp,
                  color: Colors.white, size: 20),
                  title: Text(
                  'Fermer',
                  style: GoogleFonts.ebGaramond(
                  color: Colors.white,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                  Navigator.of(context).pop();
                  },
                  ),
                  ),
                  ],
                  );
                  },
                child: Icon(
                  Icons.settings_outlined,
                  size: 35,
                  color: Colors.deepPurple.shade400,
                ),
              ),
              label: "",
            ),
          ],
        )
    );
  }
}
