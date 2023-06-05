import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register2_borrower.dart';

class FormBorrower extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _password = '';
  String _telp = '';
  String _ktp = 'foto.jpg';
  int _saku = 0;
  String _validationError = '';
  int _id = 0;

  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get telp => _telp;
  String get ktp => _ktp;
  int get saku => _saku;
  int get id => _id;
  String get validationError => _validationError;

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setTelp(String value) {
    _telp = value;
    notifyListeners();
  }

  bool validateForm() {
    if (_name.isEmpty || _email.isEmpty || _password.isEmpty || _telp.isEmpty) {
      _validationError = 'kosong';
    } else {
      _validationError = '';
    }
    notifyListeners();
    return _validationError.isEmpty;
  }

  void submitForm(void Function() callback) async {
    if (validateForm()) {
      var url = Uri.parse('http://127.0.0.1:8000/borrowers/');

      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'nama': _name,
            'email': _email,
            'password': _password,
            'telp': _telp,
            'ktp': _ktp,
            'saku': _saku
          }));

      if (response.statusCode == 200) {
        print('Post request successful');
        print('Response body: ${response.body}');
        var data = jsonDecode(response.body);
        _id = data["id"];
      } else {
        print('Post request failed');
        print('Response status code: ${response.statusCode}');
        if (response.statusCode == 400) {
          _validationError = 'dipake';
        }
      }
    }
    callback();
  }
}

class RegisterBorrower extends StatelessWidget {
  const RegisterBorrower({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final formBorrower = Provider.of<FormBorrower>(context, listen: false);
    return MaterialApp(
        title: "Modal In | Register Borrower",
        theme: ThemeData(primarySwatch: Colors.teal),
        home: Scaffold(
            body: Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            size: 30.0,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Daftar Sebagai",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Peminjam",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(32, 106, 93, 1),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Text(
                            "Step 1 of 3",
                            style: TextStyle(
                                fontSize: 17, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text(
                            "Lengkapi data diri",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextField(
                        onChanged: formBorrower.setName,
                        decoration: InputDecoration(
                          hintText: 'Nama',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextField(
                        onChanged: formBorrower.setEmail,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextField(
                        onChanged: formBorrower.setPassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextField(
                        onChanged: formBorrower.setTelp,
                        decoration: InputDecoration(
                          hintText: 'No Telp',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Spacer(),
                          Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  formBorrower.submitForm(() {
                                    if (formBorrower.validationError ==
                                        'kosong') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Warning'),
                                            content:
                                                Text('Mohon isi semua data'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      // final snackBar = SnackBar(
                                      //   content: Text('Mohon isi semua data'),
                                      //   action: SnackBarAction(
                                      //     label: 'Close',
                                      //     onPressed: () {
                                      //       // Kode yang akan dijalankan saat tombol snackbar ditekan
                                      //       ScaffoldMessenger.of(context)
                                      //           .hideCurrentSnackBar();
                                      //     },
                                      //   ),
                                      // );
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(snackBar);
                                    } else if (formBorrower.validationError ==
                                        'dipake') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Warning'),
                                            content:
                                                Text('Email sudah digunakan'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return EmailVerification(
                                            id: formBorrower.id,
                                            email: formBorrower.email);
                                      }));
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    minimumSize: Size(100, 50),
                                    backgroundColor:
                                        Color.fromRGBO(32, 106, 93, 1),
                                    foregroundColor: Colors.white),
                                child: Text(
                                  "DAFTAR",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ))));
  }
}
