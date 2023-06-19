import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../success-notice/lender-success-pencairan.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CairLenderProvider with ChangeNotifier {
  int _saku = 0;
  int _updatesakucair = 0;
  bool _isDataFetched = false;
  String _validationError = 'kosong';
  String? _token = "";

  int get saku => _saku;
  int get updatesaku => _updatesakucair;
  String get validationError => _validationError;

  void setsaku(int value) {
    _saku = value;
    notifyListeners();
  }

  void setupdatesaku(int value) {
    _updatesakucair = value;
    notifyListeners();
  }

  void setDataFetched(bool value) {
    _isDataFetched = value;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchData() async {
    if (_isDataFetched) {
      // Data has already been fetched, no need to fetch again
      return;
    }
    _token = await getToken();
    final url = Uri.parse('http://127.0.0.1:8000/lender/me/');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $_token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _saku = data['saku'];
        _isDataFetched = true;
        notifyListeners();
      } else {
        throw Exception('Failed to fetch saku data');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server');
    }
  }

  bool validateForm() {
    print("woy woy :$_updatesakucair");
    if (_updatesakucair == 0 || _updatesakucair == Null) {
      _validationError = 'kosong';
    } else {
      _validationError = '';
    }
    notifyListeners();
    return _validationError.isEmpty;
  }

  Future<void> patchSaku(int updatedSakucair) async {
    if (validateForm()) {
      _token = await getToken();
      final apiUrl = Uri.parse('http://127.0.0.1:8000/update_lender_patch/');
      print("saku = $saku");
      print("updated saku :  $updatedSakucair");
      try {
        final response = await http.patch(
          apiUrl,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $_token'
          },
          body: json.encode({"saku": saku - updatedSakucair}),
        );

        if (response.statusCode == 200) {
          _saku -= updatedSakucair;
          _isDataFetched = false;

          notifyListeners();
          final url = Uri.parse("http://127.0.0.1:8000/riwayatLender/");
          var response2 = await http.post(url,
              headers: {
                "Content-Type": "application/json",
                'Authorization': 'Bearer $_token'
              },
              body: json.encode({
                'nominal': updatesaku,
                'status': "cair",
              }));
          if (response2.statusCode == 200) {
            print('Riwayat request successful');
            print('Response body: ${response2.body}');
          } else {
            print('Post request failed');
            print('Response status code: ${response2.statusCode}');
          }
        } else {
          throw Exception('Failed to update saku data');
        }
      } catch (error) {
        throw Exception('Failed to connect to the server');
      }
    }
  }
}

class PencairanDanaLender extends StatelessWidget {
  const PencairanDanaLender({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cairProvider = Provider.of<CairLenderProvider>(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Pendanaan UMKM",
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
            body: FutureBuilder(
                // future: isiProvider.fetchData(widget.id),
                future: Provider.of<CairLenderProvider>(context, listen: false)
                    .fetchData(),
                builder: (context, snapshot) {
                  return Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'icons/icon-cairkan.png',
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            "Cairkan Dana",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: 30, right: 30, bottom: 15, top: 35),
                      //   child: Container(
                      //     child: TextField(
                      //       keyboardType: TextInputType.number,
                      //       inputFormatters: <TextInputFormatter>[
                      //         FilteringTextInputFormatter.allow(
                      //             RegExp(r'[0-9]')),
                      //         FilteringTextInputFormatter.digitsOnly
                      //       ],
                      //       decoration: InputDecoration(
                      //           hintText: "Nomor Rekening",
                      //           border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(15.0),
                      //           )),
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //       ), // Menyesuaikan ukuran teks
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 20),
                        child: Row(
                          children: [
                            Text(
                              "Nominal",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 20),
                        child: Container(
                          child: TextField(
                            onChanged: (text) {
                              if (text.isEmpty) {
                                cairProvider.setupdatesaku(0);
                              } else {
                                int nilai = int.parse(text);
                                cairProvider.setupdatesaku(nilai);
                              }
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              prefixText: 'Rp ',
                            ),
                            style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            ), // Menyesuaikan ukuran teks
                          ),
                        ),
                      ),
                      Container(
                        color: Color.fromRGBO(191, 220, 174, 1),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 40, right: 30),
                              child: Row(
                                children: [
                                  Text(
                                    "Rekening Sumber",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(32, 106, 93, 1),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 20, left: 30, right: 30),
                              child: Container(
                                // color: Color.fromRGBO(191, 220, 174, 1),
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                // margin: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Saku Modal In',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Row(
                                    //       children: [
                                    //         Text(
                                    //           '8632458732423',
                                    //           style: TextStyle(
                                    //               fontSize: 14,
                                    //               fontWeight: FontWeight.w400),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(height: 10),
                                    Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'Rp ${cairProvider.saku}',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color.fromRGBO(
                                                          0, 177, 71, 1)),
                                                ),
                                              ],
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: ElevatedButton(
                                onPressed: () {
                                  cairProvider.validateForm();
                                  if (cairProvider.updatesaku >
                                      cairProvider.saku) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Warning'),
                                          content: Text(
                                              'Gagal mencairkan dana, pastikan dana mencukupi'),
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
                                  } else if (cairProvider.validationError ==
                                      'kosong') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Warning'),
                                          content: Text(
                                              'Isi nominal terlebih dahulu'),
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
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0), // Menentukan radius pinggiran dialog
                                          ),
                                          backgroundColor:
                                              Color.fromRGBO(191, 220, 174, 1),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                child: Text(
                                                  'Konfirmasi Pencairan Dana',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                iconSize: 15,
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Anda yakin untuk mencairkan dana?',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 30),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    cairProvider
                                                        .setDataFetched(false);
                                                    cairProvider.patchSaku(
                                                        cairProvider
                                                            .updatesaku);
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return LenderSuccessPencairan();
                                                    }));
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
                                                            .all(Colors.white),
                                                    minimumSize:
                                                        MaterialStateProperty
                                                            .all(Size(230, 40)),
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(EdgeInsets.all(
                                                                10)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Text(
                                                          "Lanjut Cairkan",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 5),
                                                        child: Text(
                                                          "Rp. " +
                                                              cairProvider
                                                                  .updatesaku
                                                                  .toString(),
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      177,
                                                                      71,
                                                                      1),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }

                                  // Navigator.of(context)
                                  //     .pushNamed("/successPencairan");
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(32, 106, 93, 1),
                                  ),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(20)),
                                ),
                                child: Text('LANJUTKAN',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 40),
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       Navigator.of(context)
                      //           .push(MaterialPageRoute(builder: (context) {
                      //         return LenderSuccessPencairan();
                      //       }));
                      //     },
                      //     style: ButtonStyle(
                      //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      //         RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(
                      //               25), // Mengatur sudut melengkung
                      //         ),
                      //       ),
                      //       backgroundColor:
                      //           MaterialStateProperty.all(Color.fromRGBO(32, 106, 93, 1)),
                      //       minimumSize: MaterialStateProperty.all(Size(290, 50)),
                      //       padding: MaterialStateProperty.all(EdgeInsets.all(17)),
                      //     ),
                      //     child: Text('LANJUTKAN',
                      //         style: TextStyle(fontSize: 17, color: Colors.white)),
                      //   ),
                      // ),
                    ],
                  ));
                })));
  }
}
