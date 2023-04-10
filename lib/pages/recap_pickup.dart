import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecapPickup extends StatefulWidget {
  // final Map<dynamic, String> waste;

  // RecapPickup(this.waste);
  const RecapPickup({super.key});

  @override
  State<RecapPickup> createState() => _RecapPickupState();
}

class _RecapPickupState extends State<RecapPickup> {
  Map<String, dynamic>? datas;
  List<Map<String, dynamic>>? wasteData;
  List<Map<String, dynamic>>? location;
  

  getRecap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? getdata = prefs.getString('waste');
    setState(() {
      datas = jsonDecode(getdata!);
    });
    print(datas.runtimeType);

    wasteData = [datas!].toList();
    
    // print(wasteData![0]['location']);
    setState(() {
      location = wasteData![0]['location'];
    });
    
    print(location);
    print(location.runtimeType);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecap();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {'Name': 'Alice', 'Age': 25, 'Role': 'Developer'},
      {'Name': 'Bob', 'Age': 30, 'Role': 'Manager'},
      {'Name': 'Charlie', 'Age': 35, 'Role': 'Designer'},
    ];

    // print(waste);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Rekap Pengambilan Sampah'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            // Text('data'),
            Container(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Nama')),
                  DataColumn(label: Text('Waktu')),
                  DataColumn(label: Text('Alamat')),
                ],
                rows: data.map((e) {
                  return DataRow(cells: [
                    DataCell(Text(e['Name'])),
                    DataCell(Text(e['Age'].toString())),
                    DataCell(Text(e['Role'])),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
        // child: Table(
        //   border: TableBorder.all(color: Colors.black),
        //   columnWidths: {
        //     0: FixedColumnWidth(50.0),
        //     1: FlexColumnWidth(),
        //     2: FixedColumnWidth(50.0),
        //   },
        //   children: data.map((row) {
        //     return TableRow(
        //       children: row.map((cell) {
        //         return Text(cell);
        //       }).toList(),
        //     );
        //   }).toList(),
        // ),
      ),
    );
  }
}
