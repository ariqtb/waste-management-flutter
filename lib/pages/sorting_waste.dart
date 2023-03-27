// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';

// class OrganikRecord extends StatefulWidget {
//   @override
//   State<OrganikRecord> createState() => OrganikRecordState();
// }

// class OrganikRecordState extends State<OrganikRecord> {
//   late List<CameraDescription> cameras;
//   late CameraController cameraController;

//   @override
//   void initState() {
//     startCamera();
//     super.initState();
//   }

//   void startCamera() async {
//     cameras = await availableCameras();

//     cameraController =
//         CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);

//     try {
//       await cameraController.initialize().then((value) {
//         if (!mounted) {
//           return;
//         }
//         setState(() {});
//       });
//     } catch (err) {
//       print(err);
//     }
//   }

//   void uploadImage(File image) async {
//     var request = http.MultipartRequest("POST", Uri.parse('https://wastemanagement.tubagusariq.repl.co/users'));
//     request.files.add(await http.MultipartFile.fromPath('image', image.path));
//     var response = await request.send();
//     if(response.statusCode == 200) {
//       print('Image Uploaded!');
//     } else {
//       print('Image upload failed');
//     }
//   }

//   @override
//   void dispose() {
//     cameraController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (cameraController.value.isInitialized) {
//       return Scaffold(
//         body: Stack(
//           children: [
//             CameraPreview(cameraController),
//             GestureDetector(
//               onTap: () {
//                 cameraController.takePicture().then((XFile? file){
//                   if(mounted) {
//                     if(file != null) {
//                       print("Picture saved to ${file.path}");
//                     }
//                   }
//                 });
//               },
//               child: cameraButton(),
//             ),
//           ],
//         ),
//       );
//     } else {
//       return SizedBox();
//     }
//   }

//   Widget cameraButton() {
//     return Align(
//             alignment: Alignment.center,
//             child: Container(
//               margin: EdgeInsets.fromLTRB(0,550,0,0),
//               height: 100,
//               width: 100,
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black38,
//                       offset: Offset(2, 2),
//                       blurRadius: 15,
//                     )
//                   ]),
//               child: Center(
//                 child: Icon(
//                   Icons.camera_alt_rounded,
//                   size: 35,
//                   color: Colors.green,
//                 ),
//               ),
//             ),
//           );
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       title: Text('Pemilahan Sampah'),
//   //     ),
//   //     body: Container(
//   //       child: Text('Organik Session'),
//   //     ),
//   //   );
//   // }
// }

// import 'dart:async';
// import 'dart:io';
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

// class OrganikRecord extends StatefulWidget {
//   @override
//   State<OrganikRecord> createState() => OrganikRecordState();
// }

// class OrganikRecordState extends State<OrganikRecord> {
//   CameraController? _cameraController;
//   List<CameraDescription> _cameras = [];
//   bool _isReady = false;
//   String? _imagePath;
//   late List<XFile> photos;
//   List<int> weights = [0,0,0,0];
//   int currentIndex = 0;

//   Future<void> _initializeCamera() async {
//     _cameras = await availableCameras();
//     if (_cameras.length > 0) {
//       _cameraController = CameraController(_cameras[0], ResolutionPreset.low, enableAudio: false);
//       await _cameraController!.initialize();
//       setState(() {
//         _isReady = true;
//       });
//     }
//   }

//   Future<void> _takePicture() async {
//     final Directory extDir = await getApplicationDocumentsDirectory();
//     final String dirPath = '${extDir.path}/Pictures/flutter_test';
//     await Directory(dirPath).create(recursive: true);
//     final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//     final String filePath = '$dirPath/$timestamp.jpg';

//     if (_cameraController != null && _cameraController!.value.isInitialized) {
//       XFile photo = await _cameraController!.takePicture();
//       final rotatedPhoto = await FlutterExifRotation.rotateImage(path: photo.path);
//       setState(() {
//         photos[currentIndex] = XFile(rotatedPhoto.path);
//         _imagePath = filePath;
//       });

//       File(photo.path).copy(filePath);
//     }
//   }

//   void setWeight(int weight) {
//     setState(() {
//       weights[currentIndex] = weight;
//     });
//   }

//   void nextPhoto() {
//     if(currentIndex < 3) {
//       setState(() {
//         currentIndex++;
//       });
//     }
//   }

//   Future<void> submitData() async {
    
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Camera Page'),
//       ),
//       body: Container(
//         child: _isReady
//             ? Column(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: Container(
//                       child: _imagePath == null
//                           ? Center(
//                               child: Container(
//                                 height: 450,
//                                 // aspectRatio: _cameraController!.value.aspectRatio,
//                                 child: CameraPreview(_cameraController!),
//                               ),
//                             )
//                           : Transform.rotate(
//                             angle: math.pi / 2,
//                             child: Image.file(File(_imagePath!), fit: BoxFit.contain,)),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Container(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.camera_alt),
//                             onPressed: () {
//                               _takePicture();
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.check),
//                             onPressed: () {
//                               // Upload the image to the API here
//                               // You can use the _imagePath variable to access the image file
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             : Center(
//                 child: CircularProgressIndicator(),
//               ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

class OrganikRecord extends StatefulWidget {
  @override
  _OrganikRecordState createState() => _OrganikRecordState();
}

class _OrganikRecordState extends State<OrganikRecord> {
  late CameraController _cameraController;
  late List<XFile> _photos;
  List<String?> _weights = [null, null, null, null];
  int _currentPhotoIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(firstCamera, ResolutionPreset.medium);
    await _cameraController.initialize();

    setState(() {});
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final photo = await _cameraController.takePicture();
    final rotatedPhoto = await FlutterExifRotation.rotateImage(path: photo.path);
    setState(() {
      _photos[_currentPhotoIndex] = XFile(rotatedPhoto.path);
    });
  }

 void _setWeight(int index, double? value) {
    setState(() {
      _weights[index] = value?.toStringAsFixed(1);
    });
  }


  void _nextPhoto() {
    if (_currentPhotoIndex < 3) {
      setState(() {
        _currentPhotoIndex++;
      });
    }
  }

  Future<void> _submitData() async {
    // Upload the photos and weights to the API here
    // Use _photos and _weights to access the data
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Take Photos'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           for (var i = 0; i < 4; i++)
          Column(
            children: [
              Text(
                'Weight ${i + 1}',
                style: TextStyle(fontSize: 20),
              ),
              Slider(
                min: 0,
                max: 100,
                divisions: 100,
                label: _weights[i] ?? '0',
                value: _weights[i] != null ? double.parse(_weights[i]!) : 0,
                onChanged: (double value) {
                  _setWeight(i, value);
                },
              ),
            ],
          ),
        ElevatedButton(
          onPressed: () {
            // Save _weights to API
            print(_weights);
          },
          child: Text('Save Weights'),
        ),
        ],
      ),
    );
  }
}
