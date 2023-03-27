import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/pages/detail_history_pickup.dart';
import '../utils/user_data_login.dart';
import 'package:intl/intl.dart';
import '../providers/waste_class.dart';
import 'image_sorting.dart';

class HistoryPickup extends StatefulWidget {
  // final String id_waste;
  // HistoryPickup({required this.id_waste});

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
  bool isEmptyData = false;
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
      // if (data.length == 0) {
      //   setState(() {
      //     isEmptyData = true;
      //     isLoading = true;
      //   });
      // }

      setState(() {
        isLoading = true;
        data = json.decode(response.body);
        // data.map((json) => Waste.fromJson(json)).toList();
        // print(data);
        data.sort((a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
      });
    } else {
      throw Exception("Failed to load data");
    }
  }

  void onDetailClicked(dynamic history) {
    if (mounted) {
      setState(() {
        _selectedData = history;
      });
    }
    ;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DetailHistoryPickup(history: history);
        },
      ),
    );
  }

  void onFotoClicked(String id_waste) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ( context) {
          return ImagePickerScreen(id_waste : id_waste);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
      // String? id_waste;


    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Riwayat'),
        ),
        body: !isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                color: Colors.grey[100],
                padding: EdgeInsets.all(15),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 1,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Selesai',
                                    style: TextStyle(fontSize: 12),
                                  ),
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
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      "${DateFormat('HH:mm').format(DateTime.parse(data[index]['date']))}"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                    decoration: data[index]['recorded']
                                        ? BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.green[100])
                                        : BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.redAccent[100]),
                                    child: data[index]['recorded']
                                        ? Text(
                                            'Telah dipilah',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black87),
                                          )
                                        : Text(
                                            'Belum dipilah',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black87),
                                          ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      onDetailClicked(data[index]);
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
                                  data[index]['recorded']
                                      ? Container()
                                      : ElevatedButton(
                                          onPressed: () {
                                            onFotoClicked(data[index]['_id']);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  side: BorderSide(
                                                      color: Colors.green))),
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              'Foto',
                                              style: TextStyle(
                                                  color: Colors.green),
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
