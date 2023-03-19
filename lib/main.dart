import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'conn/conn_api.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   void isConnected = await connAPI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Sample App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        primaryColor: Colors.amber,
      ),
      home: Scaffold(
        body: MyStatefulWidget(),
      ),
    );
  }
}
