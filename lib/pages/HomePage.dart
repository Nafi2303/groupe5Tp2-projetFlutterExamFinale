import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskmanager/Custom/TaskCard.dart';
import 'package:taskmanager/Services/AuthService.dart';
import 'package:taskmanager/pages/AddTask.dart';
import 'package:taskmanager/pages/MainHome.dart';
import 'package:taskmanager/pages/SignInPage.dart';
import 'package:taskmanager/pages/ViewData.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime today;
  late String dateDuJour;
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Task").snapshots();
  String texte = "Tâche sans titre";
  List<Select> selected = [];
  late final String text;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    dateDuJour = "${today.day}/${today.month}/${today.year}";
  }

  @override
  Widget build(BuildContext context) {
    var user = firebaseAuth.currentUser!;
    var userEmail = user.email;
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Colors.deepPurple.shade500,
        toolbarHeight: 90,
        actions: [
          Container(
            width: MediaQuery.of(context).size.width - 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'UserID : $userEmail',
                  style: GoogleFonts.fruktur(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                widthFactor: 50,
                heightFactor: 20,
                child: Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width - 45,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  IconData iconData = Icons.category_sharp;
                  Color iconColor = Colors.black;
                  Map<String, dynamic> document =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  switch (document["categorie"]) {
                    case "Travail":
                      iconData = Icons.work_rounded;
                      iconColor = Colors.black;
                      break;
                    case "Design":
                      iconData = Icons.design_services_sharp;
                      iconColor = Colors.black;
                      break;
                    case "Course":
                      iconData = Icons.transfer_within_a_station_outlined;
                      iconColor = Colors.black;
                      break;
                    case "Sport":
                      iconData = CupertinoIcons.sportscourt;
                      iconColor = Colors.black;
                      break;
                    case "Lecture":
                      iconData = Icons.menu_book_sharp;
                      iconColor = Colors.black;
                      break;
                    case "Commande":
                      iconData = Icons.payments_sharp;
                      iconColor = Colors.black;
                      break;
                    case "Gaming":
                      iconData = Icons.sports_esports_outlined;
                      iconColor = Colors.black;
                      break;
                    default:
                      iconData = Icons.category_sharp;
                      iconColor = Colors.black;
                  }
                  selected.add(Select(
                      id: snapshot.data!.docs[index].id, checkValue: false));
                  return InkWell(
                    onTap: selected[index].checkValue
                        ? () {}
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => ViewDataPage(
                                  document: document,
                                  id: snapshot.data!.docs[index].id,
                                ),
                              ),
                            );
                          },
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          TaskCard(
                            title: document["title"] ?? texte,
                            iconData: iconData,
                            iconColor: iconColor,
                            check: selected[index].checkValue,
                            iconBgColor: Colors.white,
                            time: document["heure"] ?? "",
                            index: index,
                            onChange: onChange,
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple.shade500,
        items: [
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => MainHomePage()));
              },
              child: Icon(
                Icons.home_rounded,
                size: 35,
                color: Colors.white,
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
                  color: Colors.deepPurple.shade200,
                  context: context,
                  position: RelativeRect.fromLTRB(40, 580, 0, 0),
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
                        leading: Icon(Icons.delete_outline,
                            color: Colors.white, size: 20),
                        title: Text(
                          'Supprimer',
                          style: GoogleFonts.ebGaramond(
                              color: Colors.white,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                elevation: 15,
                                backgroundColor: Colors.black,
                                title: Text('Confirmation'),
                                titleTextStyle: GoogleFonts.fruktur(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 2,
                                ),
                                content: Text(
                                  'Notez que toute suppression est definitive et irréversible.\n'
                                  'Voulez-vous vraiment supprimer cet élément ?',
                                  style: GoogleFonts.fruktur(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                    letterSpacing: 2,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'Annuler',
                                      style: GoogleFonts.fruktur(
                                        color: Colors.green.shade800,
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Ferme la boîte de dialogue
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Oui, Supprimer',
                                      style: GoogleFonts.fruktur(
                                        color: Colors.red.shade900,
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    onPressed: () {
                                      var instance = FirebaseFirestore.instance
                                          .collection("Task");
                                      for (var i = 0;
                                          i < selected.length;
                                          i++) {
                                        if (selected[i].checkValue) {
                                          instance.doc(selected[i].id).delete();
                                        }
                                      }
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
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
                color: Colors.white,
              ),
            ),
            label: "",
          ),
        ],
      ),
    );
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }
}

class Select {
  late String id;
  bool checkValue = false;
  Select({required this.id, required this.checkValue});
}
