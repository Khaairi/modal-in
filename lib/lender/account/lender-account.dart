import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:tubes_riil/login-page.dart';
import 'lender-cs.dart';
import 'lender-delete-account.dart';

class LenderAccountProvider extends ChangeNotifier {
  bool _isDataFetched = false;
  String? _token = "";
  int _saku = 0;
  String _status = "";
  String _nama = "";
  String _nomor = "";
  String _email = '';
  String _validationError = "";

  String get validationError => _validationError;
  String get status => _status;
  int get saku => _saku;
  String get nama => _nama;
  String get nomor => _nomor;
  String get email => _email;

  void setNama(String value) {
    _nama = value;
  }

  void setNomor(String value) {
    _nomor = value;
  }

  void setEmail(String value) {
    _email = value;
  }

  void setSaku(int value) {
    _saku = value;
  }

  void setDataFetched(bool value) {
    _isDataFetched = value;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('status');
    notifyListeners();
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

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      // Parse the response and extract the saku data
      final data = json.decode(response.body);
      _status = data['status'];
      _saku = data['saku'];
      _nama = data["nama"];
      _nomor = data["telp"];
      _email = data["email"];
      _isDataFetched = true;
      // print(_status);

      notifyListeners();
    } else {
      // Handle error case if needed
      throw Exception('Failed to fetch saku data');
    }
  }

  bool validateForm() {
    if (_nama.isEmpty || _email.isEmpty || _nomor.isEmpty) {
      _validationError = 'kosong';
    } else {
      _validationError = '';
    }
    notifyListeners();
    return _validationError.isEmpty;
  }

  Future<void> patchAkun() async {
    if (validateForm()) {
      _token = await getToken();

      final url = Uri.parse('http://127.0.0.1:8000/update_lender_patch/');
      final response = await http.patch(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $_token',
          },
          body: json.encode({
            'nama': _nama,
            'email': _email,
            'telp': _nomor,
          }));
      if (response.statusCode == 200) {
        print("terupdate");
      } else {
        print("gagal");
      }
    }
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);
  //String selectedOption;
  @override
  Widget build(BuildContext context) {
    final lenderAccountProvider = Provider.of<LenderAccountProvider>(context);
    TextEditingController namaController = TextEditingController();
    namaController.text = lenderAccountProvider.nama;
    TextEditingController nomorController = TextEditingController();
    nomorController.text = lenderAccountProvider.nomor;
    TextEditingController emailController = TextEditingController();
    emailController.text = lenderAccountProvider.email;
    // String selectedOption;
    return Scaffold(
        // backgroundColor: Color.fromRGBO(191, 220, 174, 1),
        body: FutureBuilder(
            future: Provider.of<LenderAccountProvider>(context, listen: false)
                .fetchData(),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 0, top: 0),
                        width: 400,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(32, 106, 93, 1),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                // backgroundImage: AssetImage(
                                //     'assets/profile_image.jpg'), // Ganti dengan path gambar profil Anda
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 36),
                                Text(
                                  '${lenderAccountProvider.nama}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Rp.${lenderAccountProvider.saku}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),

                      ExpansionTile(
                        tilePadding: EdgeInsets.only(left: 40, right: 40),
                        title: Container(
                          child: Text(
                            'Informasi Akun',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          padding: EdgeInsets.only(bottom: 10),
                          //SizedBox(height: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: const Color.fromARGB(255, 216, 215, 215),
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                        children: [
                          Container(
                            padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(191, 220, 174, 1),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  width: 10.0),
                              borderRadius: BorderRadius.circular(20.0),
                              //  image: const EdgeInsets.only(left: 30),
                            ),
                            child: Column(
                              //   margin: EdgeInsets.only(),
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: namaController,
                                  onChanged: (value) {
                                    lenderAccountProvider.setNama(value);
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Nama',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: nomorController,
                                  onChanged: (value) {
                                    lenderAccountProvider.setNomor(value);
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Nomor telepon',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  enabled: false,
                                  controller: emailController,
                                  onChanged: (value) {
                                    lenderAccountProvider.setEmail(value);
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                // SizedBox(height: 15),
                                // TextFormField(
                                //   decoration: InputDecoration(
                                //     labelText: 'Password',
                                //     labelStyle: TextStyle(
                                //         fontFamily: 'Arial',
                                //         fontSize: 15,
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.black),
                                //   ),
                                // ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        lenderAccountProvider.validateForm();
                                        if (lenderAccountProvider
                                                .validationError ==
                                            "kosong") {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Warning'),
                                                content: Text(
                                                    'Data Tidak Boleh Kosong'),
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
                                          lenderAccountProvider.patchAkun();
                                        }
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color.fromRGBO(32, 106, 93, 1)),
                                        minimumSize: MaterialStateProperty.all(
                                            Size(150, 40)),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.all(10)),
                                      ),
                                      child: Text(
                                        'UBAH',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          //
                          // SizedBox(height: 20),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 7,
                        color: Color.fromRGBO(191, 220, 174, 1),
                      ),
                      Container(
                        width: 400,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return HelpPage();
                            }));
                          },

                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 255, 255,
                                255), // Ubah warna latar belakang tombol
                            onPrimary: Color.fromARGB(
                                255, 0, 0, 0), // Ubah warna teks tombol
                            textStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            // Ubah ukuran teks tombol
                            padding: EdgeInsets.only(
                                left: 40,
                                right: 40), // Ubah padding horizontal tombol

                            shadowColor: Colors.transparent,
                          ),
                          //
                          // icon: Icon(Icons.arrow_forward),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // margin: EdgeInsets.only(left: 40, right: 40),
                            children: [
                              Text('Customer Service'),
                              Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 40, right: 77, top: 1, bottom: 8),
                        height: 1,
                        color: Color.fromARGB(255, 216, 215, 215),
                      ),

                      // Container(
                      //   margin: EdgeInsets.symmetric(vertical: 10),
                      //   height: 7,
                      //   color: Color.fromRGBO(191, 220, 174, 1),
                      // ),
                      // ExpansionTile(
                      //   tilePadding: EdgeInsets.only(left: 40, right: 40),
                      //   title: Container(
                      //     child: Text(
                      //       'Pengaturan',
                      //       style: TextStyle(
                      //           fontSize: 20, fontWeight: FontWeight.bold),
                      //     ),
                      //     padding: EdgeInsets.only(bottom: 10),
                      //     decoration: BoxDecoration(
                      //       border: Border(
                      //         bottom: BorderSide(
                      //           color: const Color.fromARGB(255, 216, 215, 215),
                      //           width: 1.0,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 10),
                      Container(
                        color: Color.fromRGBO(191, 220, 174, 1),
                        padding: EdgeInsets.only(
                            left: 90, right: 90, top: 70, bottom: 90),
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                lenderAccountProvider.setDataFetched(false);
                                lenderAccountProvider.logout();
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return LoginPage();
                                }));
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(32, 106, 93, 1)),
                                minimumSize:
                                    MaterialStateProperty.all(Size(290, 40)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(10)),
                              ),
                              child: Text('KELUAR'),
                            ),
                            SizedBox(height: 10),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     // Navigator.of(context)
                            //     //     .push(MaterialPageRoute(builder: (context) {
                            //     //   return DeleteAccountPage();
                            //     // }));
                            //     showDialog(
                            //       context: context,
                            //       builder: (BuildContext context) {
                            //         return AlertDialog(
                            //           title: Text('Konfirmasi'),
                            //           content: Text(
                            //               'Apakah Anda yakin ingin menghapus akun ini?'),
                            //           actions: [
                            //             TextButton(
                            //               onPressed: () {
                            //                 // Aksi saat tombol "Hapus" ditekan
                            //                 // Misalnya, panggil fungsi untuk menghapus data
                            //                 Navigator.of(context)
                            //                     .pop(); // Tutup dialog
                            //               },
                            //               child: Text('Hapus'),
                            //             ),
                            //             TextButton(
                            //               onPressed: () {
                            //                 // Aksi saat tombol "Batal" ditekan
                            //                 // Misalnya, kembali ke tampilan sebelumnya tanpa melakukan tindakan apa pun
                            //                 Navigator.of(context)
                            //                     .pop(); // Tutup dialog
                            //               },
                            //               child: Text('Batal'),
                            //             ),
                            //           ],
                            //         );
                            //       },
                            //     );
                            //   },
                            //   style: ButtonStyle(
                            //     shape: MaterialStateProperty.all<
                            //         RoundedRectangleBorder>(
                            //       RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(25),
                            //       ),
                            //     ),
                            //     backgroundColor: MaterialStateProperty.all(
                            //         Color.fromRGBO(217, 6, 6, 1)),
                            //     minimumSize:
                            //         MaterialStateProperty.all(Size(280, 40)),
                            //     padding: MaterialStateProperty.all(
                            //         EdgeInsets.all(10)),
                            //   ),
                            //   child: Text('HAPUS AKUN '),
                            // ),
                          ],
                        ),
                      ),

                      // SizedBox(height: 30),
                      //  ),
                    ],
                  ),
                ),
              );
            }));
  }
}
