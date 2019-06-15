import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import '../constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

File file;

class Plant extends StatelessWidget {
  File file;
  bool isWeed = false;
  String date;
  String crop;
  String path;
  // double percentage;

  Plant(
      {@required this.file,
      this.isWeed = false,
      @required this.date,
      @required this.crop,
      this.path
      //  @required this.percentage,
      });

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
      height: 150,
      child: Stack(
        children: <Widget>[
          Image.file(
            file,
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: RaisedButton(
              shape: StadiumBorder(),
              child: Text(
                crop,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.black,
              onPressed: () {},
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              color: Colors.white30,
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    isWeed == null ? "Weed" : "Crop",
                    style: TextStyle(
                      color: isWeed == null ? Colors.red : Colors.black,
                      fontSize: 24,
                    ),
                  ),
                  Text(date)
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}

class _HomeState extends State<Home> {
  bool addFlag = false;
  bool addFlag2 = false;
  List<Plant> l = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              height: 150,
              color: primaryDark,
              padding: EdgeInsets.all(24),
              child: Text(
                "Weedy",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              )),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Contribute"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About us"),
            onTap: () {},
          ),
        ],
      )),
      appBar: AppBar(
        title: Text("Weedy"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, c) {
        double itemHeight = c.maxHeight / 8;
        if (itemHeight > 70) itemHeight = 70;
        double spacing = c.maxHeight / 24;

        return Stack(
          children: <Widget>[
            file == null
                ? Image.asset("assets/landingimg.png")
                : ListView.builder(
                    itemCount: l.length,
                    itemBuilder: (bc, i) {
                      return l[i];
                    },
                  ),
            buildAddButton(spacing, itemHeight)
          ],
        );
      }),
    );
  }

  void _choose() {
    // file = await ImagePicker.pickImage(source: ImageSource.camera);
    // setState(() async {
    //   file = await ;
    // });
    ImagePicker.pickImage(source: ImageSource.gallery).then((f) {
      setState(() {
        file = f;
      });
      _upload().then((_) {
        setState(() {
          l.add(
            Plant(
              file: file,
              date: DateTime.now().toString(),
              isWeed: isWeed,
              crop: "crop",
              // percentage: 12,
            ),
          );
        });
      });
    });
    print("Chosen");
  }

  bool isWeed;

  Future<Null> _upload() async {
    print("Hey there !");
    var request = new http.MultipartRequest(
      "POST",
      Uri.http(
        // "ec2-54-85-163-59.compute-1.amazonaws.com",
        "",
        "/",
      ),
    );
    request.fields['class'] = 'brinjal';
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      file.path,
      contentType: MediaType('image', 'jpg'),
    ));
    request.send().then((response) async {
      print("Yo");
      print("Status code: ${await response.stream.bytesToString()}");
      if (response.statusCode == 200) {
        print("Uploaded!");
      }
      isWeed = (await response.stream.bytesToString()).contains("weed");
      Map<String, dynamic> user = jsonDecode(response.toString());
      print(user);
    });
    print("Hey there !");
    // if (file == null) return;
    // String base64Image = base64Encode(file.readAsBytesSync());
    // String fileName = file.path.split("/").last;

    // http.post("Ashwinddd03030.pythonanywhere.com/asdf").then((res) {
    //   print(res.statusCode);
    // }).catchError((err) {
    //   print(err);
    // });
    return;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<File> _cropImage(File imageFile) async {
    print("cropImage()");
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
    );
    print("cropImage()1");
    print(croppedFile.path);
    return croppedFile;
  }

  Widget buildAddButton(double spacing, double itemHeight) {
    double s = spacing / 2;
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(right: spacing / 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedOpacity(
              duration: Duration(milliseconds: 150),
              opacity: addFlag ? 1.0 : 0.0,
              child: GestureDetector(
                onTap: () {
                  // _upload();
                  _choose();
                },
                child: addFlag2
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: secondaryColor,
                        ),
                        padding: EdgeInsets.all(s),
                        margin: EdgeInsets.only(bottom: spacing / 2),
                        child: Image.asset(
                          "assets/eggplant.png",
                          height: 24,
                        ),
                      )
                    : Container(),
              ),
            ),
            SizedBox(width: s),
            AnimatedOpacity(
              duration: Duration(milliseconds: 100),
              opacity: addFlag ? 1.0 : 0.0,
              child: GestureDetector(
                onTap: () {},
                child: addFlag2
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: secondaryColor,
                        ),
                        padding: EdgeInsets.all(s),
                        margin: EdgeInsets.only(bottom: spacing / 2),
                        child: Image.asset(
                          "assets/lf.png",
                          height: 24,
                        ),
                      )
                    : Container(),
              ),
            ),
            SizedBox(width: s),
            Container(
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(100),
              ),
              padding: EdgeInsets.all(s),
              margin: EdgeInsets.only(bottom: s),
              child: GestureDetector(
                onTap: () async {
                  if (!addFlag) {
                    setState(() {
                      addFlag2 = true;
                      addFlag = true;
                    });
                  } else {
                    setState(() {
                      addFlag = false;
                    });
                    Future.delayed(Duration(milliseconds: 150),
                        () => setState(() => addFlag2 = false));
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(width: spacing / 4),
                    Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: spacing / 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//senthilsenthil0028@gmail.com
//9865652242
