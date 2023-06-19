import 'package:flutter/material.dart';
import 'package:tubes_riil/login-page.dart';
import 'borrower-cs.dart';
import 'borrower-delete-account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class Umkm {
  final String nama;
  final String kategori;
  final int penghasilan;
  final String alamat;
  Umkm(
      {required this.nama,
      required this.kategori,
      required this.penghasilan,
      required this.alamat});
  factory Umkm.fromJson(Map<String, dynamic> json) {
    return Umkm(
      nama: json['nama'] ?? '',
      kategori: json['kategori'] ?? '',
      penghasilan: json['penghasilan'] ?? '',
      alamat: json['alamat'] ?? '',
    );
  }
  @override
  String toString() {
    return '(name: $nama, kategori: $kategori, penghasilan : $penghasilan)';
  }
}

class BorrowerAccountProvider extends ChangeNotifier {
  bool _isDataFetched = false;
  String? _token = "";
  String _status = "";
  String _nama = '';
  String _nomor = '';
  String _email = '';
  String _validationError = "";
  int _saku = 0;
  List<Umkm> _listumkm = [];
  Umkm _umkm = Umkm(nama: '', kategori: '', penghasilan: 0, alamat: '');

  int get saku => _saku;
  String get nomor => _nomor;
  String get email => _email;
  String get status => _status;
  String get nama => _nama;
  Umkm get umkm => _umkm;
  String get validationError => _validationError;
  void setNama(String value) {
    _nama = value;
  }

  void setNomor(String value) {
    _nama = value;
  }

  void setEmail(String value) {
    _nama = value;
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
    final url = Uri.parse('http://127.0.0.1:8000/borrower/me/');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      // Parse the response and extract the saku data
      final data = json.decode(response.body);
      _status = data['status'];
      _nama = data['nama'];
      _saku = data['saku'];
      _email = data['email'];
      _nomor = data['telp'];
      _listumkm = [];
      final umkmDataList = data['umkm'];
      for (var umkmData in umkmDataList) {
        var umkm = Umkm.fromJson(umkmData);
        _listumkm.add(umkm);
      }
      _umkm = Umkm(
          nama: _listumkm[0].nama,
          kategori: _listumkm[0].kategori,
          penghasilan: _listumkm[0].penghasilan,
          alamat: _listumkm[0].alamat);
      print("terkadung");
      print(_umkm.nama);

      _isDataFetched = true;

      final url2 = Uri.parse('http://127.0.0.1:8000/borrower/market/');
      final response2 = await http.get(url, headers: {
        'Authorization': 'Bearer $_token',
      });
      if (response2.statusCode == 200) {
        final data2 = json.decode(response2.body);
      } else {
        print("gagal fetch market");
      }

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

      final url = Uri.parse('http://127.0.0.1:8000/update_borrower_patch/');
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
    final borrowerAccountProvider =
        Provider.of<BorrowerAccountProvider>(context);
    TextEditingController namaController = TextEditingController();
    namaController.text = borrowerAccountProvider.nama;
    TextEditingController nomorController = TextEditingController();
    nomorController.text = borrowerAccountProvider.nomor;
    TextEditingController emailController = TextEditingController();
    emailController.text = borrowerAccountProvider.email;
    TextEditingController textEditingController1 = TextEditingController();
    TextEditingController textEditingController2 = TextEditingController();
    TextEditingController textEditingController3 = TextEditingController();
    TextEditingController textEditingController4 = TextEditingController();

    textEditingController1.text = borrowerAccountProvider.umkm.nama;
    textEditingController2.text = borrowerAccountProvider.umkm.alamat;
    textEditingController3.text = borrowerAccountProvider.umkm.kategori;
    textEditingController4.text =
        borrowerAccountProvider.umkm.penghasilan.toString();
    // String selectedOption;
    return Scaffold(
        // backgroundColor: Color.fromRGBO(191, 220, 174, 1),
        body: FutureBuilder(
            future: Provider.of<BorrowerAccountProvider>(context, listen: false)
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
                                  '${borrowerAccountProvider.nama}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Rp.${borrowerAccountProvider.saku}',
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
                                    borrowerAccountProvider.setNama(value);
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
                                    borrowerAccountProvider.setNomor(value);
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
                                    borrowerAccountProvider.setEmail(value);
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
                                        borrowerAccountProvider.validateForm();
                                        if (borrowerAccountProvider
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
                                          borrowerAccountProvider.patchAkun();
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
                      ExpansionTile(
                        tilePadding: EdgeInsets.only(left: 40, right: 40),
                        //  color: Color(0xFF208A5D),
                        title: Container(
                          child: Text(
                            'Portofolio',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          padding: EdgeInsets.only(bottom: 10),
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
                              color: const Color.fromRGBO(191, 220, 174, 1),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  width: 10.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextFormField(
                                  enabled: false,
                                  controller: textEditingController1,
                                  decoration: InputDecoration(
                                    labelText: 'Nama',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  enabled: false,
                                  controller: textEditingController2,
                                  decoration: InputDecoration(
                                    labelText: 'Alamat',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  enabled: false,
                                  controller: textEditingController3,
                                  decoration: InputDecoration(
                                    labelText: 'Kategori',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  enabled: false,
                                  controller: textEditingController4,
                                  decoration: InputDecoration(
                                    labelText: 'Penghasilan',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                            // Navigator.pushNamed(context, '/helpCs');
                            borrowerAccountProvider.setDataFetched(false);
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

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 7,
                        color: Color.fromRGBO(191, 220, 174, 1),
                      ),
                      SizedBox(height: 10),
                      Container(
                        color: Color.fromRGBO(191, 220, 174, 1),
                        padding: EdgeInsets.only(
                            left: 90, right: 90, top: 70, bottom: 90),
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                borrowerAccountProvider.setDataFetched(false);
                                borrowerAccountProvider.logout();
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
                            //     // Navigator.of(context).pushNamed("/deleteAcc");
                            //     borrowerAccountProvider.setDataFetched(false);
                            //     Navigator.of(context)
                            //         .push(MaterialPageRoute(builder: (context) {
                            //       return DeleteAccountPage();
                            //     }));
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
