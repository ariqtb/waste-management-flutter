import 'package:flutter/material.dart';

class ResultPickup extends StatelessWidget {
  const ResultPickup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hasil Pengambilan Sampah',
      home: Scaffold(
        appBar: AppBar(title: const Text('data')),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Table(
            // border: TableBorder.all(width: 1, color: Colors.green),
            columnWidths: const <int, TableColumnWidth>{},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                Container(
                  height: 20,
                ),
                Container(
                  height: 20,
                  color: Colors.redAccent,
                ),
                Container(
                  height: 20,
                  color: Colors.yellowAccent,
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
