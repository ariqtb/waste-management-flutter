import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:namer_app/pages/home.dart';
import 'components/result_pickup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerateLocator extends StatefulWidget {
  const GenerateLocator({
    super.key,
  });

  @override
  State<GenerateLocator> createState() => _GenerateLocatorState();
}

class _GenerateLocatorState extends State<GenerateLocator> {
  String location = '(Belum Mendapatkan kode lokasi, Silahkan tekan button)';
  String address = 'Mencari lokasi...';
  String info = 'Tekan tombol untuk menandai pengambilan sampah';

  bool addTrashStatus = false;

  late String lat;
  late String long;
  bool loading = false;
//getLongLAT
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //location service not enabled, don't continue
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    //permission denied forever
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permission denied forever, we cannot access',
      );
    }
    //continue accessing the position of device
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks[0].country);
    Placemark place = placemarks[0];
    setState(() {
      address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }
  
  Future<void> wastePOST(String currentDate, latitude, longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    try {
      Map<String, dynamic> theData = {
        'pengepul': email,
        'location': {
          'lat': latitude,
          'long': longitude,
        },
        'date': currentDate,
      };
      String bodyParse = jsonEncode(theData);
      Response response = await http.post(
          Uri.parse('https://wastemanagement.tubagusariq.repl.co/waste/add'),
          headers: {'Content-Type': 'application/json'},
          body: bodyParse);
      if (response.statusCode == 201) {
        print('success');
        print(response.body);
      } else {
        print(response.body);
        print(response.statusCode);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _showDialogSuccess() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Berhasil disimpan, lanjut pengambilan'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'))
            ],
          );
        });
  }

  late String currentDate;
  late String latitude;
  late String longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengambilan Sampah"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              info,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(height: 10),
            loading
                ? Text(
                    address,
                    textAlign: TextAlign.center,
                  )
                : const SizedBox(
                    height: 20,
                  ),
            SizedBox(
              height: 20,
            ),
            loading
                ? const Center(child: CircularProgressIndicator())
                : Center(),
            addTrashStatus
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        iconSize: 100,
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return ResultPickup();
                              },
                            ),
                          );
                        },
                      ),
                      IconButton(
                        iconSize: 100,
                        icon: const Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          await wastePOST(currentDate, latitude, longitude);
                          await _showDialogSuccess();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return HomePage();
                              },
                            ),
                          );
                        },
                      )
                    ],
                  )
                : Container(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(80),
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: !addTrashStatus
                          ? () async {
                              setState(() {
                                loading = true;
                              });
                              DateTime now = DateTime.now();
                              currentDate = now.toString();

                              Position position =
                                  await _getGeoLocationPosition();
                              setState(() {
                                latitude = position.latitude.toString();
                                longitude = position.longitude.toString();
                                loading = false;
                                addTrashStatus = !addTrashStatus;
                                // print(addTrashStatus);
                                location =
                                    '${position.latitude}, ${position.longitude}';
                                getAddressFromLongLat(position);
                                info = 'Sampah berhasil diproses';
                              });
                            }
                          : () {},
                      child: addTrashStatus
                          ? const Text('Sudah ditandai')
                          : const Text('Tandai tempat'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
