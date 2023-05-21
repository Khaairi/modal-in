import 'package:flutter/material.dart';
import 'borrower-form-umkm.dart';

class EmailVerificationBorrower extends StatelessWidget {
  const EmailVerificationBorrower({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Modal In | Register Borrower",
        theme: ThemeData(primarySwatch: Colors.teal),
        home: Scaffold(
            body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
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
                  ),
                  Text(
                    "Verifikasi Email",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Text(
                          "Step 2 of 3",
                          style: TextStyle(
                              fontSize: 17, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'images/mail-checkmark.png',
                    width: 350,
                    height: 350,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                      "Kami mengirimkan kode verifikasi ke",
                      style:
                          TextStyle(fontSize: 17, color: Colors.grey.shade600),
                    ),
                  ),
                  Text(
                    "aceng@gmail.com",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Kode Verifikasi',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Text("Belum Dapat Kode?", style: TextStyle(
                  //         fontSize: 17,
                  //         fontWeight: FontWeight.w500
                  //       ),
                  //     ),
                  //     Text("Kirim Ulang", style: TextStyle(
                  //         fontSize: 17,
                  //         fontWeight: FontWeight.w500
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: [
                        Text(
                          "Belum Dapat Kode?",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Kirim Ulang",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return FormulirUMKM();
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            minimumSize: Size(200, 50),
                            backgroundColor: Color.fromRGBO(32, 106, 93, 1),
                            foregroundColor: Colors.white),
                        child: Text(
                          "VERIFIKASI",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        )));
  }
}
