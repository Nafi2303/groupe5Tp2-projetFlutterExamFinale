import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:taskmanager/Services/AuthService.dart';
import 'package:taskmanager/pages/MainHome.dart';
import 'package:taskmanager/pages/SignUpPage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

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
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          color: Colors.deepPurple.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Connexion",
                  style: GoogleFonts.fruktur(
                    color: Colors.white,
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                  )
              ),
              SizedBox(height: 20),

              buttonItem(
                  "assets/images/google.svg",
                  "Se Connecter avec Google",
                  20,
                      () async {
                    setState(() {
                      circular = true;
                    });
                    await authClass.googleSignIn(context);
                  }
              ),
              SizedBox(height: 20),

              Text("Or",
                style: GoogleFonts.ebGaramond(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                ),
              ),
              SizedBox(height: 20),
              textItem("E-mail....", _emailController, false),
              SizedBox(height: 20),
              textItem("Password....", _passwordController, true),
              SizedBox(height: 20),
              colorButton("Se Connecter"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Vous n'avez pas de compte? ",
                      style: GoogleFonts.ebGaramond(
                        color: Colors.white,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      )
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (builder) => SignUpPage()),
                              (route) => false);
                    },
                    child: Text(
                        "S'inscrire",
                        style: GoogleFonts.ebGaramond(
                          color: Colors.white,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20),
              TextButton(
                onPressed: () {
                  resetPassword(context);
                },
                child: Text(
                  "Mot de passe oublié?",
                  style: GoogleFonts.ebGaramond(
                    color: Colors.white,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonItem(String imagepath, String buttonName, double size,
      Function () onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width - 30,
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
          await firebaseAuth.signInWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text
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
          final snackbar = SnackBar(content:
          Text( "E-mail ou Mot de passe incorrect."
              "\nVeuillez revérifier vos identifiants de connexion"
              "\nSi vous en avez pas veuillez creer un identiant puis connectez vous.",
            style: GoogleFonts.ebGaramond(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
            backgroundColor: Colors.deepPurple.shade500,
            duration: Duration(seconds: 10),);
          ScaffoldMessenger.of(context).showSnackBar(snackbar);

          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width - 110,
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
              ?
          CircularProgressIndicator(
              color: Colors.deepPurple.shade700,
              strokeWidth: 6.0
          )
              :
          Text(
              buttontext,
              style: GoogleFonts.ebGaramond(
                color: Colors.white,
                fontSize: 25,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              )
          ),
        ),
      ),
    );
  }

  Widget textItem(String labeltext, TextEditingController controller,
      bool obscureText) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width - 70,
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
            borderSide: BorderSide(
                width: 3,
                color: Colors.deepPurple
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
                width: 3,
                color: Colors.deepPurple
            ),
          ),

        ),
      ),
    );
  }

  void resetPassword(BuildContext context) async {
    String? email = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController emailController = TextEditingController();
        return AlertDialog(
          elevation: 15,
          backgroundColor: Colors.deepPurple.shade200,
          title: Text(
            "Réinitialiser le mot de passe",
            style: GoogleFonts.fruktur(
              color: Colors.white,
              fontSize: 20,
              fontStyle: FontStyle.italic,
              letterSpacing: 2,
            ),
          ),
          content: TextField(
            style: GoogleFonts.ebGaramond(fontSize: 20,color: Colors.white),
            cursorColor: Colors.white,
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Adresse e-mail",
              focusColor: Colors.deepPurpleAccent,
              hoverColor: Colors.deepPurpleAccent.shade700,
              fillColor: Colors.deepPurpleAccent,
              labelStyle: GoogleFonts.ebGaramond(fontSize: 20,color: Colors.white),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    width: 3,
                    color: Colors.deepPurple
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    width: 3,
                    color: Colors.deepPurple
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Annuler",
                style: GoogleFonts.fruktur(
                  color: Colors.white,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 2,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text(
                "Envoyer",
                style: GoogleFonts.fruktur(
                  color: Colors.white,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 2,
                ),
              ),
              onPressed: () {
                String email = emailController.text.trim();
                if (email.isNotEmpty) {
                  sendPasswordResetEmail(email, context);
                  Navigator.pop(context, email);
                }
              },
              style: ButtonStyle(
                backgroundColor:MaterialStateProperty.all<Color>(Colors.deepPurple)
              ),
            ),
          ],
        );
      },
    );

    if (email != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Un e-mail de réinitialisation de mot de passe a été envoyé à $email",
            style: GoogleFonts.ebGaramond(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: Duration(seconds: 7),
        ),
      );
    }
  }

  void sendPasswordResetEmail(String email, BuildContext context) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      // Afficher un message d'erreur si la réinitialisation du mot de passe échoue
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "La réinitialisation du mot de passe a échoué. Veuillez réessayer.",
            style: TextStyle(fontSize: 16),
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }
}
