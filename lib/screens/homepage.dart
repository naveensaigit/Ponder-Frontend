import 'package:flutter/material.dart';
import './swiper.dart';

class HomePage extends StatelessWidget {
  final catid = {
    "Technology": {
      "id": "210",
      "subtopic": {
        "Aerospace Equipment": "212",
        "Automation": "211",
        "Communication: Telecommunications": "235",
        "Communication": "234",
        "Construction": "236",
        "Construction: Cement Industry": "241",
        "Construction: Renovation and interior design: Saunas": "240",
        "Construction: Renovation and interior design": "239",
        "Construction: Ventilation and Air Conditioning": "238",
        "Electronics: Electronics": "261",
        "Electronics: Fiber Optics": "252",
        "Electronics: Hardware": "251",
        "Electronics: Home Electronics": "253",
        "Electronics: Microprocessor Technology": "254",
        "Electronics: Radio": "256",
        "Electronics: Robotics": "257",
        "Electronics: Signal Processing": "255",
        "Electronics: Telecommunications": "260",
        "Electronics: TV. Video": "259",
        "Electronics: VLSI": "258",
        "Electronics": "250",
        "Energy: Renewable Energy": "263",
        "Energy": "262",
        "Food Manufacturing": "229",
        "Fuel Technology": "243",
        "Heat": "242",
        "industrial equipment and technology": "232",
        "Industry: Metallurgy": "231",
        "Instrument": "230",
        "Light Industry": "218",
        "Materials": "219",
        "Mechanical Engineering": "220",
        "Metallurgy": "221",
        "Metrology": "222",
        "Military equipment: Weapon": "215",
        "Military equipment": "214",
        "Missiles": "233",
        "Nanotechnology": "224",
        "Oil and Gas Technologies: Pipelines": "226",
        "Oil and Gas Technologies": "225",
        "Patent Business. Ingenuity. Innovation": "228",
        "Publishing": "216",
        "Refrigeration": "249",
        "Regulatory Literature": "227",
        "Safety and Security": "223",
        "Space Science": "217",
        "Transport": "244",
        "Transportation: Aviation": "245",
        "Transportation: Cars, motorcycles": "246",
        "Transportation: Rail": "247",
        "Transportation: Ships": "248",
      }
    },
    "Art": {
      "id": "57",
      "subtopic": {
        "Cinema": "60",
        "Design: Architecture": "58",
        "Graphic Arts": "59",
        "Music": "61",
        "Music: Guitar": "62",
        "Photo": "63"
      }
    },
    "Biology": {
      "id": "12",
      "subtopic": {
        "Anthropology": "14",
        "Anthropology: Evolution": "15",
        "Biostatistics": "16",
        "Biotechnology": "17",
        "Biophysics": "18",
        "Biochemistry": "19",
        "Biochemistry: enologist": "20",
        "Ecology": "31",
        "Estestvoznananie": "13",
        "Genetics": "22",
        "Microbiology": "26",
        "Molecular": "27",
        "Molecular: Bioinformatics": "28",
        "Plants: Agriculture and Forestry": "30",
        "Virology": "21",
        "Zoology": "23",
        "Zoology:Paleontology": "24",
        "Zoology: Fish": "25"
      }
    },
    "Business": {
      "id": "1",
      "subtopic": {
        "Accounting": "2",
        "E-Commerce": "11",
        "Logistics": "3",
        "Management": "6",
        "Marketing": "4",
        "Marketing: Advertising": "5",
        "Management: Project Management": "7",
        "MLM": "8",
        "Responsibility and Business Ethics": "9",
        "Trading": "10"
      }
    },
    "Chemistry": {
      "id": "296",
      "subtopic": {
        "Analytical Chemistry": "297",
        "Chemical": "304",
        "Inorganic Chemistry": "299",
        "Materials": "298",
        "Organic Chemistry": "300",
        "Pyrotechnics and explosives": "301",
        "Pharmacology": "302",
        "Physical Chemistry": "303"
      }
    },
    "Water Treatment": {"id": "213"}
  };
  final List<String> genres = [
    'Technology',
    'Art',
    'Biology',
    'Business',
    'Chemistry',
    'Water Treatment'
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Tech"),
      ),
      body: new Center(
        child: new Container(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              for (int i = 0; i < genres.length; i++)
                Container(
                  margin: EdgeInsets.only(left: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            genres[i],
                            style: TextStyle(fontSize: 20),
                          )),
                      // Swiper(
                      //     genre: genres[i],
                      //     id: int.parse(catid[genres[i]]["id"] ?? 0),
                      //     index: i),
                    ],
                  ),
                )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
