import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:namer_app/geolocator.dart';
import 'package:namer_app/providers/waste_data.dart';
import '../components/show_pickup.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomePageState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.green,
        ),
        home: Dashboard(),
      ),
    );
  }
}

class HomePageState extends ChangeNotifier {
  @override
  var current = [1, 2, 3];
  void getNext() {
    notifyListeners();
  }
}

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = ShowPickup();
        break;
      case 1:
        page = GenerateLocator();
        break;
      default:
        throw UnimplementedError('No widget selected');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengambilan Sampah'),
      ),
      body: page,
      bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(
                icon: Icon(Icons.home), label: "Daftar Pickup"),
            NavigationDestination(icon: Icon(Icons.home), label: "Riwayat"),
          ],
          onDestinationSelected: (value) {
            setState(() {
              selectedIndex = value;
            });
          }),
    );
  }
}

class PickSchedule extends StatefulWidget {
  const PickSchedule({super.key});

  @override
  State<PickSchedule> createState() => _PickScheduleState();
}

class _PickScheduleState extends State<PickSchedule> {
  bool generateData = true;

  Future<void> _fetchData() async {
  bool generateData = true;
  List _dataIRT = [];

  final response = await http
      .get(Uri.parse('https://waste-management.leeseona25.repl.co/waste/IRT'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    data.map((e) => _dataIRT.add(e));
    return print(_dataIRT);
    // return data;
    // return data.map((e) => (print(e['_id']))).toList();
  } else {
    throw Exception('Failed Fetching');
  }
}

  @override
  Widget build(BuildContext context) {
    // final wasteData = Provider.of
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'Pengambilan sampah terdekat',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(
            height: 18,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen[100],
                      ),
                      child: ListTile(
                        title: Text('_dataIRT'),
                        subtitle: Text('data subtitle'),
                      ),
                      onPressed: () {},
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          // generateData ? 
          ElevatedButton(
            onPressed: () async {
              _fetchData();
              generateData = !generateData;
            }, 
          child: Text('Generate data')
          ),
          
        ],
      ),
    );
    // return Column(
    //   children: [
    //     Container(
    //       // color: Colors.red,
    //       padding: EdgeInsets.all(10),
    //       child: Row(
    //         children: [
    //           Center(
    //             child: ElevatedButton(
    //               child: Text('data'),
    //               onPressed: () {},
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ],
    // );

    // return ListTile(
    //   title: Text('data'),
    //   subtitle: Text('data subtitle'),
    // );

    // return DataTable(
    //   columns: [
    //     DataColumn(
    //         label: Expanded(
    //             child: const Text(
    //       'Nama',
    //       style: TextStyle(fontStyle: FontStyle.italic),
    //     ))),
    //     DataColumn(
    //         label: Expanded(
    //             child: const Text(
    //       'Age',
    //       style: TextStyle(fontStyle: FontStyle.italic),
    //     )))
    //   ],
    //   rows: [
    //     DataRow(cells: [
    //       DataCell(Text('Sarah')),
    //       DataCell(Text('19')),
    //     ]),
    //     DataRow(cells: [
    //       DataCell(Text('Janine')),
    //       DataCell(Text('43')),
    //     ]),
    //   ],
    // );

    // return Center(
    //   child: Container(
    //     alignment: Alignment.center,
    //     padding: EdgeInsets.all(15),
    //     child: Column(
    //       children: [
    //         Table(
    //           border: TableBorder.all(),
    //           // columnWidths: const <int, TableColumnWidth>{
    //           //   0: FixedColumnWidth(50),
    //           //   1: FlexColumnWidth(),
    //           //   2: FixedColumnWidth(64),
    //           // },
    //           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    //           children: <TableRow>[
    //             TableRow(
    //               children: <Widget>[
    //                 Container(
    //                   alignment: Alignment.center,
    //                   // padding: EdgeInsets.all(5),
    //                   height: 40,
    //                   color: Colors.green,
    //                   child: const Text('data'),
    //                 ),
    //                 TableCell(
    //                   verticalAlignment: TableCellVerticalAlignment.top,
    //                   child: Container(
    //                     color: Colors.red,
    //                     child: const Text('data2'),
    //                   ),
    //                 ),
    //                 Container(
    //                   color: Colors.blue,
    //                   child: const Text('data3'),
    //                 ),
    //               ],
    //             ),
    //             TableRow(
    //               decoration: const BoxDecoration(
    //                 color: Colors.grey,
    //               ),
    //               children: <Widget>[
    //                 Container(
    //                   height: 64,
    //                   width: 128,
    //                   color: Colors.purple,
    //                   child: const Text('data'),
    //                 ),
    //                 Container(
    //                   height: 32,
    //                   color: Colors.yellow,
    //                 ),
    //                 Center(
    //                   child: Container(
    //                     height: 32,
    //                     width: 32,
    //                     color: Colors.orange,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
