import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'borrower-isi-saldo.dart';
import 'borrower-pembayaran.dart';
import 'borrower-pencairan-dana.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentIndex = 2;

    void onItemTap(int index) {
      // No state changes in StatelessWidget
    }

    return Scaffold(
      // appBar: AppBar(
      // //   actions: <Widget>[
      // //     ButtonNotification(),
      // //   ],
      // //   backgroundColor: Colors.white,
      // //   elevation: 0,
      // ),
      body: Padding(
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
                    'Rp. 100.000.000,00',
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return IsiSaldoBorrower();
                    }));
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    elevation: MaterialStateProperty.all(0),
                    minimumSize: MaterialStateProperty.all(Size(120, 50)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(17)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'icons/icon-isi-saldo.png',
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return PembayaranBorrower();
                    }));
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    elevation: MaterialStateProperty.all(0),
                    minimumSize: MaterialStateProperty.all(Size(120, 50)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(17)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'icons/icon-danai.png',
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
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return PencairanDanaBorrower();
                    }));
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    elevation: MaterialStateProperty.all(0),
                    minimumSize: MaterialStateProperty.all(Size(120, 50)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(17)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'icons/icon-Cairkan.png',
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
      ),
    );
  }
}
