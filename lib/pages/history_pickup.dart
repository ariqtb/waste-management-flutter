import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/pages/detail_history_pickup.dart';
import '../utils/user_data_login.dart';
import 'package:intl/intl.dart';

class HistoryPickup extends StatefulWidget {
  const HistoryPickup({super.key});

  @override
  State<HistoryPickup> createState() => _HistoryPickupState();
}

class _HistoryPickupState extends State<HistoryPickup>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<dynamic> data = [];
  dynamic _selectedData;

  bool isLoading = false;
  String date = "";
  String time = "";
  String dateParse = "";
  String idDetail = "";
  dynamic history;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<dynamic> dataUser = await findUserData();
    String idUser = dataUser[0]['_id'].toString().toLowerCase();
    final response = await http.get(Uri.parse(
        'https://wastemanagement.tubagusariq.repl.co/waste/user/${idUser}'));
    if (response.statusCode == 200) {
      setState(() {
        isLoading = true;
        data = json.decode(response.body);
        data.sort((a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
      });
    } else {
      throw Exception("Failed to load data");
    }
  }

  void onDataClicked(dynamic history) {
    setState(() {
      _selectedData = history;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DetailHistoryPickup(history: history);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Riwayat'),
        ),
        body: Container(
          color: Colors.grey[100],
          padding: EdgeInsets.all(15),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 1,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "${data[index]['location'].length}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                  color: Colors.green),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Icon(Icons.location_on_outlined)
                          ],
                        ),
                        // SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${DateFormat('EEE, dd MMMM yy').format(DateTime.parse(data[index]['date']))}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                "${DateFormat('HH:mm').format(DateTime.parse(data[index]['date']))}"),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Telah diproses',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                onDataClicked(data[index]);
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) {
                                //       return DetailHistoryPickup(
                                //           history: data[index]);
                                //     },
                                //   ),
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  'Detail',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            // Text('data')
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
