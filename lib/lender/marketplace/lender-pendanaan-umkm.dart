import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../success-notice/lender-success-pembayaran.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PendanaanProvider with ChangeNotifier {
  int _saku = 0;
  int _updatesaku = 0;
  bool _isDataFetched = false;
  String _validationError = 'kosong';
  String? _token = "";

  int get saku => _saku;
  int get updatesaku => _updatesaku;
  String get validationError => _validationError;

  void setsaku(int value) {
    _saku = value;
    notifyListeners();
  }

  void setupdatesaku(int value) {
    _updatesaku = value;
    notifyListeners();
  }

  void setDataFetched(bool value) {
    _isDataFetched = value;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  bool validateForm() {
    // print("woy woy :$_updatesaku");
    if (_updatesaku == 0 || _updatesaku == Null) {
      _validationError = 'kosong';
    } else {
      _validationError = '';
    }
    notifyListeners();
    return _validationError.isEmpty;
  }

  Future<void> fetchData() async {
    if (_isDataFetched) {
      // Data has already been fetched, no need to fetch again
      return;
    }
    setDataFetched(true);
    _token = await getToken();
    final url = Uri.parse('http://127.0.0.1:8000/lender/me/');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $_token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("fetch saku");
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

  Future<void> danai(int market_id) async {
    _token = await getToken();
    // print("danain: $updatesaku");
    // print("market_id: $market_id");
    final apiUrl = Uri.parse('http://127.0.0.1:8000/pendanaan/');
    try {
      final response = await http.post(apiUrl,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $_token'
          },
          body: json.encode({
            "total_pinjaman": updatesaku,
            "market_id": market_id,
            "status": "belum"
          }));

      if (response.statusCode == 200) {
        // _isDataFetched = false;
        notifyListeners();
        print("berhasil danai");
      } else {
        throw Exception('Failed to update saku data');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server');
    }
  }
}

class PendanaanUMKM extends StatelessWidget {
  const PendanaanUMKM(
      {Key? key,
      required this.market_id,
      required this.namaUmkm,
      required this.minimal_biaya,
      required this.sisa})
      : super(key: key);
  final int market_id;
  final String namaUmkm;
  final int minimal_biaya;
  final int sisa;
  @override
  Widget build(BuildContext context) {
    final pendanaanProvider = Provider.of<PendanaanProvider>(context);
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
                  pendanaanProvider.setDataFetched(false);
                  Navigator.pop(context);
                },
              ),
            ),
            body: FutureBuilder(
                // future: isiProvider.fetchData(widget.id),
                future: Provider.of<PendanaanProvider>(context, listen: false)
                    .fetchData(),
                builder: (context, snapshot) {
                  return Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'icons/icon-danai.png',
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            "Pembayaran Mendanai",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "UMKM ${namaUmkm}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "12983798127491326",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 70),
                        child: Row(
                          children: [
                            Text(
                              "Minimal Pendanaan",
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
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Row(
                          children: [
                            Text(
                              "Rp $minimal_biaya",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                pendanaanProvider.setupdatesaku(0);
                              } else {
                                int nilai = int.parse(text);
                                pendanaanProvider.setupdatesaku(nilai);
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
                                                  'Rp ${pendanaanProvider.saku}',
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
                                  pendanaanProvider.validateForm();
                                  if (pendanaanProvider.updatesaku >
                                      pendanaanProvider.saku) {
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
                                                pendanaanProvider
                                                    .setDataFetched(false);
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (pendanaanProvider.updatesaku <
                                      minimal_biaya) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Warning'),
                                          content: Text(
                                              'Jumlah dana kurang dari batas yang diatur oleh borrower'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                pendanaanProvider
                                                    .setDataFetched(false);
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (pendanaanProvider.updatesaku >
                                      sisa) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Warning'),
                                          content: Text(
                                              'Jumlah dana melebihi sisa jumlah ajuan'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                pendanaanProvider
                                                    .setDataFetched(false);
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (pendanaanProvider
                                          .validationError ==
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
                                                pendanaanProvider
                                                    .setDataFetched(false);
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
                                                  'Konfirmasi Pendanaan',
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
                                                  pendanaanProvider
                                                      .setDataFetched(false);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Anda yakin untuk melakukan pendanaan?',
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
                                                    pendanaanProvider
                                                        .setDataFetched(false);
                                                    pendanaanProvider
                                                        .danai(market_id);
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return LenderSuccessPayment();
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
                                                          "Lanjut Bayar",
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
                                                          "Rp ${pendanaanProvider.updatesaku} >",
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

                                  // Navigator.of(context).pushNamed("/successPayment");
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
                    ],
                  ));
                })));
  }
}
