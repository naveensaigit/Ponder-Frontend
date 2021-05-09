import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';

class Swiper extends StatefulWidget {
  @override
  _SwiperState createState() => _SwiperState();
  final String genre;
  final int id, index;
  const Swiper({Key? key, this.genre = "", this.id = 210, this.index = 0})
      : super(key: key);
}

class _SwiperState extends State<Swiper> {
  List? data;

  Future get response async {
    await Future.delayed(
        Duration(milliseconds: 5000 * widget.index), () async {});
    Map<String, int> data = {"topic_id": widget.id, "page_num": 1};
    String body = json.encode(data);
    var response = await post(
        Uri.parse('https://aced00184946.ngrok.io/libgen/getBooks'),
        headers: {"Content-Type": "application/json"},
        body: body);
    // print(response.body.toString());
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    if (response != null)
      response.then((res) {
        setState(() {
          data = res;
          print(data);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return (data == null)
        ? CircularProgressIndicator()
        : Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            height: 200.0,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                for (int i = 0; i < data!.length; i++)
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      width: 140.0,
                      child: Image.network((data?[i]["icons"])))
              ],
            ));
  }
}
