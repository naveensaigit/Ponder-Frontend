import 'package:flutter/material.dart';
import 'package:pdfviewer/screens/answer_card.dart';
import 'package:swipeable_card/swipeable_card.dart';
import 'card_example.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:math';

Random random = new Random();

class CardSwipe extends StatefulWidget {
  final String text;
  final double htemp;
  final context;
  const CardSwipe(
      {Key? key, this.text = "", this.htemp = 0.0, this.context = ""})
      : super(key: key);

  @override
  _CardSwipeState createState() => _CardSwipeState();
}

class _CardSwipeState extends State<CardSwipe> {
  List? quest, userAns, trueAns, similarity, ansCards, questCards;
  bool showanswer = false;
  // List<TextEditingController> controllers;
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.indigo,
    Colors.green,
    Colors.purple,
    Colors.blueGrey,
    Colors.cyan,
    Colors.amber,
    Colors.brown,
    Colors.pink,
    Colors.teal
  ];
  int currentCardIndex = 0, ansCardIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchQuestions.then((response) {
      print("-------RESPONSE----");
      print(response);
      if (response != null) {
        var responseData = response["response"];
        print("-------RESPONSE_DATA----");
        print(responseData);
        if (responseData != null)
          setState(() {
            trueAns = List.generate(
              responseData.length,
              (i) => responseData[i]["answer"],
            );
            quest = List.generate(
              responseData.length,
              (i) => responseData[i]["question"],
            );
            questCards = List.generate(
              responseData.length,
              (i) => FlashCard(
                  color: colors[random.nextInt(colors.length)],
                  question: responseData[i]["question"],
                  controller: TextEditingController()),
            );
            print(questCards);
          });
      }
    });
  }

  Future get fetchQuestions async {
    Map<String, String> data = {"text": widget.text};
    String body = json.encode(data);
    print("-------------BODY----------");
    print(body);
    var response = await post(
        Uri.parse('https://aced00184946.ngrok.io/transformer/generate'),
        headers: {"Content-Type": "application/json"},
        body: body);
    return json.decode(response.body);
  }

  Future get fetchSimilarity async {
    Map<String, List> data = {
      "trueAns": trueAns ?? [],
      "userAns": List.generate(
          questCards!.length, (i) => questCards![i].controller.value.text)
    };
    setState(() {
      userAns = data["userAns"];
    });
    String body = json.encode(data);
    print("-------------SBODY----------");
    print(body);
    var response = await post(
        Uri.parse('https://aced00184946.ngrok.io/similarity'),
        headers: {"Content-Type": "application/json"},
        body: body);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    SwipeableWidgetController _cardController = SwipeableWidgetController();
    SwipeableWidgetController _ansController = SwipeableWidgetController();
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 3.0,
          sigmaY: 3.0,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: (showanswer == true && similarity != null)
                ? <Widget>[
                    if (ansCards != null &&
                        ansCardIndex >= 0 &&
                        ansCardIndex < ansCards!.length - 1)
                      SwipeableWidgetSlide(
                        key: ObjectKey(ansCardIndex),
                        child: ansCards![ansCardIndex],
                        onLeftSwipe: () => swipeAns(),
                        onRightSwipe: () => swipeAns(),
                        onTopSwipe: () => swipeAns(),
                        onBottomSwipe: () => swipeAns(),
                        nextCards: <Widget>[
                          if (!(ansCardIndex + 1 >= ansCards!.length))
                            Align(
                              alignment: Alignment.center,
                              child: ansCards![ansCardIndex + 1],
                            )
                        ],
                      )
                    else if (ansCards != null &&
                        ansCardIndex >= 0 &&
                        ansCardIndex == ansCards!.length - 1)
                      ansCards![ansCardIndex]
                    else
                      Container(
                          child: CircularProgressIndicator(),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height -
                              widget.htemp -
                              96,
                          alignment: Alignment.center),
                    if (ansCards != null &&
                        ansCardIndex >= 0 &&
                        ansCardIndex < ansCards!.length)
                      ansControllerRow(_ansController)
                  ]
                : <Widget>[
                    if (questCards != null &&
                        currentCardIndex >= 0 &&
                        currentCardIndex < questCards!.length)
                      SwipeableWidgetSlide(
                        key: ObjectKey(currentCardIndex),
                        child: questCards![currentCardIndex],
                        onLeftSwipe: () => swipe(),
                        onRightSwipe: () => swipe(),
                        onTopSwipe: () => swipe(),
                        onBottomSwipe: () => swipe(),
                        nextCards: <Widget>[
                          if (!(currentCardIndex + 1 >= questCards!.length))
                            Align(
                              alignment: Alignment.center,
                              child: questCards![currentCardIndex + 1],
                            )
                        ],
                      )
                    else
                      Container(
                          child: CircularProgressIndicator(),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height -
                              widget.htemp -
                              96,
                          alignment: Alignment.center),
                    if (questCards != null &&
                        currentCardIndex >= 0 &&
                        currentCardIndex < questCards!.length)
                      cardControllerRow(_cardController)
                  ],
          ),
        ),
      ),
    );
  }

  void swipe() {
    if (currentCardIndex < questCards!.length) {
      setState(() => currentCardIndex++);
      if (currentCardIndex == questCards!.length) verify();
    }
  }

  void swipeAns() {
    if (ansCardIndex < ansCards!.length) {
      setState(() => ansCardIndex++);
      if (ansCardIndex == ansCards!.length) verify();
    }
  }

  void bringBack() {
    if (currentCardIndex > 0) setState(() => currentCardIndex--);
  }

  void bringBackAns() {
    if (ansCardIndex > 0) setState(() => ansCardIndex--);
  }

  void verify() {
    fetchSimilarity.then((response) {
      setState(() {
        showanswer = true;
        similarity = response["similarity"];
        double totalScore = 0;
        for (int i = 0; i < similarity!.length; i++)
          totalScore +=
              double.parse((10.0 * similarity![i]).toStringAsFixed(2));
        ansCards = List.generate(
            similarity!.length + 1,
            (i) => i < similarity!.length
                ? AnswerCard(
                    color: colors[random.nextInt(colors.length)],
                    question: quest![i] ?? "",
                    trueAns: trueAns![i] ?? "",
                    userAns: userAns![i] ?? "",
                    score: double.parse(
                        (10.0 * similarity![i]).toStringAsFixed(2)))
                : AnswerCard(
                    color: colors[random.nextInt(colors.length)],
                    question: "$totalScore/${similarity!.length * 10}",
                    userAns:
                        (totalScore / similarity!.length).toStringAsFixed(2),
                    last: true,
                    trueAns: "\nContinue Studying!!!"));
        print("-------------Verified------------");
        print(showanswer);
        print(similarity);
      });
    });
  }

  Widget cardControllerRow(SwipeableWidgetController cardController) {
    if (currentCardIndex == 0)
      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: TextButton(
          child: Text("Next", style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
            alignment: Alignment.center,
          ),
          onPressed: () => swipe(),
        ),
      );
    else if (currentCardIndex > 0 && currentCardIndex < questCards!.length - 1)
      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Text(
                "Back",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                alignment: Alignment.center,
              ),
              onPressed: () => bringBack(),
            ),
            SizedBox(width: 20),
            TextButton(
              child: Text(
                "Next",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                alignment: Alignment.center,
              ),
              onPressed: () => swipe(),
            ),
          ],
        ),
      );
    else if (currentCardIndex == questCards!.length - 1)
      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  alignment: Alignment.center,
                ),
                onPressed: () => verify()),
            SizedBox(width: 15, height: 15),
            TextButton(
              child: Text(
                "Back",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                alignment: Alignment.center,
              ),
              onPressed: () => bringBack(),
            )
          ],
        ),
      );
    else
      return TextButton(
          child: Text("", style: TextStyle(color: Colors.transparent)),
          onPressed: () => null);
  }

  Widget ansControllerRow(SwipeableWidgetController _ansController) {
    if (ansCardIndex == 0)
      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: TextButton(
          child: Text("Next", style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
            alignment: Alignment.center,
          ),
          onPressed: () => swipeAns(),
        ),
      );
    else if (ansCardIndex > 0 && ansCardIndex < ansCards!.length - 2)
      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                child: Text(
                  "Back",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  alignment: Alignment.center,
                ),
                onPressed: () => bringBackAns()),
            SizedBox(width: 15, height: 15),
            TextButton(
              child: Text(
                "Next",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                alignment: Alignment.center,
              ),
              onPressed: () => swipeAns(),
            )
          ],
        ),
      );
    else if (ansCardIndex == ansCards!.length - 2)
      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: TextButton(
          child: Text(
            "Back",
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
            alignment: Alignment.center,
          ),
          onPressed: () => bringBackAns(),
        ),
      );
    else
      return TextButton(
          child: Text("", style: TextStyle(color: Colors.transparent)),
          onPressed: () => null);
  }
}
