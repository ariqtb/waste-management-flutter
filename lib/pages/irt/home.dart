import 'package:flutter/material.dart';
import 'package:namer_app/pages/irt/homepage/homepage.dart';

class HomeIrt extends StatefulWidget {
  const HomeIrt({Key? key}) : super(key: key);

  @override
  State<HomeIrt> createState() => _HomeIrtState();
}

class _HomeIrtState extends State<HomeIrt> {
  var selectedIndex = 0;

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
    switch (selectedIndex) {
      case 0:
        page = Homepage();
        break;
      case 1:
        page = Container(
          alignment: Alignment.center,
          child: Text('Riwayat'),
        );
        break;
      default:
        throw UnimplementedError('No widget selected');
    }

    return WillPopScope(
        onWillPop: () async {
          final pop = await confirmDialog(context);
          return pop ?? false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Halaman Utama'),
            automaticallyImplyLeading: false,
          ),
          body: page,
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
                indicatorColor: Colors.green[100],
                labelTextStyle: MaterialStateProperty.all(
                    TextStyle(fontSize: 10, fontWeight: FontWeight.w500))),
            child: NavigationBar(
                destinations: [
                  NavigationDestination(
                      icon: Icon(Icons.home), label: "Halaman Utama"),
                  NavigationDestination(
                      icon: Icon(Icons.history), label: "Riwayat"),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                }),
          ),
        ));
  }
}
