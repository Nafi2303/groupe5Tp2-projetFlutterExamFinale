import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({Key? key,
    required this.title,
    required this.iconData,
    required this.iconColor,
    required this.check,
    required this.iconBgColor,
    required this.time,
    required this.onChange,
    required this.index,

  }) : super(key: key);

  final String title;
  final IconData iconData;
  final Color iconColor;
  final bool check;
  final Color iconBgColor;
  final String time;
  final Function onChange;
  final int index;

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                activeColor: Colors.green.shade800,
                checkColor: Colors.white,
                value: widget.check,
                onChanged: (bool? value){
                  widget.onChange(widget.index);

                },

              ),
            ),
            data: ThemeData(
              primarySwatch: Colors.indigo,
              unselectedWidgetColor: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              height: 110,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.deepPurple.shade500,
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Container(
                      height: 33,
                      width: 36,
                      decoration: BoxDecoration(
                          color: widget.iconBgColor,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Icon(widget.iconData,
                        color: widget.check?Colors.grey.shade400:widget.iconColor,),
                    ),
                    SizedBox(width: 17),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: widget.check?GoogleFonts.ebGaramond(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough
                        )
                            :GoogleFonts.ebGaramond(
                            color: Colors.white,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            decoration: null
                        ),

                      ),
                    ),
                    Icon(
                       Icons.access_time,
                      color: Colors.white,
                    ),
                    SizedBox(width: 7),
                    Text(
                      widget.time,
                      style: widget.check?GoogleFonts.ebGaramond(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough
                      )
                          :GoogleFonts.ebGaramond(
                          color: Colors.white,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none
                      )
                    ),
                    SizedBox(width:10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

