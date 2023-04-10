import 'package:flutter/material.dart';


class Homepage extends StatefulWidget {
    const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    Widget page;
    

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Container(),
      )
    );
  }
}