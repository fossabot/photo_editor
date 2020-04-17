import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import 'modules/bottomBar.dart';
import 'modules/draw_screen.dart';

TextEditingController canvasHeightController = TextEditingController();
TextEditingController canvasWidthController = TextEditingController();

var canvasHeight = 800;
var canvasWidth = 1000;

var canvasColor = Colors.white;
var widgetCount = 0;
List multiwidget = [];
Color currentcolor = Colors.white;

class PhotoEditor extends StatefulWidget {
  @override
  _PhotoEditorState createState() => _PhotoEditorState();
}

class _PhotoEditorState extends State<PhotoEditor> {
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  double strokeWidth = 3.0;
  double opacity = 1.0;
  bool drawVisible = false;

  final scaf = GlobalKey<ScaffoldState>();
  var openbottomsheet = false;
  List aligment = [];
  File _imageFile;
  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = new GlobalKey();
  File _image;
  ScreenshotController screenshotController = ScreenshotController();
  Timer timeprediction;
  void timers() {
    Timer.periodic(Duration(milliseconds: 10), (tim) {
      setState(() {});
      timeprediction = tim;
    });
  }

  @override
  void dispose() {
    timeprediction.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    timers();
    multiwidget.clear();
    widgetCount = 0;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        key: scaf,
        appBar: new AppBar(
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.add_box),
                onPressed: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: new Text("Select Height Width"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  setState(() {
                                    canvasHeight =
                                        int.parse(canvasHeightController.text);
                                    canvasWidth =
                                        int.parse(canvasWidthController.text);
                                  });
                                  canvasHeightController.clear();
                                  canvasWidthController.clear();
                                  Navigator.pop(context);
                                },
                                child: new Text("Done"))
                          ],
                          content: new SingleChildScrollView(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text("Define Height"),
                                new SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                    controller: canvasHeightController,
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    decoration: InputDecoration(
                                        hintText: 'Height',
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        border: OutlineInputBorder())),
                                new SizedBox(
                                  height: 10,
                                ),
                                new Text("Define Width"),
                                new SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                    controller: canvasWidthController,
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    decoration: InputDecoration(
                                        hintText: 'Width',
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        border: OutlineInputBorder())),
                              ],
                            ),
                          ),
                        );
                      });
                }),
            new IconButton(
                icon: Icon(Icons.undo),
                onPressed: () {
                  setState(() {});
                }),
            new IconButton(
                icon: Icon(Icons.camera),
                onPressed: () {
                  bottomsheets();
                }),
            new FlatButton(
                child: new Text("Done"),
                textColor: Colors.white,
                onPressed: () {
                  _imageFile = null;
                  screenshotController
                      .capture(
                          delay: Duration(milliseconds: 500), pixelRatio: 1.5)
                      .then((File image) async {
                    //print("Capture Done");
                    setState(() {
                      _imageFile = image;
                    });
                    final paths = await getExternalStorageDirectory();
                    image.copy(paths.path +
                        '/' +
                        DateTime.now().millisecondsSinceEpoch.toString() +
                        '.png');
                    Navigator.pop(context, image);
                  }).catchError((onError) {
                    print(onError);
                  });
                }),
          ],
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Screenshot(
            controller: screenshotController,
            child: Container(
              // margin: EdgeInsets.all(4),
              color: canvasColor,
              width: canvasWidth.toDouble(),
              height: canvasHeight.toDouble(),
              child: RepaintBoundary(
                  key: globalKey,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: Draw(
                          opacity: opacity,
                          selectedColor: pickerColor,
                          strokeWidth: strokeWidth,
                          isActive: drawVisible,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
        bottomNavigationBar: openbottomsheet
            ? new Container()
            : Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [BoxShadow(blurRadius: 10.9)]),
                height: 70,
                child: new ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    BottomBarContainer(
                      colors: Colors.black,
                      icons: Icons.brush,
                      ontap: () {
                        // raise the [showDialog] widget
                        setState(() {
                          drawVisible = !drawVisible;
                        });
                      },
                      title: 'Brush',
                      active: drawVisible,
                    ),
                    BottomBarContainer(
                      icons: Icons.text_fields,
                      ontap: () {
                        // TODO: text editor implementation
                      },
                      title: 'Text',
                    ),
                    BottomBarContainer(
                      icons: Icons.crop_square,
                      ontap: () {
                        multiwidget.clear();
                        widgetCount = 0;
                      },
                      title: 'Eraser',
                    ),
                    BottomBarContainer(
                      icons: Icons.photo,
                      ontap: () {
                        // TODO: something on click
                      },
                      title: 'Filter',
                    ),
                    BottomBarContainer(
                      icons: Icons.tag_faces,
                      ontap: () {
                        // TODO: Build emojis
                      },
                      title: 'Emoji',
                    ),
                  ],
                ),
              ));
  }

  void bottomsheets() {
    openbottomsheet = true;
    setState(() {});
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return new Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 10.9, color: Colors.grey[400])
          ]),
          height: 170,
          child: new Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: new Text("Select Image Options"),
              ),
              Divider(
                height: 1,
              ),
              new Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.photo_library),
                                  onPressed: () async {
                                    var image = await ImagePicker.pickImage(
                                        source: ImageSource.gallery);
                                    var decodedImage =
                                        await decodeImageFromList(
                                            image.readAsBytesSync());

                                    setState(() {
                                      canvasHeight = decodedImage.height;
                                      canvasWidth = decodedImage.width;
                                      _image = image;
                                    });
                                    Navigator.pop(context);
                                  }),
                              SizedBox(width: 10),
                              Text("Open Gallery")
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 24),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.camera_alt),
                                onPressed: () async {
                                  var image = await ImagePicker.pickImage(
                                      source: ImageSource.camera);
                                  var decodedImage = await decodeImageFromList(
                                      image.readAsBytesSync());

                                  setState(() {
                                    canvasHeight = decodedImage.height;
                                    canvasWidth = decodedImage.width;
                                    _image = image;
                                  });
                                  Navigator.pop(context);
                                }),
                            SizedBox(width: 10),
                            Text("Open Camera")
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
    future.then((void value) => _closeModal(value));
  }

  void _closeModal(void value) {
    openbottomsheet = false;
    setState(() {});
  }
}
