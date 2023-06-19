import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../success-notice/borrower-success-pembayaran.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BayarProvider with ChangeNotifier {
  int _saku = 0;
  int _updatesakucair = 0;
  String _nama = '';
  bool _isDataFetched = false;
  String _validationError = 'kosong';
  String? _token = "";
  int _sisa_pembayaran = 0;
  String status = '';
  int _ajuanid = 0;

  int get ajuanid => _ajuanid;
  int get saku => _saku;
  int get updatesaku => _updatesakucair;
  String get validationError => _validationError;
  String get nama => _nama;
  int get sisa_pembayaran => _sisa_pembayaran;

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
    setDataFetched(true);
    _saku = 0;
    _updatesakucair = 0;
    _token = await getToken();
    final url = Uri.parse('http://127.0.0.1:8000/borrower/me/');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $_token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _saku = data['saku'];
        var data2 = data['umkm'];
        _nama = data2[0]["nama"];
        _isDataFetched = true;
        final url2 = Uri.parse('http://127.0.0.1:8000/borrower/ajuan/');
        final response2 =
            await http.get(url2, headers: {'Authorization': 'bearer $_token'});
        if (response2.statusCode == 200) {
          var data = jsonDecode(response2.body);
          print("masuk bang");
          _sisa_pembayaran = data["sisa_pengembalian"];
          _ajuanid = data["id"];
          print(_ajuanid);
          print(_sisa_pembayaran);
        } else {
          print("gagal fetch ajuan");
        }
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

  Future<void> patchSaku() async {
    if (validateForm()) {
      final url3 =
          Uri.parse('http://127.0.0.1:8000/update_ajuan_patch/${_ajuanid}');
      final response3 = await http.patch(
        url3,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({"sisa_pengembalian": updatesaku}),
      );
      _token = await getToken();
      final apiUrl = Uri.parse('http://127.0.0.1:8000/update_borrower_patch/');
      print("saku = $saku");
      print("updated saku :  $updatesaku");
      final response = await http.patch(
        apiUrl,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $_token'
        },
        body: json.encode({"saku": saku - updatesaku}),
      );
    }
  }
}

class PembayaranBorrower extends StatelessWidget {
  const PembayaranBorrower({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bayarProvider = Provider.of<BayarProvider>(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  bayarProvider.setDataFetched(false);
                  Navigator.pop(context);
                },
              ),
            ),
            body: FutureBuilder(
                future: Provider.of<BayarProvider>(context, listen: false)
                    .fetchData(),
                builder: (context, snapshot) {
                  return Container(
                    padding: const EdgeInsets.only(top: 20),
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
                              "Pembayaran Para Pendana",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "UMKM ${bayarProvider.nama}",
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
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 70),
                          child: Row(
                            children: [
                              Text(
                                "Dana yang harus dibayar",
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
                                "Rp ${bayarProvider.sisa_pembayaran}",
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
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 30),
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
                                  bayarProvider.setupdatesaku(0);
                                } else {
                                  int nilai = int.parse(text);
                                  bayarProvider.setupdatesaku(nilai);
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
                              ),
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
                                  width: double.infinity,
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Saku Modal In',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
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
                                      //             fontSize: 14,
                                      //             fontWeight: FontWeight.w400,
                                      //           ),
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
                                                  'Rp ${bayarProvider.saku}',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color.fromRGBO(
                                                        0, 177, 71, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
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
                                    bayarProvider.validateForm();
                                    if (bayarProvider.updatesaku >
                                        bayarProvider.saku) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Warning'),
                                            content: Text(
                                                'Gagal melukukan pembayaran, pastikan dana mencukupi'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  bayarProvider
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
                                    } else if (bayarProvider.validationError ==
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
                                                  bayarProvider
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
                                    } else if (bayarProvider.updatesaku >
                                        bayarProvider.sisa_pembayaran) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Warning'),
                                            content: Text(
                                                'Pembayaran lebih dari yang seharusnya'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  bayarProvider
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
                                            backgroundColor: Color.fromRGBO(
                                                191, 220, 174, 1),
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    'Konfirmasi Pembayaran',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  iconSize: 15,
                                                  icon: Icon(Icons.close),
                                                  onPressed: () {
                                                    bayarProvider
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
                                                  'Anda yakin untuk melakukan pembayaran?',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 30),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      bayarProvider
                                                          .setDataFetched(
                                                              false);
                                                      bayarProvider.patchSaku();
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return BorrowerSuccessPayment();
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
                                                              .all(
                                                                  Colors.white),
                                                      minimumSize:
                                                          MaterialStateProperty
                                                              .all(Size(
                                                                  230, 40)),
                                                      padding:
                                                          MaterialStateProperty
                                                              .all(EdgeInsets
                                                                  .all(10)),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5),
                                                          child: Text(
                                                            "Lanjut Bayar",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5),
                                                          child: Text(
                                                            "Rp. " +
                                                                bayarProvider
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
                                  child: Text(
                                    'LANJUTKAN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })));
  }
}
