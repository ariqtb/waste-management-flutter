import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestFirestore extends StatefulWidget {
  const TestFirestore({super.key});

  @override
  State<TestFirestore> createState() => _TestFirestoreState();
}

class _TestFirestoreState extends State<TestFirestore> {
  var db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: db.collection('wasteIRT').snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error!'),
            );
          }

          var _data = snapshot.data!.docs;
          // _data.first.

          return ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(index.toString()),
                  ),
                  title: Text(_data[index].data().toString()),
                  subtitle: Row(
                    children: [
                      Text('Status: '),                                          
                    ],
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final wasteIRT = <String, dynamic>{
            "location": {"lat": "12", "long": "3", "address": "Bogor"},
            "id_user": "123",
            "date": "Kamis, 20 Feb 2023",
            "picked_up": false,
          };

          //   db
          //       .collection("waste")
          //       .doc("data2")
          //       .set(user)
          //       .then((doc) => print('DocumentSnapshot added with ID: '));
          // },
          db.collection("waste").add(wasteIRT).then((DocumentReference doc) =>
              print('DocumentSnapshot added with ID: ${doc.id}'));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
