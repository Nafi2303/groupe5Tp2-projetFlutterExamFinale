import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:taskmanager/Services/AuthService.dart';
import 'package:taskmanager/pages/MainHome.dart';
import 'package:taskmanager/pages/PhonePage.dart';
import 'package:taskmanager/pages/SignInPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool circular = false;
  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.deepPurple.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Inscription",
                  style: GoogleFonts.fruktur(
                    color: Colors.white,
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                  )),
              SizedBox(height: 20),
              buttonItem(
                  "assets/images/google.svg", "Inscription avec Google", 25,
                  () async {
                setState(() {
                  circular = true;
                });
                await authClass.googleSignIn(context);
              }),
              SizedBox(height: 20),
              buttonItem(
                  "assets/images/phone.svg", "Inscription par télephone", 35,
                  () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => PhoneAuthPage()),
                    (route) => false);
              }),
              SizedBox(height: 20),
              Text(
                "Or",
                style: GoogleFonts.ebGaramond(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              textItem("E-mail....", _emailController, false),
              SizedBox(height: 20),
              textItem("Password....", _passwordController, true),
              SizedBox(height: 20),
              colorButton("S'inscrire"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Vous avez déjà un compte? ",
                      style: GoogleFonts.ebGaramond(
                        color: Colors.white,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      )),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (builder) => SignInPage()),
                          (route) => false);
                    },
                    child: Text("Se Connecter",
                        style: GoogleFonts.ebGaramond(
                          color: Colors.white,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonItem(
      String imagepath, String buttonName, double size, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        height: 60,
        child: Card(
          elevation: 25,
          color: Colors.deepPurple.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              width: 3,
              color: Colors.deepPurple.shade500,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagepath,
                height: size,
                width: size,
              ),
              SizedBox(width: 20),
              Text(
                buttonName,
                style: GoogleFonts.ebGaramond(
                  color: Colors.white,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget colorButton(String buttontext) {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });

        try {
          firebase_auth.UserCredential userCredential =
              await firebaseAuth.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          print(userCredential.user?.email);

          setState(() {
            circular = false;
          });

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => MainHomePage()),
              (route) => false);
        } catch (e) {
          final snackbar = SnackBar(
            content: Text(
              "Veuillez choisir une methode de connexion ou créer un identifiant."
              "\nSi vous avez saisi des identifiants et que vous n'arrivez pas"
              " à vous connecter veuillez vous assurer d'avoir un E-mail valide"
              " et un mot de passe d'au moins 6 caractères.",
              style: GoogleFonts.ebGaramond(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.deepPurple.shade500,
            duration: Duration(seconds: 10),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 110,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade600,
              Colors.deepPurple.shade300,
              Colors.deepPurple.shade900,
            ],
          ),
        ),
        child: Center(
          child: circular
              ? CircularProgressIndicator(
                  color: Colors.deepPurple.shade700, strokeWidth: 6.0)
              : Text(buttontext,
                  style: GoogleFonts.ebGaramond(
                    color: Colors.white,
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  )),
        ),
      ),
    );
  }

  Widget textItem(
      String labeltext, TextEditingController controller, bool obscureText) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        style: GoogleFonts.ebGaramond(fontSize: 20, color: Colors.white),
        cursorColor: Colors.white,
        keyboardAppearance: Brightness.light,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          focusColor: Colors.deepPurpleAccent,
          hoverColor: Colors.deepPurpleAccent.shade700,
          fillColor: Colors.deepPurpleAccent,
          labelText: labeltext,
          labelStyle: GoogleFonts.ebGaramond(fontSize: 20, color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 3, color: Colors.deepPurple),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 3, color: Colors.deepPurple),
          ),
        ),
      ),
    );
  }
}
