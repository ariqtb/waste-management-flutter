import 'package:flutter/material.dart';

class HomepagePetugas extends StatefulWidget {
  const HomepagePetugas({Key? key}) : super(key: key);

  @override
  State<HomepagePetugas> createState() => _HomepagePetugasState();
}

class _HomepagePetugasState extends State<HomepagePetugas> {
  Future<bool?> confirmDialog(context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Apakah anda ingin keluar?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Tidak')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    Navigator.pop(context, true);
                  },
                  child: Text('Ya')),
            ],
          ));

  @override
  Widget build(BuildContext context) {
    Widget page;

    return WillPopScope(
        onWillPop: () async {
          final pop = await confirmDialog(context);
          return pop ?? false;
        },
        child: Scaffold(
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
                indicatorColor: Colors.green[100],
                labelTextStyle: MaterialStateProperty.all(
                    TextStyle(fontSize: 10, fontWeight: FontWeight.w500))),
            child: NavigationBar(
              destinations: [
                NavigationDestination(
                    icon: Icon(Icons.home), label: "Foto"),
                NavigationDestination(
                    icon: Icon(Icons.history), label: "Riwayat"),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            elevation: 0.0,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: Text('Tambah'),
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
          body: Container(
            child: Column(
              children: [],
            ),
          ),
        ));
  }
}
