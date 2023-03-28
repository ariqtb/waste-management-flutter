import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:namer_app/pages/history_pickup.dart';
import '../providers/waste_class.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

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
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        // if (_imageFile != null) {
        //   List<int> bytesPhoto = _imageFile.readAsBytesSync();
        // }
        // _imageFile = FlutterExifRotation.rotateImage(path: pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // void onNextClicked() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (BuildContext context) {
  //         return DetailHistoryPickup(history: history);
  //       },
  //     ),
  //   );
  // }

  List<AnorganikObj> anorganik = [];
  List<OrganikObj> organik = [];
  List<B3Obj> b3 = [];
  List<ResiduObj> residu = [];
  List<Map<String, dynamic>> photoList = [];

  List<String> page = ['Anorganik', 'Organik', 'B3', 'Residu'];

  Future<void> onGetData() async {
    if (type != null &&
        // _imageFile != null &&
        weightValue != null) {
      if (photoList.length <= 3) {
        photoList.add({
          'typePhoto': type,
          // 'image': base64Encode(_imageFile!.readAsBytesSync()),
          'weight': weightValue
        });
        if (selectedIndex < 3) {
          setState(() {
            // _imageFile = null;
            weightValue = null;
            print(photoList.length);
            selectedIndex++;
          });
        }
      } else {
        try {
          // print('${jsonEncode(photoList)}');
          // for (var photo in photoList) {
          // }
          showModal();
          String databody = jsonEncode(photoList);
          Response response = await put(
            Uri.parse(
                'https://wastemanagement.tubagusariq.repl.co/waste/imagesave/${idWaste}'),
            headers: {'Content-Type': 'application/json'},
            body: databody,
          );
           Navigator.of(context).pop();
           Navigator.of(context).pop();
          // var request = http.MultipartRequest(
          //     'PUT',
          //     Uri.parse(
          //         'https://wastemanagement.tubagusariq.repl.co/waste/image-save/${idWaste}'));

          // request.fields['type'] = type;
          // request.fields['weight'] = weightValue;
          // request.files.add(http.MultipartFile.fromBytes('image', bytesPhoto, filename: _imageFile));

          // Uri.parse(
          //     ),
          // headers: <String, String>{
          //   'Content-Type': 'application/octet-stream'
          // },
          // body: jsonEncode(photoList));

          print(response.body);
          print(response.statusCode);
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) {
        //       return HistoryPickup();
        //     },
        //   ),
        // );

          if (response.statusCode == 200) {}
        } catch (err) {
          return print(err.toString());
        }
        // selectedIndex++;
        // {
        //         'type': type,
        //         'image': _imageFile,
        //         'weight': weightValue
        //       }
        print(photoList.length);
      }
    }
  }

  showModal() {
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
    List<double> items =
        List<double>.generate(50, (index) => index + 1 / 2.toDouble());

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
            weightValue != null && selectedIndex < 4
                //  && _imageFile != null
                ? ElevatedButton(
                    child: Text('Lanjut'),
                    onPressed: () async {
                      // if()
                      await onGetData();
                    },
                  )
                : Container(),
                // isLoading ? showModal() : Container(),
          ],
        ),
      ),
    );
  }
}
