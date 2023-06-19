import 'package:flutter/material.dart';
import '../success-notice/borrower-success-pengajuan.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'borrower-home.dart';

class FormAjukan with ChangeNotifier {
  int _biaya = 0;
  int _tenor = 0;
  int _minimalbiaya = 0;
  int _inputnominal = 0;
  int _inputtenor = 0;
  int _estimasibiaya = 0;

  // String _opsi = '';
  // int _umkm_id = 0;
  String _validationError = '';
  String? _token = "";

  int get biaya => _biaya;
  int get tenor => _tenor;
  // int get umkm_id => _umkm_id;
  int get minimalbiaya => _minimalbiaya;
  // String get opsi => _opsi;
  String get validationError => _validationError;
  int get inputnominal => _inputnominal;
  int get inputtenor => _inputtenor;
  int get estimasibiaya => _estimasibiaya;

  void setInputNominal(int value) {
    _inputnominal = value;
    notifyListeners();
  }

  void setInputTenor(int value) {
    _inputtenor = value;
    notifyListeners();
  }

  void setEstimasiBiaya(int value) {
    _estimasibiaya = value;
    notifyListeners();
  }

  void setBiaya(int value) {
    _biaya = value;
    notifyListeners();
  }

  void setTenor(int value) {
    _tenor = value;
    notifyListeners();
  }

  void setMinimalbiaya(int value) {
    _minimalbiaya = value;
    notifyListeners();
  }

  bool validateForm() {
    if (_biaya == 0 || _tenor == 0 || _minimalbiaya == 0) {
      _validationError = 'kosong';
    } else {
      _validationError = '';
    }
    notifyListeners();
    return _validationError.isEmpty;
  }

  void kalkulator() {
    double totalbunga = _inputnominal * 1 * _inputtenor / 100;
    double totalbayar = _inputnominal + totalbunga;
    int roundedNumber2 = totalbayar.round();

    _estimasibiaya = roundedNumber2;
    print("estimasi : ${_estimasibiaya}");

    notifyListeners();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void submitForm() async {
    if (validateForm()) {
      _token = await getToken();
      var url = Uri.parse('http://127.0.0.1:8000/ajuan/');

      // bunga pertahun dibagi bulan dalam setahun (12)
      double bungaperbulan = 12 / 12;
      // menghitung total bunga
      double totalbunga = _biaya * bungaperbulan * _tenor / 100;
      // menghitung total biaya yang harus dibayar
      double totalbayar = _biaya + totalbunga;

      double bunga = _tenor * bungaperbulan;

      int roundedNumber = bunga.round();
      int roundedNumber2 = totalbayar.round();

      var response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $_token'
          },
          body: json.encode({
            'besar_biaya': _biaya,
            'tenor_pendanaan': _tenor,
            'minimal_biaya': _minimalbiaya,
            'opsi_pengembalian': "lunas",
            'bunga': roundedNumber,
            'status': 'mengajukan',
            'sisa_pengembalian': 0,
          }));

      if (response.statusCode == 200) {
        print('Post request successful');
        print('Response body: ${response.body}');
        var data = jsonDecode(response.body);

        _token = await getToken();
        var url2 = Uri.parse('http://127.0.0.1:8000/update_borrower_patch/');

        final response2 = await http.patch(
          url2,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $_token'
          },
          body: json.encode({"status": "mengajukan"}),
        );

        if (response2.statusCode == 200) {
          print("berhasil ajukan");
        } else {
          print("gagal ajukan");
        }
      } else {
        print('Post request failed');
        print('Response status code: ${response.statusCode}');
      }
    }
  }
}

class AjukanPinjamanPage extends StatelessWidget {
  const AjukanPinjamanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formAjukan = Provider.of<FormAjukan>(context, listen: false);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Modal In | FORM PENGAJUAN Borrower",
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Scaffold(
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
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 90),
                Column(
                  children: [
                    Text(
                      "Form Pengajuan",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Pinjaman",
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
                  padding: const EdgeInsets.only(top: 30),
                  child: TextField(
                    onChanged: (text) {
                      if (text.isEmpty) {
                        formAjukan.setBiaya(0);
                      } else {
                        int nilai = int.parse(text);
                        formAjukan.setBiaya(nilai);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Besar Biaya',
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
                        "*Dalam bulan",
                        style: TextStyle(
                            fontSize: 17, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: TextField(
                    onChanged: (text) {
                      if (text.isEmpty) {
                        formAjukan.setTenor(0);
                      } else {
                        int nilai = int.parse(text);
                        formAjukan.setTenor(nilai);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Tenor Pendanaan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextField(
                    onChanged: (text) {
                      if (text.isEmpty) {
                        formAjukan.setMinimalbiaya(0);
                      } else {
                        int nilai = int.parse(text);
                        formAjukan.setMinimalbiaya(nilai);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Minimal Biaya',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 20),
                //   child: DropdownButtonFormField<String>(
                //     decoration: InputDecoration(
                //       hintText: 'Opsi Pengembalian',
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(15.0),
                //       ),
                //     ),
                //     items: <String>[
                //       'opsi 1',
                //       'opsi 2',
                //       'opsi 3',
                //       'opsi 4',
                //     ].map((String value) {
                //       return DropdownMenuItem<String>(
                //         value: value,
                //         child: Text(value),
                //       );
                //     }).toList(),
                //     onChanged: (String? newValue) {},
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 55, left: 95),
                              child: Text(
                                'Kalkulator Peminjaman',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 55, left: 10),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(255, 214, 220, 215),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.only(right: 2),
                                    icon: Icon(
                                      Icons.calculate_rounded,
                                      size: 30,
                                      color: const Color.fromARGB(255, 7, 7, 7),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Color.fromARGB(
                                                255, 193, 237, 195),
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 30),
                                                  child: Text(
                                                    'Kalkulator Peminjaman',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.close),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    formAjukan
                                                        .setEstimasiBiaya(0);
                                                    formAjukan
                                                        .setInputNominal(0);
                                                    formAjukan.setInputTenor(0);
                                                  },
                                                ),
                                              ],
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 110),
                                                  child: Text(
                                                    'Nominal yang Diajukan',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                TextFormField(
                                                  onChanged: (text) {
                                                    if (text.isEmpty) {
                                                      formAjukan
                                                          .setInputNominal(0);
                                                    } else {
                                                      int nilai =
                                                          int.parse(text);
                                                      formAjukan
                                                          .setInputNominal(
                                                              nilai);
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    prefix: Text('Rp. ',
                                                        style: TextStyle(
                                                          fontFamily: 'Arial',
                                                          fontSize: 25,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    hintText: '0',
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'Arial',
                                                      fontSize: 25,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25,
                                                  ),
                                                  initialValue: '0',
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 150),
                                                  child: Text(
                                                    'Tenor Pendanaan',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 150),
                                                  child: Text(
                                                    '*Dalam Minggu',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 15,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 300,
                                                  height: 38,
                                                  child: TextFormField(
                                                    onChanged: (text) {
                                                      if (text.isEmpty) {
                                                        formAjukan
                                                            .setInputTenor(0);
                                                      } else {
                                                        int nilai =
                                                            int.parse(text);
                                                        formAjukan
                                                            .setInputTenor(
                                                                nilai);
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: '',
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        borderSide: BorderSide(
                                                          color: const Color
                                                                  .fromARGB(
                                                              255, 0, 0, 0),
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Provider.of<FormAjukan>(
                                                            context,
                                                            listen: false)
                                                        .kalkulator();
                                                  },
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Color.fromRGBO(
                                                                32,
                                                                106,
                                                                93,
                                                                1)),
                                                    minimumSize:
                                                        MaterialStateProperty
                                                            .all(Size(230, 40)),
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(EdgeInsets.all(
                                                                10)),
                                                  ),
                                                  child: Text('KALKULASI'),
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  height: 1,
                                                  color: Colors.white,
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(right: 4),
                                                  child: Text(
                                                    'Estimasi Biaya yang harus dikembalikan',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 15,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Consumer<FormAjukan>(
                                                      builder: (context,
                                                          formAjukan, _) {
                                                    return Text(
                                                      'Rp. ${formAjukan.estimasibiaya.toString()}',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 0, 0, 0),
                                                      ),
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                            // actions: [
                                            //   TextButton(
                                            //     child: Text('KALKULASI'),
                                            //     onPressed: () {
                                            //
                                            //     },
                                            //   ),
                                            // ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      // Spacer(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            formAjukan.submitForm();
                            if (formAjukan.validationError == 'kosong') {
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
                            } else {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return BorrowerSuccessPengajuan();
                              }));
                            }
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    25), // Mengatur sudut melengkung
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(32, 106, 93, 1)),
                            minimumSize:
                                MaterialStateProperty.all(Size(339, 50)),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(10)),
                          ),
                          child: Text('AJUKAN PINJAMAN',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
