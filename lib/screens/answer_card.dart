import 'package:flutter/material.dart';

class AnswerCard extends StatefulWidget {
  const AnswerCard(
      {Key? key,
      this.color = Colors.indigo,
      this.question = "",
      this.trueAns = "",
      this.userAns = "",
      this.score = -1,
      this.last = false})
      : super(key: key);
  final Color color;
  final String question, trueAns, userAns;
  final double score;
  final bool last;

  @override
  _AnswerCardState createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    myFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
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
          child: (widget.last == true)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      Text(
                        "Total Score: " + widget.question,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white.withOpacity(0.95),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "Avg. Score: " + widget.userAns,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white.withOpacity(0.95),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        widget.trueAns,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white.withOpacity(0.95),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ])
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        if (widget.question != "")
                          Text(
                            "Question",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 25.0,
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        Text(
                          widget.question,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 30),
                        if (widget.userAns != "")
                          Text(
                            "Your Answer",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 25.0,
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        Text(
                          widget.userAns,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 30),
                        if (widget.trueAns != "")
                          Text(
                            "Correct Answer",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 25.0,
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        Text(
                          widget.trueAns,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 30),
                        if (widget.score >= 0)
                          Text(
                            "Score: " + widget.score.toString() + "/10",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                      ],
                    ),
                  ],
                )),
    );
  }
}
