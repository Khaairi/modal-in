import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'borrower-email-verification.dart';
import 'borrower-form-umkm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class FormBorrower extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _password = '';
  String _telp = '';
  String _ktp = 'foto.jpg';
  int _saku = 0;
  String _validationError = '';
  String _token = "";
  int _id = 0;

  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get telp => _telp;
  String get ktp => _ktp;
  int get saku => _saku;
  String get validationError => _validationError;
  String get token => _token;
  int get id => _id;

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
    if (_name.isEmpty ||
        _email.isEmpty ||
        _password.isEmpty ||
        _telp.isEmpty ||
        _pickedImage == null) {
      _validationError = 'kosong';
    } else {
      _validationError = '';
    }
    notifyListeners();
    return _validationError.isEmpty;
  }

  final dio = Dio();
  final _picker = ImagePicker();
  var _pickedImage;
  var _bytes;
  String _namaImage = "";
  Future<String> uploadFile(List<int> file, String fileName) async {
    print("mulai");
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(file,
          filename: fileName, contentType: MediaType("image", "png")),
    });
    var response =
        //untuk chorme
        await dio.post("http://127.0.0.1:8000/uploadimage", data: formData);

    //untuk android
    //await dio.post("http://10.0.2.2:8000/uploadimage", data: formData);

    print(response.statusCode);
    if (response.statusCode == 200) {
      _namaImage = fileName;
    }
    return fileName;
  }

  Future<void> getImageFromGallery() async {
    print("get image");

    _pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    _bytes = await _pickedImage?.readAsBytes();
  }

  void submitForm(void Function() callback) async {
    if (validateForm()) {
      print("mulai upload");
      await uploadFile(_bytes as List<int>, _pickedImage.name);
      var url = Uri.parse('http://127.0.0.1:8000/borrowers/');

      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'nama': _name,
            'email': _email,
            'password': _password,
            'telp': _telp,
            'ktp': _namaImage,
            'saku': _saku,
            'status': "selesai"
          }));

      if (response.statusCode == 200) {
        print('Post request successful');
        print('Response body: ${response.body}');
        var jsonData = json.decode(response.body);
        _token = jsonData["access_token"];
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
        debugShowCheckedModeBanner: false,
        title: "Modal In | Register Borrower",
        theme: ThemeData(primarySwatch: Colors.teal),
        home: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(
                        "images/background-opacity.png",
                      ),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.8), // Warna shadow
                                  spreadRadius: 2, // Jarak penyebaran shadow
                                  blurRadius: 5, // Jarak blur shadow
                                  offset: Offset(0, 3), // Posisi offset shadow
                                ),
                              ],
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Step 1 of 2",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey.shade600),
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
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
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
                                            borderRadius:
                                                BorderRadius.circular(15.0),
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
                                            borderRadius:
                                                BorderRadius.circular(15.0),
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
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 15),
                                    //   child: TextField(
                                    //     obscureText: true,
                                    //     decoration: InputDecoration(
                                    //       hintText: 'Re-type Password',
                                    //       border: OutlineInputBorder(
                                    //         borderRadius: BorderRadius.circular(15.0),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: TextField(
                                        onChanged: formBorrower.setTelp,
                                        decoration: InputDecoration(
                                          hintText: 'No Telephone',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 15),
                                    //   child: GestureDetector(
                                    //     onTap: () {
                                    //       Navigator.pop(context);
                                    //     },
                                    //     child: Container(
                                    //       height: 50,
                                    //       decoration: BoxDecoration(
                                    //         borderRadius:
                                    //             BorderRadius.circular(15),
                                    //         border: Border.all(
                                    //           color: Colors.grey,
                                    //           width: 1,
                                    //         ),
                                    //       ),
                                    //       child: Row(
                                    //         children: [
                                    //           Padding(
                                    //             padding: const EdgeInsets.only(
                                    //                 left: 8),
                                    //             child:
                                    //                 Icon(Icons.image_outlined),
                                    //           ),
                                    //           SizedBox(width: 16),
                                    //           Expanded(
                                    //             child: Text(
                                    //               'No file selected',
                                    //               style: TextStyle(
                                    //                   fontSize: 17,
                                    //                   color:
                                    //                       Colors.grey.shade600),
                                    //               overflow:
                                    //                   TextOverflow.ellipsis,
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // print("gimang");
                                          formBorrower.getImageFromGallery();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            side: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size(0, 50),
                                          primary: Colors
                                              .white, // Set background color to white
                                        ),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Upload Foto KTP',
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors
                                                          .black, // Set text color to black
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(width: 16),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0),
                                                  child: Icon(
                                                      Icons.image_outlined,
                                                      color: Colors.black),
                                                ), // Set icon color to black
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, bottom: 30),
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  formBorrower.submitForm(() {
                                                    if (formBorrower
                                                            .validationError ==
                                                        'kosong') {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title:
                                                                Text('Warning'),
                                                            content: Text(
                                                                'Mohon isi semua data'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Close the dialog
                                                                },
                                                                child: Text(
                                                                    'Close'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    } else if (formBorrower
                                                            .validationError ==
                                                        'dipake') {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title:
                                                                Text('Warning'),
                                                            content: Text(
                                                                'Email sudah digunakan'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Close the dialog
                                                                },
                                                                child: Text(
                                                                    'Close'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return FormulirUMKM(
                                                          token: formBorrower
                                                              .token,
                                                        );
                                                      }));
                                                    }
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    minimumSize: Size(100, 50),
                                                    backgroundColor:
                                                        Color.fromRGBO(
                                                            32, 106, 93, 1),
                                                    foregroundColor:
                                                        Colors.white),
                                                child: Text(
                                                  "DAFTAR",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
