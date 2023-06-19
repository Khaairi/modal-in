import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:tubes_riil/borrower/wallet/borrower-isi-saldo.dart';
import 'package:tubes_riil/borrower/wallet/borrower-pembayaran.dart';
import 'package:tubes_riil/borrower/wallet/borrower-pencairan-dana.dart';
import '../activity/borrower-activity.dart';
import '../wallet/borrower-wallet.dart';
import '../account/borrower-account.dart';
import 'borrower-ajukan-pinjaman.dart';
import 'borrower-tutorial-pinjaman.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';

class Pendanaan {
  final int total_pinjaman;
  final int market_id;
  final String status;
  final int id;
  final int lender_id;
  Pendanaan(
      {required this.total_pinjaman,
      required this.market_id,
      required this.status,
      required this.id,
      required this.lender_id});
  factory Pendanaan.fromJson(Map<String, dynamic> json) {
    return Pendanaan(
      total_pinjaman: json['total_pinjaman'] ?? '',
      status: json['status'] ?? '',
      market_id: json['market_id'] ?? '',
      id: json['id'] ?? '',
      lender_id: json['lender_id'] ?? '',
    );
  }
}

class Notification {
  final String title;
  final String deskripsi;
  String created_at;
  final String status;
  Notification(
      {required this.title,
      required this.deskripsi,
      required this.created_at,
      required this.status}) {
    final formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(created_at));
    created_at = formattedDate;
  }
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      title: json['title'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      created_at: json['created_at'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class NotificationProvider extends ChangeNotifier {
  bool _isDataFetched = false;
  String? _token = "";
  List<Notification> _listnotifikasi = [];

  List<Notification> get listnotifikasi => _listnotifikasi;
  void setDataFetched(bool value) {
    _isDataFetched = value;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchDataLender() async {
    if (_isDataFetched) {
      // Data has already been fetched, no need to fetch again
      return;
    }
    setDataFetched(true);

    _token = await getToken();
    final url = Uri.parse('http://127.0.0.1:8000/lender/notifikasi/');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      // Parse the response and extract the saku data
      final List<dynamic> responseData = jsonDecode(response.body);
      _listnotifikasi = responseData
          .map<Notification>((json) => Notification.fromJson(json))
          .toList();
      notifyListeners();
    } else {
      // Handle error case if needed
      throw Exception('Failed to fetch notification');
    }
  }

  Future<void> fetchData() async {
    if (_isDataFetched) {
      // Data has already been fetched, no need to fetch again
      return;
    }
    _listnotifikasi = [];
    setDataFetched(true);

    _token = await getToken();
    final url = Uri.parse('http://127.0.0.1:8000/borrower/notifikasi/');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      // Parse the response and extract the saku data
      final List<dynamic> responseData = jsonDecode(response.body);
      _listnotifikasi = responseData
          .map<Notification>((json) => Notification.fromJson(json))
          .toList();
      notifyListeners();
    } else {
      // Handle error case if needed
      throw Exception('Failed to fetch notification');
    }
  }
}

class Lender {
  final String nama;
  Lender({required this.nama});
  factory Lender.fromJson(Map<String, dynamic> json) {
    return Lender(
      nama: json['nama'] ?? '',
    );
  }
}

class BorrowerPageProvider extends ChangeNotifier {
  bool _isDataFetched = false;
  String? _token = "";
  String _status = "";
  String _nama = "";
  int _dana_terkumpul = 0;
  int _sisa_hari = 0;
  int _besar_biaya = 0;
  String _tenggat_pengembalian = '';
  int _sisa_pengembalian = 0;
  int _daritotal = 0;
  int _sudahmembayar = 0;
  String _bayarsebelum = '';
  String _statuspenggalangan = '';
  List<Pendanaan> _listpendanaan = [];
  List<Lender> _listpendana = [];
  List<Notification> _listnotifikasi = [];
  int _jumlahnotifikasi = 0;

  List<Notification> get listnotifikasi => _listnotifikasi;
  void setDataFetched(bool value) {
    _isDataFetched = value;
  }

  int get dana_terkumpul => _dana_terkumpul;
  int get sisa_hari => _sisa_hari;
  int get besar_biaya => _besar_biaya;
  String get status => _status;
  String get nama => _nama;
  String get tenggat_pengembalian => _tenggat_pengembalian;
  int get sisa_pengembalian => _sisa_pengembalian;
  int get daritotal => _daritotal;
  int get sudahmembayar => _sudahmembayar;
  String get bayarsebelum => _bayarsebelum;
  String get statuspenggalangan => _statuspenggalangan;
  List<Pendanaan> get listpendanaan => _listpendanaan;
  List<Lender> get listpendana => _listpendana;
  int get jumlahnotifikasi => _jumlahnotifikasi;

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

  Future<void> setNotifikasi() async {
    _token = await getToken();
    final url8 = Uri.parse('http://127.0.0.1:8000/borrower/notifikasi/read/');
    final response8 = await http.patch(url8, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $_token',
    });
    if (response8.statusCode == 200) {
      print("berhasil read");
      await fetchData();
      print("jumlah setelah dipencet ${_jumlahnotifikasi}");
    } else {
      // Handle error case if needed
      throw Exception('gagal read');
    }
  }

  Future<void> fetchData() async {
    if (_isDataFetched) {
      // Data has already been fetched, no need to fetch again
      return;
    }
    _jumlahnotifikasi = 0;
    _listnotifikasi = [];
    _token = await getToken();

    final url9 = Uri.parse('http://127.0.0.1:8000/borrower/notifikasi/');

    final response9 = await http.get(url9, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response9.statusCode == 200) {
      // Parse the response and extract the saku data
      final List<dynamic> responseData = jsonDecode(response9.body);
      _listnotifikasi = responseData
          .map<Notification>((json) => Notification.fromJson(json))
          .toList();
      notifyListeners();
      for (var data in _listnotifikasi) {
        if (data.status == "belum") {
          _jumlahnotifikasi += 1;
        }
      }
      print("jumlah notifika${jumlahnotifikasi}");
    } else {
      // Handle error case if needed
      throw Exception('Failed to fetch notification');
    }
    setDataFetched(true);
    _listpendana = [];
    _listpendanaan = [];
    _token = await getToken();
    final url = Uri.parse('http://127.0.0.1:8000/borrower/me/');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      // Parse the response and extract the saku data
      print("fetch user");
      final data = json.decode(response.body);
      _status = data['status'];
      _nama = data['nama'];
      _isDataFetched = true;
      if (_status == "diterima") {
        final url2 = Uri.parse('http://127.0.0.1:8000/borrower/market/');
        final response2 = await http.get(url2, headers: {
          'Authorization': 'Bearer $_token',
        });
        if (response2.statusCode == 200) {
          final data2 = json.decode(response2.body);
          int idmarket = data2["id"];
          _dana_terkumpul = data2['dana_terkumpul'];
          _statuspenggalangan = data2['status'];
          String tenggattemp = data2['tenggat_pendanaan'];

          DateTime tenggat_pendanaan = DateTime.parse(tenggattemp);
          // print("berhasil market");
          DateTime currentDate = DateTime.now();
          Duration jarakhari = tenggat_pendanaan.difference(currentDate);

          _sisa_hari = jarakhari.inDays;
          _sisa_hari += 1;
          final url3 = Uri.parse('http://127.0.0.1:8000/borrower/ajuan/');
          final response3 = await http.get(url3, headers: {
            'Authorization': 'Bearer $_token',
          });
          if (response3.statusCode == 200) {
            final data3 = json.decode(response3.body);
            _besar_biaya = data3['besar_biaya'];
            _tenggat_pengembalian = data3['tenggat_pengembalian'];
            _bayarsebelum = DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(_tenggat_pengembalian));
            _sisa_pengembalian = data3["sisa_pengembalian"];
            int tenor = data3['tenor_pendanaan'];
            double totalbunga = _dana_terkumpul * tenor / 100;
            // menghitung total biaya yang harus dibayar
            double totalbayar = _dana_terkumpul + totalbunga;
            int roundedNumber2 = totalbayar.round();
            _daritotal = roundedNumber2;
            _sudahmembayar = _daritotal - _sisa_pengembalian;
          } else {
            print("gagal fetch ajuan");
          }
          final url4 =
              Uri.parse('http://127.0.0.1:8000/borrower/pendana/${idmarket}');
          final response4 = await http.get(url4);
          if (response4.statusCode == 200) {
            final List<dynamic> responseData = jsonDecode(response4.body);
            _listpendanaan = responseData
                .map<Pendanaan>((json) => Pendanaan.fromJson(json))
                .toList();
            print(_listpendanaan.length);
            for (var data in _listpendanaan) {
              print("testes ${data.lender_id}");
              print("tesmasuk");
              var url5 =
                  Uri.parse('http://127.0.0.1:8000/lender/${data.lender_id}');
              var response5 = await http.get(url5);
              if (response5.statusCode == 200) {
                Map<String, dynamic> responseData = jsonDecode(response5.body);
                String name = responseData['nama'];
                Lender lender = Lender(nama: name);
                _listpendana.add(lender);
                print("terbantai");
              } else {
                print("gagl fetch lender");
              }
            }
          } else {
            print("gagal fetch pendanaan");
          }

          // print(_sisa_hari);
        } else {
          print("gagal fetch market");
        }
      }

      // print(_status);

      notifyListeners();
    } else {
      // Handle error case if needed
      throw Exception('Failed to fetch saku data');
    }
  }
}

class BorrowerPage extends StatefulWidget {
  const BorrowerPage({Key? key}) : super(key: key);
  @override
  BorrowerPageState createState() {
    return BorrowerPageState();
  }
}

class BorrowerPageState extends State<BorrowerPage> {
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(),
      ActivityPage(),
      WalletPage(), // Pass the id value to WalletPage
      AccountPage(),
    ];
  }

  int idx = 0; //index yang aktif
  void onItemTap(int index) {
    var borrowerPageProvider =
        Provider.of<BorrowerPageProvider>(context, listen: false);
    var sakuProvider = Provider.of<SakuProvider>(context, listen: false);
    var borrowerAccountProvider =
        Provider.of<BorrowerAccountProvider>(context, listen: false);
    var isiProvider = Provider.of<IsiProvider>(context, listen: false);
    var cairProvider = Provider.of<CairProvider>(context, listen: false);
    var bayarProvider = Provider.of<BayarProvider>(context, listen: false);

    setState(() {
      borrowerPageProvider.setDataFetched(false);
      sakuProvider.setDataFetched(false);
      borrowerAccountProvider.setDataFetched(false);
      isiProvider.setDataFetched(false);
      bayarProvider.setDataFetched(false);
      cairProvider.setDataFetched(false);
      idx = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Home Borrower',
      home: Scaffold(
        body: pages[idx],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(
                    0, -2), // Adjust the shadow offset as per your preference
              ),
            ],
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
                indicatorColor: Colors.teal.withOpacity(0.3)),
            child: NavigationBar(
              height: 60,
              backgroundColor: Colors.white,
              selectedIndex: idx,
              onDestinationSelected: onItemTap,
              animationDuration: const Duration(seconds: 1),
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              destinations: [
                NavigationDestination(
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.grading_sharp),
                  icon: Icon(Icons.grading_sharp),
                  label: 'Activity',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.wallet),
                  icon: Icon(Icons.wallet_outlined),
                  label: 'Wallet',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.person),
                  icon: Icon(Icons.person_outlined),
                  label: 'Account',
                ),
              ],
              // selectedItemColor: Colors.teal,
              // unselectedItemColor: Colors.grey,
            ),
          ),
        ),
      ),
      routes: {
        '/sec': (context) => AjukanPinjamanPage(),
        '/third': (context) => TutorialPinjaman(),
      },
    );
  }
}

class ButtonNotification extends StatelessWidget {
  const ButtonNotification({Key? key, required this.jumlah}) : super(key: key);
  final int jumlah;

  @override
  Widget build(BuildContext context) {
    final borrowerPageProvider = Provider.of<BorrowerPageProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);

    // return IconButton(
    //   icon: Badge(
    //       label: Text("${jumlah}"),
    //       child:
    //           Icon(Icons.circle_notifications, color: Colors.black, size: 30)),
    //   onPressed: () {
    //     borrowerPageProvider.setDataFetched(false);
    //     notificationProvider.setDataFetched(false);
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => NotificationPage()),
    //     );
    //   },
    // );
    return IconButton(
      icon: jumlah > 0
          ? Badge(
              label: Text("$jumlah"),
              child: Icon(Icons.circle_notifications,
                  color: Colors.black, size: 30),
            )
          : Icon(Icons.circle_notifications, color: Colors.black, size: 30),
      onPressed: () {
        borrowerPageProvider.setDataFetched(false);
        borrowerPageProvider.setNotifikasi();
        notificationProvider.setDataFetched(false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage()),
        );
      },
    );
  }
}

// class NotificationPage extends StatelessWidget {
//   // const NotificationPage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final notificationProvider = Provider.of<NotificationProvider>(context);
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: const Text(
//             'Notification',
//             style: TextStyle(color: Colors.black),
//           ),
//         ),
//         body: FutureBuilder(
//             future: Provider.of<NotificationProvider>(context, listen: false)
//                 .fetchData(),
//             builder: (context, snapshot) {
//               return ListView.builder(
//                 itemCount: notificationProvider
//                     .listnotifikasi.length, // Jumlah notifikasi dalam daftar
//                 itemBuilder: (BuildContext context, int index) {
//                   String notificationTitle =
//                       '${notificationProvider.listnotifikasi[index].title}';
//                   String notificationDescription =
//                       '${notificationProvider.listnotifikasi[index].deskripsi}.';
//                   String jam =
//                       '${notificationProvider.listnotifikasi[index].created_at}';

//                   Card(
//                     child: ListTile(
//                       title: Text(notificationTitle), // Teks notifikasi
//                       subtitle:
//                           Text(notificationDescription), // Deskripsi notifikasi
//                       trailing: Text(jam), // Jam
//                     ),
//                   );
//                 },
//               );
//             }));
//   }
// }

class NotificationPage extends StatelessWidget {
  // // const NotificationPage({Key? key}) : super(key: key);

  // final List<String> notificationImages = [
  //   'assets/images/checkmark.png',
  //   'assets/images/profile-image.jpg',
  //   'assets/notification_image_3.png',
  //   // 'assets/notification_image_4.png',
  //   // 'assets/notification_image_5.png',
  // ];
  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Notification',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: FutureBuilder(
            future: Provider.of<NotificationProvider>(context, listen: false)
                .fetchData(),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: notificationProvider
                    .listnotifikasi.length, // Jumlah notifikasi dalam daftar
                itemBuilder: (context, index) {
                  String notificationTitle =
                      '${notificationProvider.listnotifikasi[index].title}';
                  String notificationDescription =
                      '${notificationProvider.listnotifikasi[index].deskripsi}';
                  String jam =
                      '${notificationProvider.listnotifikasi[index].created_at}';

                  return InkWell(
                    // onTap: () {
                    //   // Arahkan ke halaman lain di sini
                    //   // Navigator.push(
                    //   //   context,
                    //   //   MaterialPageRoute(builder: (context) => DetailPage()),
                    //   // );
                    // },
                    child: Card(
                      child: ListTile(
                        title: Text(notificationTitle), // Teks notifikasi
                        subtitle: Text(
                            notificationDescription), // Deskripsi notifikasi
                        trailing: Text(jam), // Jam
                      ),
                    ),
                  );
                },
              );
            }));
  }
}

List<List<String>> reviewers = [
  [
    "Budi Setiawan",
    "Toko Elektronik",
    "Aplikasi peminjaman dana ini sangat membantu usaha saya. Prosesnya cepat dan mudah, serta suku bunga yang terjangkau.",
    "8.5/10"
  ],
  [
    "Rina Wijaya",
    "Warung Makan",
    "Saya sangat senang menggunakan aplikasi ini untuk mendapatkan modal usaha. Dalam waktu singkat, dana sudah tersedia di rekening saya.",
    "8/10"
  ],
  [
    "Agus Pratama",
    "Bengkel Motor",
    "Aplikasi peminjaman dana ini memberikan solusi cepat bagi usaha saya. Saya bisa memperbaiki peralatan dan kualitas dengan modal yang diperoleh.",
    "9/10"
  ],
  [
    "Dewi Cahyani",
    "Butik Fashion",
    "Proses pengajuan pinjaman sangat mudah dan tidak rumit. Aplikasi ini membantu saya mengembangkan bisnis butik fashion dengan lancar.",
    "9.5/10"
  ],
  [
    "Hendrik Lim",
    "Kedai Kopi",
    "Saya sangat terbantu dengan aplikasi ini. Modal yang cepat cair memungkinkan saya untuk memperluas kedai kopi dan menarik lebih banyak pelanggan.",
    "8/10"
  ],
];

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borrowerPageProvider = Provider.of<BorrowerPageProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    List<Pendanaan> listpendanaan = borrowerPageProvider.listpendanaan;
    List<Lender> listpendana = borrowerPageProvider.listpendana;
    // borrowerPageProvider.fetchData();
    // Provider.of<BorrowerPageProvider>(context, listen: false).fetchData();
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
                text: '${borrowerPageProvider.nama}',
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
          ButtonNotification(jumlah: borrowerPageProvider.jumlahnotifikasi),
        ],
      ),
      body: FutureBuilder(
          future: Provider.of<BorrowerPageProvider>(context, listen: false)
              .fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      if (borrowerPageProvider.status != "diterima") ...[
                        // ElevatedButton(
                        //   onPressed: () {
                        //     borrowerPageProvider.setDataFetched(false);
                        //     borrowerPageProvider.logout();
                        //     Navigator.of(context)
                        //         .push(MaterialPageRoute(builder: (context) {
                        //       return LoginPage();
                        //     }));
                        //   },
                        //   child: const Text('Logout'),
                        // ),
                        if (borrowerPageProvider.status == "selesai") ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                // decoration: BoxDecoration(border: Border.all()),
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  'Rencanakan',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  ' Masa',
                                  style: TextStyle(
                                      color: Color.fromRGBO(32, 106, 93, 1),
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
                                padding: EdgeInsets.only(top: 3),
                                child: Text(
                                  'depan',
                                  style: TextStyle(
                                      color: Color.fromRGBO(32, 106, 93, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 3),
                                child: Text(
                                  ' Bisnismu',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                // decoration: BoxDecoration(border: Border.all()),
                                padding: const EdgeInsets.all(14),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          borrowerPageProvider
                                              .setDataFetched(false);
                                          notificationProvider
                                              .setDataFetched(false);
                                          Navigator.pushNamed(context, '/sec');
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  25), // Mengatur sudut melengkung
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color.fromRGBO(
                                                      32, 106, 93, 1)),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  Size(290, 50)),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.all(17)),
                                        ),
                                        child: Text('AJUKAN PINJAMAN',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else if (borrowerPageProvider.status ==
                            "mengajukan") ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                // decoration: BoxDecoration(border: Border.all()),
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  'Mohon Tunggu,',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  ' Ajuanmu',
                                  style: TextStyle(
                                      color: Color.fromRGBO(32, 106, 93, 1),
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
                                padding: EdgeInsets.only(top: 3, bottom: 50),
                                child: Text(
                                  ' Sedang Diproses...',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                top: 3,
                                left: 15,
                              ),
                              // decoration: BoxDecoration(border: Border.all()),
                              //  padding: EdgeInsets.all(10),
                              child: Text(
                                'Bingung cara',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 3, left: 15),
                              // decoration: BoxDecoration(border: Border.all()),
                              //  padding: EdgeInsets.all(10),
                              child: Text(
                                'Memulai pinjaman?',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 17),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              // decoration: BoxDecoration(border: Border.all()),
                              padding: const EdgeInsets.all(14),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        borrowerPageProvider
                                            .setDataFetched(false);
                                        notificationProvider
                                            .setDataFetched(false);
                                        Navigator.pushNamed(context, '/third');
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                25), // Mengatur sudut melengkung
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Color.fromRGBO(32, 106, 93, 1),
                                        ),
                                        minimumSize: MaterialStateProperty.all(
                                            Size(290, 50)),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.all(17)),
                                      ),
                                      child: Text('CARA MELAKUKAN PINJAMAN',
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 3, left: 15),
                              // decoration: BoxDecoration(border: Border.all()),
                              //  padding: EdgeInsets.all(10),
                              child: Text(
                                'Apa kata mereka?',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            child: Row(
                              children: [
                                for (int i = 0; i < reviewers.length; i++)
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 15, top: 10),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    width: 200,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 5),
                                              child: Text(
                                                reviewers[i][
                                                    0], // Nama Reviewer dari array
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                reviewers[i][
                                                    1], // Kategori Usaha dari array
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 5,
                                                  left: 5,
                                                  right: 5),
                                              child: Container(
                                                height: 1, // Atur tinggi garis
                                                color: Colors
                                                    .grey, // Atur warna abu-abu
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, bottom: 10),
                                              child: Text(
                                                reviewers[i][
                                                    2], // Lorem ipsum dari array
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            // margin: EdgeInsets.all(10),
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: Text(
                                              reviewers[i][3],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ] else if (borrowerPageProvider.status == "diterima") ...[
                        // ElevatedButton(
                        //   onPressed: () {
                        //     borrowerPageProvider.setDataFetched(false);
                        //     borrowerPageProvider.logout();
                        //     Navigator.of(context)
                        //         .push(MaterialPageRoute(builder: (context) {
                        //       return LoginPage();
                        //     }));
                        //   },
                        //   child: const Text('Logout'),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(32, 106, 93, 1),
                                  width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(bottom: 10, left: 15),
                                      child: Text(
                                        'Dana Terkumpul',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 15, left: 15, right: 15),
                                    child: LinearPercentIndicator(
                                      barRadius: Radius.circular(20),
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      lineHeight: 20,
                                      percent:
                                          borrowerPageProvider.dana_terkumpul /
                                              borrowerPageProvider.besar_biaya,
                                      progressColor: Colors.green,
                                      backgroundColor: Colors.grey.shade300,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 15, left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Rp ${borrowerPageProvider.dana_terkumpul}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Color.fromRGBO(0, 177, 71, 1)),
                                      ),
                                      Text(
                                        '${borrowerPageProvider.sisa_hari} hari lagi',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    borrowerPageProvider.setDataFetched(false);
                                    notificationProvider.setDataFetched(false);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return PencairanDanaBorrower();
                                    }));
                                    // Navigator.of(context)
                                    //     .pushNamed("/pencairanDana");
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
                                    minimumSize: MaterialStateProperty.all(
                                        Size(290, 50)),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.all(17)),
                                  ),
                                  child: Text('Cairkan Dana',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.white)),
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
                                'Sisa Pembayaran',
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
                            child: InkWell(
                              onTap: () {
                                // Navigator.of(context).pushNamed("/detailsMarket");
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(16, 5, 16, 7),
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                // decoration: BoxDecoration(
                                //   border: Border.all(
                                //       color: Color.fromRGBO(32, 106, 93, 1), width: 1),
                                //   borderRadius: BorderRadius.circular(10),
                                // ),
                                child: Row(children: [
                                  Icon(
                                    Icons.attach_money,
                                    color: Color.fromRGBO(32, 106, 93, 1),
                                    size: 60,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Text(
                                          "Rp ${borrowerPageProvider.sisa_pengembalian}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(left: 20),
                                      //   child: Text(
                                      //     "dd-mm-yyyy",
                                      //     style: TextStyle(
                                      //         color: Colors.black,
                                      //         fontWeight: FontWeight.w100,
                                      //         fontSize: 11),
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 5),
                                        child: Text(
                                          "Sudah membayar Rp ${borrowerPageProvider.sudahmembayar}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Text(
                                          "dari total ${borrowerPageProvider.daritotal}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  )
                                ]),
                              ),
                            )),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 3, left: 22),
                              child: Text(
                                'Jadwal Pembayaran',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
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
                                        'Tenggat Bayar Sebelum ${borrowerPageProvider.bayarsebelum}',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 19, 95, 22),
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (borrowerPageProvider.statuspenggalangan ==
                                      "donpenggalangan") ...[
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          borrowerPageProvider
                                              .setDataFetched(false);
                                          notificationProvider
                                              .setDataFetched(false);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return PembayaranBorrower();
                                          }));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: const Color.fromARGB(
                                              255, 247, 247, 247),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            side: BorderSide(
                                                color: const Color.fromARGB(
                                                    255, 19, 83, 21)),
                                          ),
                                          minimumSize: Size(80, 40),
                                        ),
                                        child: Text(
                                          'Bayar',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                        //
                        //
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 10, left: 22),
                              child: Text(
                                'Daftar Para Pendana',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        //
                        for (int i = 0; i < listpendana.length; i++)
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: InkWell(
                                onTap: () {
                                  // Navigator.of(context)
                                  //     .pushNamed("/detailsMarket");
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.fromLTRB(16, 5, 16, 7),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color.fromRGBO(32, 106, 93, 1),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(children: [
                                    Icon(
                                      Icons.person,
                                      color: Color.fromRGBO(32, 106, 93, 1),
                                      size: 60,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            "${listpendana[i].nama}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            "Memberi dana sebesar",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w100,
                                                fontSize: 11),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 5, bottom: 5),
                                          child: Text(
                                            "Rp. ${listpendanaan[i].total_pinjaman}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    )
                                  ]),
                                ),
                              )),
                      ]
                    ],
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
