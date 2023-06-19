import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_riil/borrower/register/borrower-register.dart';
import 'package:tubes_riil/lender/home/lender-home.dart';
import 'package:tubes_riil/lender/register/lender-register.dart';
import './borrower/home/borrower-home.dart';

String selectedRole = "Borrower";

class FormBorrowerLogin extends ChangeNotifier {
  String _email = '';
  String _password = '';
  String _validationError = '';
  String _token = "";

  String get email => _email;
  String get password => _password;
  String get validationError => _validationError;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  bool validateForm() {
    if (_email.isEmpty || _password.isEmpty) {
      _validationError = 'kosong';
    } else {
      _validationError = '';
    }
    notifyListeners();
    return _validationError.isEmpty;
  }

  void fetchUser() async {
    final url = Uri.parse('http://127.0.0.1:8000/borrower/me/');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      // print(responseBody);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  void fetchUserLender() async {
    final url = Uri.parse('http://127.0.0.1:8000/lender/me/');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      // print(responseBody);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> setStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('status', status);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('status');
  }

  void submitForm(void Function() callback) async {
    if (validateForm()) {
      if (selectedRole == "Borrower") {
        var url = http.MultipartRequest(
            'POST', Uri.parse('http://127.0.0.1:8000/borrower/token/'));

        url.fields['username'] = _email;
        url.fields['password'] = _password;

        var response = await url.send();

        if (response.statusCode == 200) {
          print('get token');
          var responseBody = await response.stream.bytesToString();
          var jsonData = json.decode(responseBody);
          _token = jsonData["access_token"];

          await setToken(_token);
          await setStatus("borrower");

          // fetchUser();
        } else {
          print('token request failed');
          print('Response status code: ${response.statusCode}');
          _validationError = "salah";
        }
      } else if (selectedRole == "Lender") {
        var url = http.MultipartRequest(
            'POST', Uri.parse('http://127.0.0.1:8000/lender/token/'));

        url.fields['username'] = _email;
        url.fields['password'] = _password;

        var response = await url.send();

        if (response.statusCode == 200) {
          print('get token');
          var responseBody = await response.stream.bytesToString();
          var jsonData = json.decode(responseBody);
          _token = jsonData["access_token"];

          await setToken(_token);
          await setStatus("lender");

          // fetchUserLender();
        } else {
          print('token request failed');
          print('Response status code: ${response.statusCode}');
          _validationError = "salah";
        }
      }
    }
    callback();
  }
}

class RoleProvider with ChangeNotifier {
  String _selectedRole = 'Borrower';

  String get selectedRole => _selectedRole;

  set selectedRole(String value) {
    _selectedRole = value;
    notifyListeners();
  }
}

class MyDropdownWidget extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String?> onChanged;

  MyDropdownWidget({
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedOption,
      onChanged: onChanged,
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final formBorrowerLogin =
        Provider.of<FormBorrowerLogin>(context, listen: false);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal),
        title: "Modal In | Login",
        home: Scaffold(
            body: Container(
          decoration: const BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(
                "images/background-opacity.png",
              ),
              fit: BoxFit.fitHeight,
            ),
          ),
          // margin: EdgeInsets.symmetric(horizontal: 30),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                child: Image.asset(
                  'images/logo-full.png',
                  // width: 350,
                  // height: 350,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Center(
                    child: Text(
                  "Modalin mimpimu, capai kesuksesan!",
                  style: TextStyle(fontSize: 20),
                )),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8), // Warna shadow
                      spreadRadius: 2, // Jarak penyebaran shadow
                      blurRadius: 5, // Jarak blur shadow
                      offset: Offset(0, 3), // Posisi offset shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                            child: Text(
                          "Silahkan login menggunakan akun Modal In anda",
                          style: TextStyle(fontSize: 17),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: TextField(
                          onChanged: formBorrowerLogin.setEmail,
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
                          onChanged: formBorrowerLogin.setPassword,
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
                        child: Consumer<RoleProvider>(
                          builder: (context, roleProvider, _) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: roleProvider.selectedRole,
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        roleProvider.selectedRole = newValue;
                                        selectedRole = newValue;
                                      }
                                    },
                                    items: ['Borrower', 'Lender']
                                        .map((String option) =>
                                            DropdownMenuItem<String>(
                                              value: option,
                                              child: Text(option),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 15),
                      //   child: Consumer<RoleProvider>(
                      //     builder: (context, roleProvider, _) {
                      //       return MyDropdownWidget(
                      //         options: ['Borrower', 'Lender'],
                      //         selectedOption: roleProvider.selectedRole,
                      //         onChanged: (String? newValue) {
                      //           if (newValue != null) {
                      //             roleProvider.selectedRole = newValue;
                      //             selectedRole = newValue;
                      //             // print('Selected Role: ${roleProvider.selectedRole}');
                      //           }
                      //         },
                      //       );
                      //     },
                      //   ),
                      // ),
                      Row(
                        children: [
                          // Expanded(
                          //     child: GestureDetector(
                          //   onTap: () {
                          //     // Add your text click logic here
                          //   },
                          //   child: Text(
                          //     'Lupa password?',
                          //     style:
                          //         TextStyle(fontSize: 17, color: Colors.grey),
                          //   ),
                          // )),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: ElevatedButton(
                                  onPressed: () {
                                    formBorrowerLogin.submitForm(() {
                                      if (formBorrowerLogin.validationError ==
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
                                      } else if (formBorrowerLogin
                                              .validationError ==
                                          'salah') {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Warning'),
                                              content: Text(
                                                  'Gagal melakukan login, pastikan email dan password yang anda input benar'),
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
                                        if (selectedRole == "Borrower") {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return BorrowerPage();
                                          }));
                                        } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return LenderPage();
                                          }));
                                        }
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      minimumSize: Size(100, 50),
                                      backgroundColor:
                                          Color.fromRGBO(32, 106, 93, 1),
                                      foregroundColor: Colors.white),
                                  child: Text(
                                    'MASUK',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Center(
                    child: Text(
                  "Belum memiliki akun?",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return RegisterLender();
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            minimumSize: Size(50, 90),
                            backgroundColor: Color.fromRGBO(32, 106, 93, 1),
                            foregroundColor: Colors.white),
                        child: Column(
                          children: [
                            Text(
                              'Daftar Sebagai',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Pendana',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '(Lender)',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w700),
                            ),
                          ],
                        )),
                    Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return RegisterBorrower();
                            }));
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              minimumSize: Size(50, 90),
                              backgroundColor: Color.fromRGBO(32, 106, 93, 1),
                              foregroundColor: Colors.white),
                          child: Column(
                            children: [
                              Text(
                                'Daftar Sebagai',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                'Peminjam',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '(Borrower)',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              )
            ]),
          ),
        )));
  }
}
