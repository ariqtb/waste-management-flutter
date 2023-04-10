import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:namer_app/pages/history_pickup.dart';
import '../providers/waste_class.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class ImagePickerScreen extends StatefulWidget {
  final String id_waste;
  ImagePickerScreen({this.id_waste = ''});

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  String? type;
  File? _imageFile;
  double? weightValue;
  int selectedIndex = 0;
  late String idWaste;
  final picker = ImagePicker();
  bool isLoading = false;
  List<int> bytesPhoto = [];
  bool isDone = false;

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 20);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        List<int> bytesPhoto = _imageFile!.readAsBytesSync();
        // _imageFile = FlutterExifRotation.rotateImage(path: pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  List<AnorganikObj> anorganik = [];
  List<OrganikObj> organik = [];
  List<B3Obj> b3 = [];
  List<ResiduObj> residu = [];
  List<Map<String, dynamic>> photoList = [];

  List<String> page = ['Anorganik', 'Organik', 'B3', 'Residu'];

  void itung(File _imageFile) async {
    final sizeInBytes = await _imageFile.length();
    final sizeInKb = sizeInBytes / 1024;
    print('File size in bytes: $sizeInBytes');
    print('File size in KB: $sizeInKb');
  }

  Future<void> onGetData() async {
    if (type != null && _imageFile != null && weightValue != null) {
      if (photoList.length <= 3) {
        itung(_imageFile!);

        var stream =
            http.ByteStream(DelegatingStream.typed(_imageFile!.openRead()));
        var length = await _imageFile!.length();

        var uri = Uri.parse(
            'https://waste.tubagusariq.repl.co/waste/imagesave/${idWaste}');
        var request = http.MultipartRequest("PUT", uri);

        var multipartFile = http.MultipartFile('image', stream, length,
            filename: basename(_imageFile!.path));

        request.files.add(multipartFile);
        request.fields['typePhoto'] = type.toString();
        request.fields['weight'] = weightValue.toString();

        var response = await request.send();
        print(response.statusCode);
        var responseBytes = await response.stream.toBytes();
        var responseString = utf8.decode(responseBytes);
        print(responseString);

        photoList.add(
            {'typePhoto': type, 'image': _imageFile, 'weight': weightValue});

        if(photoList.length == 4) {
          setState(() {
            isDone = true;
          });
          return null;
        }

        setState(() {
          _imageFile = null;
          weightValue = null;
          print('photoList.length');
          selectedIndex++;
        });
      }
    }
  }

  Future<http.Response> uploadImages(
      List<File> images, List<int> weights) async {
    var uri = Uri.parse(
        'https://waste.tubagusariq.repl.co/waste/imagesave/$idWaste');

    var request = http.MultipartRequest('POST', uri);
    for (int i = 0; i < images.length; i++) {
      var stream = http.ByteStream(images[i].openRead());
      var length = await images[i].length();
      var multipartFile =
          http.MultipartFile('image', stream, length, filename: 'image$i.jpg');
      request.files.add(multipartFile);
      request.fields['weights[$i]'] = weights[i].toString();
    }

    var response = await request.send();
    return await http.Response.fromStream(response);
  }

  showModal(context) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200.0,
          color: Colors.white,
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Data sedang disimpan'),
              SizedBox(
                height: 20,
              ),
              CircularProgressIndicator()
            ]),
          ),
        );
      },
    );
  }

  Future<void> onPushData() async {}

  Future<void> onEachPage(int index) async {
    if (index >= 3) {
      print('dah selesai semua');
    }
  }

  @override
  void initState() {
    super.initState();
    idWaste = widget.id_waste;
    print(idWaste);
    onEachPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        type = 'anorganik';
        break;
      case 1:
        type = 'organik';
        break;
      case 2:
        type = 'b3';
        break;
      case 3:
        type = 'residu';
        break;
      default:
        throw UnimplementedError('No Page Anymore');
      // selectedIndex = 0;
      // break;
    }
    // type = 'anorganik';
    List<double> items = List<double>.generate(50, (index) => index + 5);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('${page[selectedIndex]}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 200,
                  )
                : Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 3),
                    ),
                    child: Text('Belum ada foto yang dipilih')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: getImageFromCamera,
              child: Text('Ambil Foto'),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              child: Text('Masukkan berat'),
            ),
            DropdownButtonHideUnderline(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: DropdownButton<double>(
                  value: weightValue,
                  items: items
                      .map((double value) => DropdownMenuItem<double>(
                            value: value,
                            child: Text('${value} Kg'),
                          ))
                      .toList(),
                  hint: Text('Select weight'),
                  onChanged: (double? value) {
                    setState(() {
                      weightValue = value;
                    });
                    print(weightValue);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            weightValue != null && selectedIndex < 4 && _imageFile != null
                ? ElevatedButton(
                    child: Text('Lanjut'),
                    onPressed: () async {
                      // if()
                      await onGetData();
                      if(isDone == true) {
                        Navigator.of(context).pop();
                      }
                    },
                  )
                : Container(),
            isLoading ? showModal(context) : Container(),
          ],
        ),
      ),
    );
  }
}
