import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../success-notice/borrower-success-account.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class FormUmkm extends ChangeNotifier {
  String _validationError = '';

  String _nama = '';
  String _alamat = '';
  String _kategori = '';
  String _penghasilan = '';
  String _fotoUmkm = 'foto.jpg';
  String _npwp = 'foto.jpg';
  String _dokumen = 'foto.jpg';
  String _token = "";
  int _borrower_id = 0;

  String get nama => _nama;
  String get alamat => _alamat;
  String get kategori => _kategori;
  String get penghasilan => _penghasilan;
  String get fotoUmkm => _fotoUmkm;
  String get npwp => _npwp;
  String get dokumen => _dokumen;
  int get borrower_id => _borrower_id;
  String get validationError => _validationError;

  void setNama(String value) {
    _nama = value;
    notifyListeners();
  }

  void setToken2(String value) {
    _token = value;
    notifyListeners();
  }

  void setBorrowerId(int value) {
    _borrower_id = value;
    notifyListeners();
  }

  void setalamat(String value) {
    _alamat = value;
    notifyListeners();
  }

  void setkategori(String value) {
    _kategori = value;
    notifyListeners();
  }

  void setpenghasilan(String value) {
    _penghasilan = value;
    notifyListeners();
  }

  bool validateForm() {
    if (_nama.isEmpty ||
        _alamat.isEmpty ||
        _kategori.isEmpty ||
        _penghasilan.isEmpty ||
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

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> setStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('status', status);
  }

  void submitForm(void Function() callback) async {
    if (validateForm()) {
      print("mulai upload");
      await uploadFile(_bytes as List<int>, _pickedImage.name);
      var url = Uri.parse('http://127.0.0.1:8000/umkm/');

      var response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $_token'
          },
          body: json.encode({
            'nama': _nama,
            'alamat': _alamat,
            'kategori': _kategori,
            'penghasilan': _penghasilan,
            'fotoUmkm': _namaImage,
            'npwp': _npwp,
            'dokumen': _dokumen,
          }));

      if (response.statusCode == 200) {
        print('Post request successful');
        print('Response body: ${response.body}');

        await setToken(_token);
        await setStatus("borrower");
      } else {
        print('Post request failed');
        print('Response status code: ${response.statusCode}');
      }
    }
    callback();
  }
}

class FormulirUMKM extends StatelessWidget {
  const FormulirUMKM({Key? key, required this.token}) : super(key: key);
  final String token;
  @override
  Widget build(BuildContext context) {
    final formUmkm = Provider.of<FormUmkm>(context, listen: false);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal),
        title: "Modal In | Register Borrower",
        home: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              // leading: IconButton(
              //   icon: Icon(Icons.arrow_back, color: Colors.black),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              // ),
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hampir Selesai...",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
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
                                          "Step 2 of 2",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.grey.shade600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Masukkan data UMKM anda",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: TextField(
                                      onChanged: formUmkm.setNama,
                                      decoration: InputDecoration(
                                        hintText: 'Nama UMKM',
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
                                      onChanged: formUmkm.setalamat,
                                      decoration: InputDecoration(
                                        hintText: 'Alamat',
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
                                      onChanged: formUmkm.setkategori,
                                      decoration: InputDecoration(
                                        hintText: 'Kategori UMKM',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Penghasilan per Tahun",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            onChanged: formUmkm.setpenghasilan,
                                            decoration: InputDecoration(
                                              hintText: 'Rp',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // print("gimang");
                                        formUmkm.getImageFromGallery();
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
                                                  'Upload Foto UMKM',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors
                                                        .black, // Set text color to black
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              Padding(
                                                padding: const EdgeInsets.only(
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
                                    padding: const EdgeInsets.only(top: 15),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        formUmkm.setToken2(token);
                                        formUmkm.submitForm(() {
                                          if (formUmkm.validationError ==
                                              'kosong') {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Warning'),
                                                  content: Text(
                                                      'Mohon isi semua data'),
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
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return BorrowerSuccessAccount();
                                            }));
                                          }
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          minimumSize: Size(200, 50),
                                          backgroundColor:
                                              Color.fromRGBO(32, 106, 93, 1),
                                          foregroundColor: Colors.white),
                                      child: Text(
                                        "DAFTAR",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ]),
                ),
              ],
            )));
  }
}
