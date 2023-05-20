import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:taskmanager/Services/AuthService.dart';
import 'package:taskmanager/pages/SignInPage.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key? key}) : super(key: key);

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  int start = 30;
  bool wait = false;
  String buttonName="Envoyer";
  TextEditingController phoneController = TextEditingController();
  AuthClass authClass = AuthClass();
  String verificationIdFinal = "";
  String smsCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade200,
      appBar: AppBar(
        systemOverlayStyle:const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Colors.deepPurple.shade200,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined,size: 30.0,),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInPage()),
            );
          },
        ),
        title: Text(
            "Inscription",
            style: GoogleFonts.fruktur(
              color: Colors.white,
              fontSize: 25,
              fontStyle: FontStyle.italic,
            ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 150),

              textField(),

              SizedBox(height: 30),

              Container(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 2,
                        color: Colors.deepPurple.shade300,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    Text("Entrez Votre Code à 6 Chiffres",
                    style: GoogleFonts.ebGaramond(
                      color: Colors.white,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: Colors.deepPurple.shade300,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              otpField(),
              SizedBox(height: 30),
              RichText(text: TextSpan(
                children: [
                  TextSpan(
                    text: "Renvoyer le code dans",
                    style: GoogleFonts.ebGaramond(
                      color: Colors.white,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " 00:$start ",
                    style: GoogleFonts.ebGaramond(
                      color: Colors.deepPurple.shade700,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "sec",
                    style: GoogleFonts.ebGaramond(
                      color: Colors.white,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ),
              SizedBox(height: 40),
              InkWell(
                onTap: (){
                  authClass.signInWithPhoneNumber(
                      verificationIdFinal,
                      smsCode,
                      context
                  );
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width - 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade600,
                        Colors.deepPurple.shade300,
                        Colors.deepPurple.shade900,
                      ],
                    ),
                  ),child: Center(
                  child: Text(
                      "Envoyer",
                    style: GoogleFonts.ebGaramond(
                      color: Colors.white,
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void startTimer(){
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if(start==0){
        timer.cancel();
        wait=false;
      }else{
        setState(() {
          start--;
        });
      }

    });
  }


  Widget otpField(){
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width - 50,
      fieldWidth: 40,
      otpFieldStyle: OtpFieldStyle(
        backgroundColor: Colors.deepPurple.shade300,
            borderColor: Colors.white,
        focusBorderColor: Colors.deepPurple.shade300,
      ),
      style: GoogleFonts.ebGaramond(
        color: Colors.white,
        fontSize: 18,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.underline,
      onCompleted: (pin) {
        print("Completed: " + pin);
        setState(() {
          smsCode = pin;
        });
      },
    );
  }

  Widget textField(){
    return Container(
      width: MediaQuery.of(context).size.width -40,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        cursorColor: Colors.deepPurple.shade700,
        style:  GoogleFonts.ebGaramond(
          color: Colors.white,
          fontSize: 18,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
        ),
        controller: phoneController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Entrez votre numéro mobile",
          hintStyle:  GoogleFonts.ebGaramond(
            color: Colors.white54,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 19,horizontal: 8),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 19,horizontal: 8),
            child: Text(
              "+221",
              style: GoogleFonts.ebGaramond(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
            suffixIcon: InkWell(
              onTap:wait?null: () async{
                startTimer();
                setState(() {
                  start=30;
                  wait=true;
                  buttonName = "Renvoyer";
                });
                await authClass.verifyPhoneNumber(
                    "+221"+phoneController.text,
                    context, setData);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13.5,horizontal: 9),
                child: Text(
                  buttonName,
                  style: GoogleFonts.ebGaramond(
                    color: wait? Colors.white54 :Colors.white,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
        ),
      ),
    );
}

void setData(verificationId){
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTimer();
  }

}
