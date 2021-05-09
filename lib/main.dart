import 'package:flutter/material.dart';
import './screens/homepage.dart';
import './screens/pdf_viewer.dart';
import 'screens/swiper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import './utilities/styles.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: OnboardingScreen());
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 1;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF7B51D3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color(0xFF3594DD),
                Color(0xFF4563DB),
                Color(0xFF5036D5),
                Color(0xFF5B16D0),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 600.0,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/onboarding0.png',
                                ),
                                height: 300.0,
                                width: 300.0,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Welcome To the Ponder.',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Keep your brain active while Studying!',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 60.0,
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                onTap: () => print('Get started!'),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FilePickerDemo())),
                      child: Text(
                        'Get started',
                        style: TextStyle(
                          color: Color(0xFF5B16D0),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      print(_paths!.first.extension);
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PDFViewer(path: _fileName ?? "")));
  }

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles().then((result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result! ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    });
  }

  void _selectFolder() {
    FilePicker.platform.getDirectoryPath().then((value) {
      setState(() => _directoryPath = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Ponder'),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.only(top: 20.0),
                //   child: DropdownButton<FileType>(
                //       hint: const Text('LOAD PATH FROM'),
                //       value: _pickingType,
                //       items: <DropdownMenuItem<FileType>>[
                //         DropdownMenuItem(
                //           child: const Text('FROM AUDIO'),
                //           value: FileType.audio,
                //         ),
                //         DropdownMenuItem(
                //           child: const Text('FROM IMAGE'),
                //           value: FileType.image,
                //         ),
                //         DropdownMenuItem(
                //           child: const Text('FROM VIDEO'),
                //           value: FileType.video,
                //         ),
                //         DropdownMenuItem(
                //           child: const Text('FROM MEDIA'),
                //           value: FileType.media,
                //         ),
                //         DropdownMenuItem(
                //           child: const Text('FROM ANY'),
                //           value: FileType.any,
                //         ),
                //         DropdownMenuItem(
                //           child: const Text('CUSTOM FORMAT'),
                //           value: FileType.custom,
                //         ),
                //       ],
                //       onChanged: (value) => setState(() {
                //             _pickingType = value!;
                //             if (_pickingType != FileType.custom) {
                //               _controller.text = _extension = '';
                //             }
                //           })),
                // ),
                // ConstrainedBox(
                //   constraints: const BoxConstraints.tightFor(width: 100.0),
                //   child: _pickingType == FileType.custom
                //       ? TextFormField(
                //           maxLength: 15,
                //           autovalidateMode: AutovalidateMode.always,
                //           controller: _controller,
                //           decoration:
                //               InputDecoration(labelText: 'File extension'),
                //           keyboardType: TextInputType.text,
                //           textCapitalization: TextCapitalization.none,
                //         )
                //       : const SizedBox(),
                // ),
                // ConstrainedBox(
                //   constraints: const BoxConstraints.tightFor(width: 200.0),
                //   child: SwitchListTile.adaptive(
                //     title:
                //         Text('Pick multiple files', textAlign: TextAlign.right),
                //     onChanged: (bool value) =>
                //         setState(() => _multiPick = value),
                //     value: _multiPick,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => _openFileExplorer(),
                        child: const Text(
                          "Open Your File",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: () => _selectFolder(),
                      //   child: const Text("Pick folder"),
                      // ),
                      // ElevatedButton(
                      //   onPressed: () => _clearCachedFiles(),
                      //   child: const Text("Clear temporary files"),
                      // ),
                    ],
                  ),
                ),
                Builder(
                  builder: (BuildContext context) => _loadingPath
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: const CircularProgressIndicator(),
                        )
                      : _directoryPath != null
                          ? ListTile(
                              title: const Text('Directory path'),
                              subtitle: Text(_directoryPath!),
                            )
                          : _paths != null
                              ? Container(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  height:
                                      MediaQuery.of(context).size.height * 0.50,
                                  child: Scrollbar(
                                      child: ListView.separated(
                                    itemCount:
                                        _paths != null && _paths!.isNotEmpty
                                            ? _paths!.length
                                            : 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final bool isMultiPath =
                                          _paths != null && _paths!.isNotEmpty;
                                      final String name = 'File $index: ' +
                                          (isMultiPath
                                              ? _paths!
                                                  .map((e) => e.name)
                                                  .toList()[index]
                                              : _fileName ?? '...')!;
                                      final path = _paths!
                                          .map((e) => e.path)
                                          .toList()[index]
                                          .toString();

                                      return ListTile(
                                        title: Text(
                                          name,
                                        ),
                                        subtitle: Text(path),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(),
                                  )),
                                )
                              : const SizedBox(),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
