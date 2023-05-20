import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/pages/HomePage.dart';

class ViewDataPage extends StatefulWidget {
  const ViewDataPage({Key? key, required this.document, required this.id})
      : super(key: key);
  final Map<String, dynamic> document;
  final String id;
  @override
  State<ViewDataPage> createState() => _ViewDataPageState();
}

class _ViewDataPageState extends State<ViewDataPage> {
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _descriptionController;
  late TextEditingController _timeController;
  late String type;
  late String category;
  DateTime _selectedDate = DateTime.now();
  String Date = "";
  bool edit = false;

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
        _timeController.text = _selectedTime!.format(context);
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 15,
            backgroundColor: Colors.deepPurple.shade500,
            title: Text("Heure Sélectionnée"),
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
            title: Text("DATE D'ÉCHÉANCE"),
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
  void initState() {
    super.initState();
    String title = widget.document["title"] ?? "Tâche Sans Titre";
    String date = widget.document["exp_date"] ?? "Tâche Sans Date d'échéance";
    String heure = widget.document["heure"] ?? "Heure non défini";
    String desc = widget.document["description"] ?? "Tâche Sans Description";
    _titleController = TextEditingController(text: title);
    _dateController = TextEditingController(text: date);
    _timeController = TextEditingController(text: heure);
    type = widget.document["type"];
    _descriptionController = TextEditingController(text: desc);
    category = widget.document["categorie"];
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
              Colors.deepPurple.shade400,
              Colors.deepPurple.shade100,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 40),
                  ),
                  SizedBox(width: 100),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            edit = !edit;
                          });
                        },
                        icon: Icon(
                          edit ? Icons.edit_note_rounded : Icons.edit,
                          color: edit ? Colors.indigo.shade900 : Colors.white,
                          size: 50,
                        ),
                      ),
                      SizedBox(width: 40),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                elevation: 15,
                                backgroundColor: Colors.black,
                                title: Text('Confirmation',textAlign: TextAlign.center,),
                                titleTextStyle: GoogleFonts.fruktur(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 2,
                                ),
                                content: Text(
                                  'Notez que toute suppression est definitive et irréversible.\n'
                                    'Voulez-vous vraiment supprimer cet élément ?',
                                  style: GoogleFonts.ebGaramond(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,

                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'Annuler',
                                      style: GoogleFonts.fruktur(
                                        color: Colors.green.shade800,
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Oui, Supprimer',
                                      style: GoogleFonts.fruktur(
                                        color: Colors.red.shade900,
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("Task")
                                          .doc(widget.id)
                                          .delete()
                                          .then((value) =>
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder:
                                                      (builder)=>HomePage())));
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(
                          CupertinoIcons.delete_simple,
                          color: Colors.red.shade800,
                          size: 40,
                        ),
                      ),
                      SizedBox(width: 15)
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(edit ? "Modification de" : "Consulter",
                        style: GoogleFonts.fruktur(
                          color: Colors.white,
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 4,
                        )),
                    const SizedBox(height: 7),
                    Text("Vos",
                        style: GoogleFonts.fruktur(
                          color: Colors.white,
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 3,
                        )),
                    const SizedBox(height: 7),
                    Text("Tâches",
                        style: GoogleFonts.fruktur(
                          color: Colors.white,
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 3,
                        )),
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
                        taskSelect("Important", Colors.green.shade700),
                        const SizedBox(width: 15),
                        taskSelect("Programmée", Colors.deepOrange.shade700),
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
                          child:
                              categorySelect("Travail", Colors.blue.shade700),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: categorySelect(
                              "Design", Colors.lightBlueAccent.shade400),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child:
                              categorySelect("Course", Colors.green.shade700),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child:
                              categorySelect("Sport", Colors.orange.shade700),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: categorySelect(
                              "Lecture", Colors.greenAccent.shade400),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: categorySelect(
                              "Commande", Colors.deepPurple.shade700),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: categorySelect("Gaming", Colors.cyan.shade300),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: categorySelect(
                              "Autres", Colors.deepOrange.shade500),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    edit ? button() : Container(),
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

  Widget button() {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection("Task").doc(widget.id).update(
          {
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
              title:
                  edit ? Text("MODIFIER LA TÂCHE") : Text("AJOUTER LA TÂCHE"),
              titleTextStyle: GoogleFonts.fruktur(
                color: Colors.white,
                fontSize: 20,
                fontStyle: FontStyle.italic,
                letterSpacing: 2,
              ),
              content: Text(
                edit
                    ? "VOTRE TÂCHE À ÉTÉ MODIFIÉ AVEC SUCCÈS.\nEN CLIQUANT SUR OK VOUS SEREZ REDIRIGÉ SUR LA PAGE D'ACCUEIL"
                    : "VOTRE TÂCHE À ÉTÉ AJOUTÉ AVEC SUCCÈS.\nEN CLIQUANT SUR OK VOUS SEREZ REDIRIGÉ SUR LA PAGE D'ACCUEIL",
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
                      MaterialPageRoute(builder: (builder) => HomePage())),
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
              edit ? "Modifier la Tâche" : "Ajouter la Tâche",
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

  Widget taskSelect(String label, color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                type = label;
              });
            }
          : null,
      child: Chip(
        backgroundColor: type == label ? Colors.deepPurple.shade50 : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: GoogleFonts.ebGaramond(
            color: type == label ? color : Colors.white,
            fontSize: type == label ? 20 : 15,
            fontStyle: type == label ? FontStyle.normal : FontStyle.italic,
            fontWeight: type == label ? FontWeight.w900 : FontWeight.bold,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 6),
      ),
    );
  }

  Widget categorySelect(String label, color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                category = label;
              });
            }
          : null,
      child: Chip(
        backgroundColor: category == label ? Colors.deepPurple.shade50 : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: GoogleFonts.ebGaramond(
            color: category == label ? color : Colors.white,
            fontSize: category == label ? 23 : 17,
            fontStyle: category == label ? FontStyle.normal : FontStyle.italic,
            fontWeight: category == label ? FontWeight.w900 : FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 6),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade500,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        enabled: edit,
        enableSuggestions: true,
        style: GoogleFonts.ebGaramond(
          color: Colors.white,
          fontSize: 20,
          fontStyle: FontStyle.italic,
          letterSpacing: 1,
        ),
        decoration: InputDecoration(
          hintText: "Titre de la Tâche",
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

  Widget description() {
    return Container(
      height: 170,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade500,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        enabled: edit,
        enableSuggestions: true,
        style: GoogleFonts.ebGaramond(
          color: Colors.white,
          fontSize: 20,
          fontStyle: FontStyle.italic,
          letterSpacing: 1,
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

  Widget dateTimeOut() {
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
        enabled: edit,
        readOnly: true,
        onTap: () => _selectDate(context),
        decoration: InputDecoration(
          hintText: _dateController != null ? "Choisissez une date" : "",
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
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: InputBorder.none,
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Icon(
              Icons.calendar_today,
              size: 35,
              color: Colors.deepPurple.shade50,
            ),
          ),
        ),
      ),
    );
  }

  Widget plannedTime() {
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
        enabled: edit,
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
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: InputBorder.none,
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Icon(
              Icons.access_time_outlined,
              size: 35,
              color: Colors.deepPurple.shade50,
            ),
          ),
        ),
      ),
    );
  }

  Widget label(label) {
    return Text(label,
        style: GoogleFonts.ebGaramond(
          color: Colors.white,
          fontSize: 25,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ));
  }
}
