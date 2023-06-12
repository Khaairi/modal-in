import 'package:flutter/material.dart';
import 'lender-home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePageBefore(),
    );
  }
}

class HomePageBefore extends StatelessWidget {
  const HomePageBefore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Halo, ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                  ),
                ),
                TextSpan(
                  text: 'pendana',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ButtonNotification(),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(
                  "images/background-opacity.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(32, 106, 93, 1), width: 1),
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
                              fontSize: 28),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Rp. 100.000.000,00',
                          style: TextStyle(
                              color: Color.fromRGBO(0, 177, 71, 1),
                              fontWeight: FontWeight.normal,
                              fontSize: 20),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed("/pencairanDana");
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
                                MaterialStateProperty.all(Size(290, 50)),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(17)),
                          ),
                          child: Text('Cairkan Dana',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 3, left: 22),
                      child: Text(
                        'Progress Pendanaan',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(16, 5, 16, 7),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(32, 106, 93, 1), width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PENDANAAN',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'HASIL DITERIMA\nRp. 0',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'DANA DIMILIKI\nRp. 0',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'TOTAL PENDANAAN AKTIF\nRp. 0',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 3, left: 22),
                      child: Text(
                        'Daftar Mitra',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
                // Column(
                //   children: [
                //     for (int i = 0; i < 5; i++)
                //       Padding(
                //           padding: const EdgeInsets.only(top: 10),
                //           child: InkWell(
                //             onTap: () {
                //               Navigator.of(context).pushNamed("/detailsMarket");
                //             },
                //             child: Container(
                //               width: double.infinity,
                //               padding: EdgeInsets.fromLTRB(16, 5, 16, 7),
                //               margin: EdgeInsets.symmetric(horizontal: 20),
                //               decoration: BoxDecoration(
                //                 border: Border.all(
                //                     color: Color.fromRGBO(32, 106, 93, 1),
                //                     width: 1),
                //                 borderRadius: BorderRadius.circular(10),
                //               ),
                //               child: Row(children: [
                //                 Icon(
                //                   Icons.festival_outlined,
                //                   color: Color.fromRGBO(32, 106, 93, 1),
                //                   size: 60,
                //                 ),
                //                 Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 20),
                //                       child: Text(
                //                         "Nama UMKM",
                //                         style: TextStyle(
                //                             color: Colors.black,
                //                             fontWeight: FontWeight.bold,
                //                             fontSize: 15),
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 20),
                //                       child: Text(
                //                         "Kategori",
                //                         style: TextStyle(
                //                             color: Colors.black,
                //                             fontWeight: FontWeight.w100,
                //                             fontSize: 11),
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(
                //                           left: 20, top: 5, bottom: 5),
                //                       child: Text(
                //                         "Total Pinjaman: Rp. xxx.xxx,00",
                //                         style: TextStyle(
                //                             color: Colors.black,
                //                             fontWeight: FontWeight.w400,
                //                             fontSize: 12),
                //                       ),
                //                     ),
                //                   ],
                //                 )
                //               ]),
                //             ),
                //           )),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Text("Anda belum memiliki mitra yang didanai",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 13)),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 3, left: 22),
                      child: Text(
                        'Rekomendasi Mitra untuk Anda',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    child: Row(children: [
                      for (int i = 0; i < 10; i++)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("/detailsMarket");
                          },
                          child: Container(
                            // padding: EdgeInsets.only(left: 10, right: 15, top: 10),
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Image.asset(
                                      'images/banner.jpeg',
                                      height: 100,
                                      width: 200,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 5),
                                    child: Text(
                                      "Nama UMKM",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Kategori",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w100,
                                          fontSize: 8),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Membutuhkan dana",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 10),
                                    child: Text(
                                      "Rp XX.XXX.XXX,00",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                ]),
                          ),
                        )
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
