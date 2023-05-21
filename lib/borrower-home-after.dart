import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  List<Widget> pages = [
    HomePage(),
    ActivityPage(),
    WalletPage(),
    AccountPage(),
  ];
  @override
  void initState() {
    super.initState();
  }

  int idx = 0; //index yang aktif
  void onItemTap(int index) {
    setState(() {
      idx = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Borrower',
      home: Scaffold(
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
                  text: 'Peminjam',
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
        body: pages[idx],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: idx,
          onTap: onItemTap,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grading_sharp, color: Colors.black),
              label: 'Activity',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet, color: Colors.black),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.black),
              label: 'Account',
            ),
          ],
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
        ),
      ),
      routes: {
        '/sec': (context) => AjukanPage(),
        '/third': (context) => CaraPage(),
        '/success': (context) => HalamanUtama(),
      },
    );
  }
}

class ButtonNotification extends StatelessWidget {
  const ButtonNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.circle_notifications, color: Colors.black, size: 30),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage()),
        );
      },
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Notification Page',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Text(
          'Halaman Notifikasi',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 // decoration: BoxDecoration(border: Border.all()),
//                 padding: EdgeInsets.only(top: 15),
//                 child: Text(
//                   'Rencanakan',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.only(top: 15),
//                 child: Text(
//                   ' Masa',
//                   style: TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30),
//                 ),
//               ),
//             ],
//           ),
//           //  SizedBox(height: 0),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: EdgeInsets.only(top: 3),
//                 // decoration: BoxDecoration(border: Border.all()),
//                 //  padding: EdgeInsets.all(10),
//                 child: Text(
//                   'depan',
//                   style: TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.only(top: 3),
//                 child: Text(
//                   ' Bisnismu',
//                   style: TextStyle(
//                       color: const Color.fromARGB(255, 0, 0, 0),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 // decoration: BoxDecoration(border: Border.all()),
//                 padding: const EdgeInsets.all(14),
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/sec');
//                         },
//                         style: ButtonStyle(
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                   25), // Mengatur sudut melengkung
//                             ),
//                           ),
//                           backgroundColor:
//                               MaterialStateProperty.all(Colors.green),
//                           minimumSize: MaterialStateProperty.all(Size(290, 50)),
//                           padding:
//                               MaterialStateProperty.all(EdgeInsets.all(17)),
//                         ),
//                         child: Text('AJUKAN PINJAMAN',
//                             style:
//                                 TextStyle(fontSize: 17, color: Colors.white)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 5),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 padding: EdgeInsets.only(top: 3, left: 15),
//                 // decoration: BoxDecoration(border: Border.all()),
//                 //  padding: EdgeInsets.all(10),
//                 child: Text(
//                   'Bingung cara',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 padding: EdgeInsets.only(top: 3, left: 15),
//                 // decoration: BoxDecoration(border: Border.all()),
//                 //  padding: EdgeInsets.all(10),
//                 child: Text(
//                   'Memulai pinjaman?',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 17),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 // decoration: BoxDecoration(border: Border.all()),
//                 padding: const EdgeInsets.all(14),
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/third');
//                         },
//                         style: ButtonStyle(
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                   25), // Mengatur sudut melengkung
//                             ),
//                           ),
//                           backgroundColor:
//                               MaterialStateProperty.all(Colors.green),
//                           minimumSize: MaterialStateProperty.all(Size(290, 50)),
//                           padding:
//                               MaterialStateProperty.all(EdgeInsets.all(17)),
//                         ),
//                         child: Text('CARA MELAKUKAN PINJAMAN',
//                             style:
//                                 TextStyle(fontSize: 17, color: Colors.white)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 padding: EdgeInsets.only(top: 3, left: 15),
//                 // decoration: BoxDecoration(border: Border.all()),
//                 //  padding: EdgeInsets.all(10),
//                 child: Text(
//                   'Apa kata mereka?',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 25),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(left: 150),
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 9,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Center(
//                     child: Container(
//                       width: 240,
//                       height: 240,
//                       margin: EdgeInsets.symmetric(horizontal: 15),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color.fromARGB(255, 71, 38, 38)
//                                 .withOpacity(0.3),
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                             offset: Offset(5, 3),
//                           ),
//                         ],
//                       ),
//                       child: Center(
//                         child: Text(
//                           '${index + 1}/9',
//                           style: TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),

//           SizedBox(height: 80),
//         ],
//       ),
//     );
//   }
// }

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                width: 370,
                height: 200,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green, width: 2)),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total Penerimaan',
                      style: TextStyle(
                        color: Color.fromARGB(255, 19, 95, 22),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Rp. 0',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Aksi ketika tombol ditekan
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(205, 6, 94, 19),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'CAIRKAN PINJAMAN',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                width: 370,
                height: 150,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green, width: 2)),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sisa Pembayaran',
                      style: TextStyle(
                        color: Color.fromARGB(255, 19, 95, 22),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Rp. 0',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 23, left: 15),
                child: Text(
                  'Jadwal Pembayaran',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                width: 370,
                height: 60,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 241, 212),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          'Bayar Sebelum dd-mm-yyyy',
                          style: TextStyle(
                            color: Color.fromARGB(255, 19, 95, 22),
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          // Aksi ketika tombol ditekan
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 247, 247, 247),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                                color: const Color.fromARGB(255, 19, 83, 21)),
                          ),
                          minimumSize: Size(80, 40),
                        ),
                        child: Text(
                          'Bayar',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//buat Form Ajukan sama pop up Kalkulator (belum finish pop up nya)
class AjukanPage extends StatelessWidget {
  const AjukanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromARGB(255, 254, 254, 254),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  'Form Pengajuan',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 1),
                child: Text(
                  ' Pinjaman',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(40),
              children: [
                FormColumn(
                  label: '',
                  text: 'Besar Biaya',
                ),
                SizedBox(height: 10),
                FormColumn(
                  label: '*dalam minggu',
                  text: 'Tenor Pendanaan',
                ),
                SizedBox(height: 10),
                FormColumn(
                  label: '',
                  text: 'Minimal Biaya',
                ),
                SizedBox(height: 10),
                DropdownFormField(
                  label: '',
                  // text: 'Opsi Pengembalian',
                  options: ['Option 1', 'Option 2', 'Option 3'],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 55, left: 130),
                  // left: 0,
                  // right: 200,
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
                        icon: Icon(Icons.calculate_rounded,
                            size: 30,
                            color: const Color.fromARGB(255, 7, 7, 7)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(255, 193, 237, 195),
                                title: Row(
                                  children: [
                                    Text('Kalkulator Pinjaman'),
                                    SizedBox(width: 5),
                                    // Text(
                                    //   '(Addition)',
                                    //   style: TextStyle(
                                    //       fontSize: 14, color: Colors.grey),
                                    // ),
                                    // Container(
                                    //   margin: EdgeInsets.only(top: 30),
                                    //   child: Text(
                                    //     'Kalkulator Peminjaman',
                                    //     style: TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.normal,
                                    //       color: Colors.black,
                                    //     ),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   margin: EdgeInsets.only(top: 70, left: 4),
                                    //   child: Text(
                                    //     'Teks Baru',
                                    //     style: TextStyle(
                                    //       fontSize: 14,
                                    //       fontWeight: FontWeight.normal,
                                    //       color: Colors.black,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                          labelText: 'Number 1'),
                                      keyboardType: TextInputType.number,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          labelText: 'Number 2'),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Calculate'),
                                    onPressed: () {
                                      // Perform calculation
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
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
          Container(
            margin: EdgeInsets.only(bottom: 150),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/success');
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25), // Mengatur sudut melengkung
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.green),
                minimumSize: MaterialStateProperty.all(Size(320, 50)),
                padding: MaterialStateProperty.all(EdgeInsets.all(10)),
              ),
              child: Text('AJUKAN PINJAMAN',
                  style: TextStyle(fontSize: 17, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}

class DropdownFormField extends StatefulWidget {
  final String label;
  final List<String> options;

  const DropdownFormField({
    required this.label,
    required this.options,
    Key? key,
  }) : super(key: key);

  @override
  _DropdownFormFieldState createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends State<DropdownFormField> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedOption,
          onChanged: (newValue) {
            setState(() {
              selectedOption = newValue;
            });
          },
          decoration: InputDecoration(
            hintText: selectedOption ?? 'Opsi Pengembalian',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 0, 0, 0),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 130, 128, 128),
                width: 1.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
          ),
          items: widget.options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class FormColumn extends StatelessWidget {
  final String label;
  final String text;

  const FormColumn({
    Key? key,
    required this.label,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromARGB(255, 54, 51, 51),
          ),
        ),
        TextFormField(
          initialValue: text,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ],
    );
  }
}

//button cara melakukan pinjaman (finish)
class CaraPage extends StatelessWidget {
  const CaraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromARGB(255, 254, 254, 254),
        title: Text(
          'Bantuan',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'Cara Mengajukan',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // decoration: BoxDecoration(border: Border.all()),
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'Pinjaman',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 0),
                    child: Text(
                      ' di Modal In',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // decoration: BoxDecoration(border: Border.all()),
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'Borrowers, sebelum meminjam pastikan kalian',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // decoration: BoxDecoration(border: Border.all()),
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'sudah bla bla bla loerm impsinm dan kawan',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 18, top: 25),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 14, 107, 28),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 25),
                    child: Text(
                      'Pertama kalian harus bla bla bla bla bla ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 85, top: 10),
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 186, 228, 170),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 18, top: 25),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 14, 107, 28),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        '2',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 25),
                    child: Text(
                      'Kedua kalian harus bla bla bla bla bla ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 85, top: 10),
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 186, 228, 170),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 0, top: 55),
                    width: 350,
                    height: 130,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 30, 124, 77),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Icon(
                            Icons.message_outlined,
                            color: Colors.white,
                            size: 55,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Masih punya',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              Text(
                                'Pertanyaan ?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              Text(
                                'Mulai chat dengan',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17),
                              ),
                              Text(
                                'Orang kami',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17),
                              ),
                            ],

                            //'Masih punya',
                            // style: TextStyle(
                            //     color: Colors.white,
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 15),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.pushNamed(context, '/sec');
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
                                  const Color.fromARGB(255, 255, 255, 255)),
                              minimumSize:
                                  MaterialStateProperty.all(Size(110, 40)),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(10)),
                            ),
                            child: Text('Mulai Chat',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 56, 134, 44))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//buat disatuin sama zul (button navbar udh aman, tinggal tambahin aja semua kodingannya disisi)
class ActivityPage extends StatelessWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity'),
      ),
      body: Center(
        child: Text('Halaman Activity'),
      ),
    );
  }
}

//sama, disatuin sama yg zul
class WalletPage extends StatelessWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
      ),
      body: Center(
        child: Text('Halaman Wallet'),
      ),
    );
  }
}

//belum keburu
class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Center(
        child: Text('Halaman Account'),
      ),
    );
  }
}

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal),
        title: "Modal In | Register Borrower",
        home: Scaffold(
          body: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'images/checkmark.png',
                  width: 150,
                  height: 150,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Pengajuan Berhasil",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 30, 20),
                    child: Stack(
                      children: [
                        Text(
                          "Lanjutkan",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
