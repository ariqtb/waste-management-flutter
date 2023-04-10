import 'package:flutter/material.dart';
import 'package:namer_app/pages/irt/homepage/homepage.dart';


class HomeIrt extends StatefulWidget {
    const HomeIrt({Key? key}) : super(key: key);

  @override
  State<HomeIrt> createState() => _HomeIrtState();
}

class _HomeIrtState extends State<HomeIrt> {
  @override
  Widget build(BuildContext context) {
    Widget page;
    page = Homepage();

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: page,
        bottomNavigationBar: 
        NavigationBarTheme(
          data: NavigationBarThemeData(
             indicatorColor: Colors.green[100],
            labelTextStyle: MaterialStateProperty.all(
             TextStyle(fontSize: 10, fontWeight: FontWeight.w500) 
            )
          ),
          child: NavigationBar(
            destinations: [
                 NavigationDestination(
                    icon: Icon(Icons.home), label: "Daftar Pickup"),
                NavigationDestination(
                    icon: Icon(Icons.history), label: "Riwayat"),
            ],
            selectedIndex: 1,
          ),
        ) 
      )
    );
  }
}