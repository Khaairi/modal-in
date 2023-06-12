import 'package:flutter/material.dart';

class EmailVerificationLender extends StatelessWidget {
  const EmailVerificationLender({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Modal In | Register Borrower",
        debugShowCheckedModeBanner: false,
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
            body: Center(
              child: Container(
                // decoration: const BoxDecoration(
                //   image: const DecorationImage(
                //     image: AssetImage("images/background-opacity.png"),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child: SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Verifikasi Email",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
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
                          Image.asset(
                            'images/mail-checkmark.png',
                            width: 350,
                            height: 350,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Text(
                              "Kami mengirimkan kode verifikasi ke",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.grey.shade600),
                            ),
                          ),
                          Text(
                            "aceng@gmail.com",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
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
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
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

                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 30),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed("/successAccLender");
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  minimumSize: Size(200, 50),
                                  backgroundColor:
                                      Color.fromRGBO(32, 106, 93, 1),
                                  foregroundColor: Colors.white),
                              child: Text(
                                "VERIFIKASI",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ),
            )));
  }
}
