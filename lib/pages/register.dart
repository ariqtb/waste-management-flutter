import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:namer_app/pages/login.dart';
import 'package:namer_app/main.dart';
import 'package:email_validator/email_validator.dart';

class RegisterRepo {
  Future<http.Response> login(String email, String password) {
    return http.post(Uri.parse("uri"),
        headers: <String, String>{
          'Content-type': "application/json; charset=UTF-8"
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}));
  }
}

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({
    super.key,
  });

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final password2Controller = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final handphoneController = TextEditingController();
  final roleController = TextEditingController();
  List<String> role = ['irt', 'pengepul', 'petugas'];
  String? roleSelected;

  bool loading = false;
  bool logged = false;
  bool submitted = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    password2Controller.dispose();

    super.dispose();
  }

  String? get _errorText {
    final email = emailController.value.text;
    final password = passwordController.value.text;
    final password2 = password2Controller.value.text;
    final name = nameController.value.text;
    final address = addressController.value.text;
    final handphone = handphoneController.value.text;
    final role = roleController.value.text;

    if (email.isEmpty || password.isEmpty || password2.isEmpty) {
      return 'Can\'t be empty';
    }
    return null;
  }

  Future<void> registFunc() async {
    // return print(emailController.text.trim());
    final bool isValidEmail =
        EmailValidator.validate(emailController.text.trim());
    if (!isValidEmail) {
      return print('Masukkan email yang benar');
    }
    if (passwordController.text.trim() != password2Controller.text.trim()) {
      return _showDialogError('Password tidak sama!');
    } else {
      try {
        Response response = await post(
            Uri.parse("https://wastemanagement.tubagusariq.repl.co/register"),
            body: {
              'name': nameController.text.trim(),
              'address': addressController.text.trim(),
              'email': emailController.text.trim(),
              'password': passwordController.text.trim(),
              'verPassword': password2Controller.text.trim(),
              'handphone': handphoneController.text.trim(),
              'role': 'pengepul',
            });
        if (response.statusCode == 200) {
          print(response.body);
          print(response.statusCode);
          // return _showDialogSuccess();
        } else {
          return _showDialogError(response.body.toString());
        }
      } catch (e) {
        return print(e.toString());
      }
    }
  }

  Future<void> _showDialogSuccess() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Berhasil masuk'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Silakan login kembali'),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return MyApp();
                        },
                      ),
                    );
                  },
                  child: Text('Okay'))
            ],
          );
        });
  }

  Future<void> _showDialogError(String status) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Gagal masuk'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  // Text(
                  //     'Silahkan cek kembali email dan password yang terdaftar'),
                  Text(status),
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
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
          body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
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
                    'Daftar',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nama',
                    // errorText: _errorText,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    // errorText: _errorText,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    // errorText: _errorText,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  obscureText: true,
                  controller: password2Controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Konfirmasi Password',
                    // errorText: _errorText,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  obscureText: true,
                  controller: handphoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nomor HP',
                    // errorText: _errorText,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  // obscureText: true,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  controller: addressController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Alamat',
                    // errorText: _errorText,
                  ),
                ),
              ),
              // Container(
              //   child: DropdownButton(
              //     value: roleSelected,
              //     items: role.map((String value) => DropdownMenuItem(child: child))
              //   ),
              // ),
              Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  height: 65,
                  child: ElevatedButton(
                    child: const Text('Daftar'),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      await registFunc();
                      setState(() {
                        loading = false;
                        logged = true;
                      });
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
                child: Text('Sudah punya akun?'),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                height: 55,
                child: OutlinedButton(
                  child: Text('Login'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const MyApp()));
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
