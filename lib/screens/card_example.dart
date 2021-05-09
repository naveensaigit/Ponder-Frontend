import 'package:flutter/material.dart';

class FlashCard extends StatefulWidget {
  const FlashCard({
    Key? key,
    this.color = Colors.indigo,
    this.question = "Loading...",
    this.controller = "",
  }) : super(key: key);
  final Color color;
  final String question;
  final controller;

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    myFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.7 * MediaQuery.of(context).size.height,
      width: 0.85 * MediaQuery.of(context).size.width,
      // Warning: hard-coding values like this is a bad practice
      padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          width: 7.0,
          color: Colors.transparent.withOpacity(0.3),
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            widget.question,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25.0,
              // color: Colors.white,
              color: Colors.white.withOpacity(0.95),
              fontWeight: FontWeight.w900,
            ),
          ),
          Container(
            color: Colors.transparent,
            margin: EdgeInsets.only(top: 20),
            padding: new EdgeInsets.all(7.0),
            child: new ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 50.0,
                maxHeight: 190.0,
              ),
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: true,

                // here's the actual text box
                child: new Theme(
                  data: new ThemeData(
                    primaryColor: Colors.white,
                    primaryColorDark: Colors.red,
                  ),
                  child: new TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 5,
                    maxLines: null, //grow automatically
                    controller: widget.controller,
                    focusNode: myFocusNode,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    cursorColor: Colors.white,
                    decoration: new InputDecoration(
                      hintText: 'Type out your answer',
                      hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                      labelText: 'Answer',
                      labelStyle:
                          TextStyle(fontSize: 20.0, color: Colors.white),
                      enabledBorder: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          borderSide:
                              new BorderSide(color: Colors.white, width: 4.0)),
                      focusedBorder: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          borderSide:
                              new BorderSide(color: Colors.white, width: 4.0)),
                    ),
                  ),
                ),
                // ends the actual text box
              ),
            ),
          ),
        ],
      ),
    );
  }
}
