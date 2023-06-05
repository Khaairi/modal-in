import 'package:flutter/material.dart';
import 'borrower-home.dart';
// import 'borrower-wallet.dart';

class BorrowerSuccessTopup extends StatelessWidget {
  const BorrowerSuccessTopup({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Tambahkan ini untuk menghilangkan banner debug
      theme: ThemeData(primarySwatch: Colors.teal),
      // title: "Modal In | Register Borrower",
      home: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 300),
                child: Column(
                  children: [
                    Image.asset(
                      'images/checkmark.png',
                      width: 150,
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "ISI SALDO BERHASIL!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "dd mm yyyy - hh:mmm:ss UTC",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(0, 0, 30, 40), // Ubah padding di sini
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return BorrowerPage(id: id);
                        }));
                      },
                      child: Row(
                        children: [
                          Text(
                            "Lanjutkan",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios),
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
    );
  }
}
