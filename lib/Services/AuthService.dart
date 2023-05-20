import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskmanager/pages/MainHome.dart';

class AuthClass {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  final storage = FlutterSecureStorage();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (GoogleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount!.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        try {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);
          StoreTokenAndData(userCredential);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => MainHomePage()),
              (route) => false);
        } catch (e) {
          final snackbar = SnackBar(
            content: Text(
              e.toString(),
              style: GoogleFonts.ebGaramond(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.deepPurple.shade500,
            duration: Duration(seconds: 7),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      } else {
        final snackbar = SnackBar(
          content: Text(
            "Impossible de se connecter.\nVeuillez réesayer",
            style: GoogleFonts.ebGaramond(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.deepPurple.shade500,
          duration: Duration(seconds: 7),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (e) {
      final snackbar = SnackBar(
        content: Text(
          e.toString(),
          style: GoogleFonts.ebGaramond(
            color: Colors.white,
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple.shade500,
        duration: Duration(seconds: 7),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> StoreTokenAndData(UserCredential userCredential) async {
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    await storage.write(
        key: "token", value: userCredential.credential!.token.toString());
    await storage.write(
        key: "userCredential", value: userCredential.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();
      await storage.delete(key: "token");
    } catch (e) {
      final snackbar = SnackBar(
        content: Text(
          "Un erreur est survenue lors de la déconnexion",
          style: GoogleFonts.ebGaramond(
            color: Colors.white,
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple.shade500,
        duration: Duration(seconds: 7),
      );
      print(snackbar);
    }
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification effectué");
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      showSnackBar(context, exception.toString());
    };

    PhoneCodeSent codeSent =
        (String verificationID, [int? forceResendingtoken]) {
      showSnackBar(context, "Le code de vérification à été envoyé avec succès");
      setData(verificationID);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      showSnackBar(context, "Time out");
    };

    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar(context,
          "Numéro de téléphone invalide ou code de verification incorrect");
    }
  }

  Future<void> signInWithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      StoreTokenAndData(userCredential);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => MainHomePage()),
          (route) => false);

      showSnackBar(context, "Connecté");
    } catch (e) {
      showSnackBar(
          context, "Veuillez entrez un numéro de telephone du Sénégal");
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackbar = SnackBar(
      content: Text(
        text,
        style: GoogleFonts.ebGaramond(
          color: Colors.white,
          fontSize: 18,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.deepPurple.shade500,
      duration: Duration(seconds: 7),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
