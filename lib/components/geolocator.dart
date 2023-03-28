import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class Location {
  String lat;
  String long;
  String time;

  Location({required this.lat, required this.long, required this.time});

  Map<String, dynamic> location() {
    return {"lat": lat, "long": long, "time": time};
  }
}
List<Map<String, dynamic>> waste = [];
List<Map<String, dynamic>> location = [];

Future<void> addWaste(String currentDate, latitude, longitude) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');
  try {
    location.add({"lat": latitude, "long": longitude, "time": currentDate});
    print(location);
  } catch (e) {
    throw Exception(e);
  }
}

Future findUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');

  try {
    Response response = await http.get(Uri.parse(
        'https://wastemanagement.tubagusariq.repl.co/users/${email}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return "${response.statusCode}";
    }
  } catch (err) {
    return "err ${err}";
  }
}

Future wastePOST(String currentDate) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // String? email = prefs.getString('email');
  List<dynamic> data = await findUserData();
  String id_user = data[0]['_id'].toString().toLowerCase();
  // return print(id_user);
  try {
    Map<String, dynamic> waste = {
      'pengepul': id_user,
      'date': currentDate,
      'location': location,
      'recorded': false
    };

    String bodyParse = jsonEncode(waste);
    await prefs.setString('waste', bodyParse);
    // return print(bodyParse);
    Response response = await http.post(
        Uri.parse('https://wastemanagement.tubagusariq.repl.co/waste/add'),
        headers: {'Content-Type': 'application/json'},
        body: bodyParse);
    if (response.statusCode == 201) {
      location.clear();
      print(waste);
      // print('success');
      // print(response.body);
    } else {
      print(response.body);
      print(response.statusCode);
    }
  } catch (e) {
    throw Exception(e);
  }
}
