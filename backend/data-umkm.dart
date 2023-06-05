import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'borrower-success-account.dart';

class FormUmkm extends ChangeNotifier {
  String _validationError = '';

  String _nama = '';
  String _alamat = '';
  String _kategori = '';
  String _penghasilan = '';
  String _fotoUmkm = 'foto.jpg';
  String _npwp = 'foto.jpg';
  String _dokumen = 'foto.jpg';
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
        _penghasilan.isEmpty) {
      _validationError = 'kosong';
    } else {
      _validationError = '';
    }
    notifyListeners();
    return _validationError.isEmpty;
  }

  void submitForm(void Function() callback) async {
    if (validateForm()) {
      var url = Uri.parse('http://127.0.0.1:8000/umkm/');

      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'nama': _nama,
            'alamat': _alamat,
            'kategori': _kategori,
            'penghasilan': _penghasilan,
            'fotoUmkm': _fotoUmkm,
            'npwp': _npwp,
            'dokumen': _dokumen,
            'borrower_id': _borrower_id,
          }));

      if (response.statusCode == 200) {
        print('Post request successful');
        print('Response body: ${response.body}');
      } else {
        print('Post request failed');
        print('Response status code: ${response.statusCode}');
      }
    }
    callback();
  }
}

class Umkm extends StatelessWidget {
  const Umkm({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  Widget build(BuildContext context) {
    final formUmkm = Provider.of<FormUmkm>(context, listen: false);
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.teal),
        title: "Modal In | Register Borrower",
        home: Scaffold(
            body: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 30.0,
                  ),
                )
              ],
            ),
            Text(
              "Hampir Selesai...",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Text(
                    "Step 3 of 3",
                    style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
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
                    borderRadius: BorderRadius.circular(15.0),
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
                    borderRadius: BorderRadius.circular(15.0),
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
                    borderRadius: BorderRadius.circular(15.0),
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
                          borderRadius: BorderRadius.circular(15.0),
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
                  formUmkm.setBorrowerId(id);
                  formUmkm.submitForm(() {
                    if (formUmkm.validationError == 'kosong') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Warning'),
                            content: Text('Mohon isi semua data'),
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
                      // const snackBar = SnackBar(
                      //   duration: Duration(seconds: 20),
                      //   content: Text('Mohon isi semua data'),
                      // );
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return BorrowerSuccessAccount(id: id);
                      }));
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minimumSize: Size(200, 50),
                    backgroundColor: Color.fromRGBO(32, 106, 93, 1),
                    foregroundColor: Colors.white),
                child: Text(
                  "DAFTAR",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ]),
        )));
  }
}
