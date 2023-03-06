import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTrash extends StatefulWidget {
  const AddTrash({super.key});
  @override
  State<AddTrash> createState() => AddTrashState();
}

class AddTrashState extends State<AddTrash> {
  bool addTrashStatus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade400,
        title: const Text('Pengambilan Sampah'),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        toolbarHeight: 70,
        toolbarOpacity: 0.8,
        titleSpacing: 20,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          // bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(50),
        )),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
              child: const Text(
                "*Tekan tombol untuk menandai lokasi sampah yang telah diambil",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  addTrashStatus = !addTrashStatus;
                });
              },
              child: Icon(Icons.check, color: Colors.white),
              style: addTrashStatus
                  ? ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(80),
                      backgroundColor: Colors.yellow[600],
                    )
                  : ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(80),
                      backgroundColor: Colors.greenAccent.shade400,
                    ),
            ),
            if (!addTrashStatus)
              Container(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Column(
                    children: [
                      Text(
                    "Simpan Lokasi",
                  ),
                  Icon(Icons.chevron_right_rounded, color: Colors.greenAccent.shade400)
                    ],
                  ),
                  // style: ElevatedButton.styleFrom(
                  //   padding: EdgeInsets.all(80),
                  //   backgroundColor: Colors.yellow[600],
                  // )
                ),
              ),
          ],
        ),
      ),
    );
  }
}
