import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'example_slide_route.dart';

class PDFViewer extends StatefulWidget {
  @override
  _PDFViewerState createState() => _PDFViewerState();
  final String path;
  const PDFViewer({Key? key, this.path = ""});
}

class _PDFViewerState extends State<PDFViewer> {
  File? localFile;
  OverlayState? overlayState;
  OverlayEntry? overlayEntry;
  AppBar? _appBar;
  bool display = false;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  void initState() {
    super.initState();
    if (localfile != null)
      localfile.then((File _localFile) {
        setState(() {
          localFile = _localFile;
        });
      });
  }

  showOverlay(BuildContext context) {
    print("-----------Here2-----------");
    String text = "";
    _pdfViewerKey.currentState!.getSelectedTextLines().forEach((pdfTextline) {
      text += pdfTextline.text + " ";
    });
    final htemp = _appBar!.preferredSize.height;
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: htemp + 48,
            left: 0,
            height: MediaQuery.of(context).size.height - htemp - 48,
            width: MediaQuery.of(context).size.width,
            child: CardSwipe(text: text, htemp: htemp, context: context)));
    overlayState!.insert(overlayEntry!);
  }

  Future<File> get localfile async {
    print("HERE----------");
    print(widget.path);
    var status = await Permission.storage.status;
    if (!status.isGranted) await Permission.storage.request();
    if (await Permission.storage.isGranted) {
      String imgPath = '/storage/emulated/0/Download/' +
          widget.path.substring(1, widget.path.length - 1);
      print("FINAL PATH");
      print(imgPath);
      return File(imgPath);
    }
    return localFile!;
  }

  PreferredSizeWidget getAppBar(BuildContext context) {
    _appBar = AppBar(title: const Text('Ponder PDF'), actions: <Widget>[
      IconButton(
          icon: display
              ? Icon(Icons.close)
              : Icon(Icons.pending_actions_outlined),
          tooltip: 'Test Yourself!',
          onPressed: display
              ? () {
                  overlayEntry?.remove();
                  setState(() {
                    display = false;
                  });
                }
              : () {
                  showOverlay(context);
                  setState(() {
                    display = true;
                  });
                })
    ]);
    return _appBar!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(context),
        // print(response.body.toString());
        // IconButton(
        //   icon: const Icon(Icons.maps_ugc_outlined),
        //   tooltip: 'Ask me Anything!',
        //   onPressed: () async {
        //     Map<String, String> data = {"text": text, "question": "W"};
        //     String body = json.encode(data);
        //     var response = await post(
        //         Uri.parse(
        //             'https://445f4e75c46f.ngrok.io/transformer/generate'),
        //         headers: {"Content-Type": "application/json"},
        //         body: body);
        //     print(response.body.toString());
        //   },
        // )
        body: localFile != null
            ? Container(
                child: SfPdfViewer.file(localFile!,
                    key: _pdfViewerKey, controller: _pdfViewerController))
            : Container());
  }
}
