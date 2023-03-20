import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:namer_app/pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:namer_app/geolocator.dart';
import 'register.dart';
import 'home.dart';
import '../conn/constant.dart';

class LoginRepo {
  Future<http.Response> login(String email, String password) {
    return http.post(Uri.parse("uri"),
        headers: <String, String>{
          'Content-type': "application/json; charset=UTF-8"
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}));
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loading = false;
  bool logged = false;

  Future<void> loginFunc(String email, password) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      Response response = await http.post(
          Uri.parse("https://wastemanagement.tubagusariq.repl.co/login"),
          body: {
            'email': email,
            'password': password,
          });
      if (response.statusCode == 200) {
        await prefs.setString('email', email);
        setState(() {
          loading = false;
          logged = true;
        });
      } else {
        _showDialogError(response.statusCode.toString());
        print(response.body);
      }
    } catch (e) {
      return print(e.toString());
    }
  }

  Future<void> _showDialogError(String statusCode) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: AlertDialog(
              title: const Text('Gagal masuk'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                        'Silahkan cek kembali email dan password yang terdaftar'),
                    Text('Error Code: ${statusCode}'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'))
              ],
            ),
          );
        });
  }

  Future<void> _showDialogSuccess() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Berhasil masuk'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Waste App',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  height: 65,
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      await loginFunc(emailController.text.toString(),
                          passwordController.text.toString());
                      if (logged == true) {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => HomePage()));
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) {
                        //       return MyStatefulWidget();
                        //     },
                        //   ),
                        // );
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            ModalRoute.withName("/Login"));
                      }
                      _showDialogSuccess();
                    },
                  )),
              if (loading)
                Container(
                  padding: EdgeInsets.all(25),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                alignment: Alignment.center,
                child: Text('Belum punya akun?'),
              ),
              Container(
                height: 55,
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: OutlinedButton(
                  child: Text('Daftar'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterWidget()));
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) {
                    //       return RegisterWidget();
                    //     },
                    //   ),
                    // );
                  },
                ),
              ),
            ]),
          ),
        ));
  }
}

class DropdownRole extends StatefulWidget {
  const DropdownRole({
    super.key,
  });

  @override
  State<DropdownRole> createState() => _DropdownRoleState();
}

class _DropdownRoleState extends State<DropdownRole> {
  static const List<String> _role = [
    'Peran',
    'Produsen',
    'Distributor',
    'Pengelola'
  ];

  String dropdownVal = _role.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 40,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: DropdownButton(
        iconEnabledColor: Colors.green,
        value: dropdownVal,
        icon: const Icon(Icons.arrow_drop_down_circle_outlined),
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 2,
          color: Colors.black54,
        ),
        onChanged: (String? value) {
          setState(() {
            dropdownVal = value!;
          });
        },
        items: _role.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
