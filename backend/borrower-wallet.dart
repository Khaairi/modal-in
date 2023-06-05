import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'borrower-isi-saldo.dart';
import 'borrower-pembayaran.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'borrower-pencairan-dana.dart';

class SakuProvider extends ChangeNotifier {
  int _saku = 0;
  bool _isDataFetched = false;

  int get saku => _saku;
  void setDataFetched(bool value) {
    _isDataFetched = value;
  }

  Future<void> fetchData(int id) async {
    if (_isDataFetched) {
      // Data has already been fetched, no need to fetch again
      return;
    }
    // Make API request to fetch the saku data
    // Replace 'apiEndpoint' with your actual API endpoint
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/borrowers/$id'));

    if (response.statusCode == 200) {
      // Parse the response and extract the saku data
      final data = json.decode(response.body);
      final sakuData = data['saku'];
      _isDataFetched = true;
      // Update the _saku variable and notify listeners
      _saku = sakuData;
      notifyListeners();
    } else {
      // Handle error case if needed
      throw Exception('Failed to fetch saku data');
    }
  }
}

class WalletPage extends StatelessWidget {
  const WalletPage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  Widget build(BuildContext context) {
    final sakuProvider = Provider.of<SakuProvider>(context);
    int currentIndex = 2;

    void onItemTap(int index) {
      // No state changes in StatelessWidget
    }

    return Scaffold(
      body: FutureBuilder(
          // future: sakuProvider.fetchData(id),
          future:
              Provider.of<SakuProvider>(context, listen: false).fetchData(id),
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(32, 106, 93, 1),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total Aset Saya',
                          style: TextStyle(
                            color: Color.fromRGBO(32, 106, 93, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Rp.  ${sakuProvider.saku}',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 177, 71, 1),
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No. VA: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'xxxxxxxxx',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.copy),
                              iconSize: 15,
                              onPressed: () {
                                // Action to copy text
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          sakuProvider.setDataFetched(false);
                          // print("halohalo $id");
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return IsiSaldoBorrower(
                              id: id,
                            );
                          }));
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          minimumSize: MaterialStateProperty.all(Size(120, 50)),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(17)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'images/icon-isi-saldo.png',
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Isi Saldo',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          sakuProvider.setDataFetched(false);
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return PembayaranBorrower();
                          }));
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          minimumSize: MaterialStateProperty.all(Size(120, 50)),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(17)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'images/icon-danai.png',
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Bayar',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          sakuProvider.setDataFetched(false);
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return PencairanDanaBorrower(id: id);
                          }));
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          minimumSize: MaterialStateProperty.all(Size(120, 50)),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(17)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'images/icon-Cairkan.png',
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Cairkan',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
