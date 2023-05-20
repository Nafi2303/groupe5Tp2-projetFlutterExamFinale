import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/pages/HomePage.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);
  //final String _selectedTime;
  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  String type ="";
  String category ="";
  DateTime _selectedDate = DateTime.now();
  String Date ="";

  TimeOfDay? _selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      String formattedTime = DateFormat('kk:mm')
          .format(DateTime(2000, 1, 1, pickedTime.hour, pickedTime.minute));

      setState(() {
        _selectedTime = pickedTime;
        _timeController.text =_selectedTime!.format(context);
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 15,
            backgroundColor: Colors.deepPurple.shade500,
            title: Text(
              "Heure Sélectionnée"
            ),
            titleTextStyle: GoogleFonts.fruktur(
              color: Colors.white,
              fontSize: 20,
              fontStyle: FontStyle.italic,
              letterSpacing: 2,
            ),

            content: Text(
              "Votre programme à été defini sur : $formattedTime",
              style: GoogleFonts.fruktur(
                color: Colors.white,
                fontSize: 20,
                fontStyle: FontStyle.italic,
                letterSpacing: 2,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "OK",
                  style: GoogleFonts.fruktur(
                    color: Colors.white,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 2,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
        Date = _dateController.text;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 15,
            backgroundColor: Colors.deepPurple.shade500,
            title: Text(
                "DATE D'ÉCHÉANCE"
            ),
            titleTextStyle: GoogleFonts.fruktur(
              color: Colors.white,
              fontSize: 20,
              fontStyle: FontStyle.italic,
              letterSpacing: 2,
            ),

            content: Text(
              "VOUS AVEZ DÉCIDEZ QUE VOTRE TÂCHE PRENDRA FIN LE : $Date",
              style: GoogleFonts.fruktur(
                color: Colors.white,
                fontSize: 20,
                fontStyle: FontStyle.italic,
                letterSpacing: 2,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "OK",
                  style: GoogleFonts.fruktur(
                    color: Colors.white,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 2,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
            Colors.deepPurple.shade200,
            Colors.deepPurple.shade400,
          ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              IconButton(onPressed: (){
                Navigator.pop(context);
              },
                  icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 30),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Créer",
                        style: GoogleFonts.fruktur(
                          color: Colors.white,
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 4,
                        )
                    ),
                    const SizedBox(height: 7),
                    Text(
                        "Une Nouvelle",
                        style: GoogleFonts.fruktur(
                          color: Colors.white,
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 3,
                        )
                    ),
                    const SizedBox(height: 7),
                    Text(
                        "Tâche",
                        style: GoogleFonts.fruktur(
                          color: Colors.white,
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 3,
                        )
                    ),
                    const SizedBox(height: 20),
                    label("Titre"),
                    const SizedBox(height: 15),
                    title(),
                    const SizedBox(height: 30),
                    label("Date d'Échéance"),
                    const SizedBox(height: 15),
                    dateTimeOut(),
                    const SizedBox(height: 30),
                    label("Heure de la Tâche"),
                    const SizedBox(height: 15),
                    plannedTime(),
                    const SizedBox(height: 30),
                    label("Type de Tâche"),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        taskSelect("Important",Colors.green.shade700),
                        const SizedBox(width: 15),
                        taskSelect("Programmée",Colors.deepOrange.shade700),
                      ],
                    ),
                    const SizedBox(height: 30),
                    label("Description"),
                    const SizedBox(height: 20),
                    description(),
                    const SizedBox(height: 20),
                    label("Catégories"),
                    const SizedBox(height: 20),
                    Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: categorySelect("Travail",Colors.blue.shade700),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: categorySelect("Design",Colors.lightBlueAccent.shade400),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: categorySelect("Course",Colors.green.shade700),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: categorySelect("Sport",Colors.orange.shade700),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: categorySelect("Lecture",Colors.greenAccent.shade400),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: categorySelect("Commande",Colors.deepPurple.shade700),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: categorySelect("Gaming",Colors.cyan.shade300),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: categorySelect("Autres",Colors.deepOrange.shade500),
                        ),

                      ],
                    ),
                    SizedBox(height: 50),
                    button(),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button(){
    return InkWell(
      onTap: (){
        FirebaseFirestore.instance.collection("Task").add({
          "type": type,
          "title": _titleController.text,
          "exp_date": _dateController.text,
          "heure": _timeController.text,
          "description": _descriptionController.text,
          "categorie": category
        },
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              elevation: 15,
              backgroundColor: Colors.deepPurple.shade500,
              title: Text("AJOUTER UNE TÂCHE"),
              titleTextStyle: GoogleFonts.fruktur(
                color: Colors.white,
                fontSize: 20,
                fontStyle: FontStyle.italic,
                letterSpacing: 2,
              ),
              content: Text(
                "VOTRE TÂCHE À ÉTÉ AJOUTÉ AVEC SUCCÈS.\nEN CLIQUANT SUR OK VOUS SEREZ REDIRIGÉ SUR LA PAGE D'ACCUEIL",
                style: GoogleFonts.fruktur(
                  color: Colors.white,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 2,
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "RETOUR",
                    style: GoogleFonts.fruktur(
                      color: Colors.white,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 2,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text(
                      "OK",
                    style: GoogleFonts.fruktur(
                      color: Colors.white,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 2,
                    ),
                  ),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (builder)=>HomePage())),
                ),
              ],
            );
          },
        );
      },
      child: Center(
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width - 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.shade500,
                Colors.deepPurple.shade200,
                Colors.deepPurple.shade700,
              ],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
                "Ajouter la Tâche",
              style: GoogleFonts.fruktur(
                color: Colors.white,
                fontSize: 23,
                fontStyle: FontStyle.italic,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget taskSelect(String label,color){
    return InkWell(
      onTap: (){
        setState(() {
          type = label;
        });
      },
      child: Chip(
        backgroundColor: type==label?Colors.deepPurple.shade50:color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
          label: Text(
              label,
            style: GoogleFonts.ebGaramond(
              color: type==label?color:Colors.white,
              fontSize: type==label?20:15,
              fontStyle: type==label?FontStyle.normal:FontStyle.italic,
              fontWeight: type==label?FontWeight.w900:FontWeight.bold,

            ),
          ),
        labelPadding: EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 6
        ),
      ),
    );
  }

  Widget categorySelect(String label,color){
    return InkWell(
      onTap: (){
        setState(() {
            category = label;
          });
        },
      child: Chip(
        backgroundColor: category==label?Colors.deepPurple.shade50:color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: GoogleFonts.ebGaramond(
            color: category==label?color:Colors.white,
            fontSize: category==label?23:17,
            fontStyle: category==label?FontStyle.normal:FontStyle.italic,
            fontWeight: category==label?FontWeight.w900:FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 6
        ),
      ),
    );
  }

  Widget title(){
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade500,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        enableSuggestions: true,
        style: GoogleFonts.ebGaramond(
          color: Colors.white,
          fontSize: 23,

        ),
        decoration: InputDecoration(
          hintText: "Titre de la Tâche",
          hintStyle: GoogleFonts.ebGaramond(
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 1,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
          ),
        ),
        cursorColor: Colors.white,
      ),
    );
  }

  Widget description(){
    return Container(
      height: 170,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade500,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        enableSuggestions: true,
        style: GoogleFonts.ebGaramond(
          color: Colors.white,
          fontSize: 22,
        ),
        maxLines: null,
        decoration: InputDecoration(
          hintText: "Description de la Tâche",
          hintStyle: GoogleFonts.ebGaramond(
            color: Colors.white,
            fontSize: 20,
            fontStyle: FontStyle.italic,
            letterSpacing: 1,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
          ),
        ),
        cursorColor: Colors.white,
      ),
    );
  }

  Widget dateTimeOut(){
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade500,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        cursorColor: Colors.deepPurple,
        style: GoogleFonts.ebGaramond(
          color: Colors.white,
          fontSize: 22,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        controller: _dateController,
        readOnly: true,
        onTap: () => _selectDate(context),
        decoration: InputDecoration(
          hintText: _dateController != null
              ? "Choisissez une date"
              : "",
          hintStyle: GoogleFonts.ebGaramond(
            color: Colors.white,
            fontSize: 25,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
          labelStyle: GoogleFonts.ebGaramond(
            color: Colors.white,
            fontSize: 30,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 18),
          border: InputBorder.none,
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.calendar_today,
              size: 35,
              color: Colors.deepPurple.shade50,),
          ),
        ),
      ),
    );
  }

  Widget plannedTime(){
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade500,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        cursorColor: Colors.deepPurple,
        style: GoogleFonts.ebGaramond(
          color: Colors.white,
          fontSize: 22,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        controller: _timeController,
        readOnly: true,
        onTap: () => _selectTime(context),
        decoration: InputDecoration(
          hintText: _selectedTime != null
              ? "${_timeController}"
              : "Choisissez une heure",
          hintStyle: GoogleFonts.ebGaramond(
            color: Colors.white,
            fontSize: 25,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
          labelStyle: GoogleFonts.ebGaramond(
            color: Colors.white,
            fontSize: 30,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 18),
          border: InputBorder.none,
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.access_time_outlined,
              size: 35,
              color: Colors.deepPurple.shade50,),
          ),
        ),
      ),
    );
  }

  Widget label(label){
    return  Text(
        label,
        style: GoogleFonts.ebGaramond(
          color: Colors.white,
          fontSize: 25,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        )
    );
  }


}
