import 'package:flutter/material.dart';
import 'package:namer_app/geolocator.dart';

class RecapImage extends StatelessWidget {
  final List<Map<String, dynamic>> photoList;
  const RecapImage({super.key, required this.photoList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rekap Foto'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: photoList.length,
          itemBuilder: (BuildContext context, int index) {
            final image = photoList[0]['filename'].path;
            return Image.asset(image);
          },
        ),
      ),
    );
  }
}

class SubmitPage extends StatelessWidget {
  const SubmitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text(
          'Selesai',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(80),
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return GenerateLocator();
                }));
              },
              child: Text(''),
            )),
      ],
    ));
  }
}
