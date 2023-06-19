import 'package:flutter/material.dart';
import 'package:tubes_riil/borrower/home/borrower-home.dart';
import 'package:tubes_riil/lender/marketplace/lender-pendanaan-umkm.dart';
import 'package:tubes_riil/lender/wallet/lender-isi-saldo.dart';
import 'package:tubes_riil/lender/wallet/lender-pencairan-dana.dart';
import 'package:tubes_riil/login-page.dart';
import '../activity/lender-activity.dart';
import '../wallet/lender-wallet.dart';
import '../marketplace/lender-marketplace.dart';
import '../account/lender-account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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

class LenderPageProvider extends ChangeNotifier {
  bool _isDataFetched = false;
  String? _token = "";
  int _saku = 0;
  String _status = "";
  String _nama = '';
  List<Notification> _listnotifikasi = [];
  int _jumlahnotifikasi = 0;
  List<String> listnamaumkm = [];
  List<String> listkategoriumkm = [];
  List<int> listtotalpinjaman = [];
  int pendanaanaktif = 0;
  double keuntungan = 0;
  List<int> bungaajuan = [];

  List<Notification> get listnotifikasi => _listnotifikasi;
  int get jumlahnotifikasi => _jumlahnotifikasi;

  String get nama => _nama;
  String get status => _status;
  int get saku => _saku;

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

  Future<void> setNotifikasi() async {
    _token = await getToken();
    final url8 = Uri.parse('http://127.0.0.1:8000/lender/notifikasi/read/');
    final response8 = await http.patch(url8, headers: {
      'Authorization': 'Bearer $_token',
    });
    if (response8.statusCode == 200) {
      print("berhasil read");
      setDataFetched(false);
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
    _isDataFetched = true;
    _token = await getToken();
    _jumlahnotifikasi = 0;
    _listnotifikasi = [];
    listnamaumkm = [];
    listkategoriumkm = [];
    listtotalpinjaman = [];
    pendanaanaktif = 0;
    keuntungan = 0;
    bungaajuan = [];
    final url9 = Uri.parse('http://127.0.0.1:8000/lender/notifikasi/');

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
      print("jumlah notifikasi ${jumlahnotifikasi}");
      print("status fetch ${_isDataFetched}");
    } else {
      // Handle error case if needed
      throw Exception('Failed to fetch notification');
    }

    final url = Uri.parse('http://127.0.0.1:8000/lender/me/');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      // Parse the response and extract the saku data
      final data = json.decode(response.body);
      _status = data['status'];
      _saku = data['saku'];
      _nama = data['nama'];
      _isDataFetched = true;
      // print(_status);
      if (status == "sudah") {
        final url2 = Uri.parse('http://127.0.0.1:8000/lender/pendana/');
        final response2 = await http.get(url2, headers: {
          'Authorization': 'Bearer $_token',
        });
        if (response2.statusCode == 200) {
          print("masuk");
          List<dynamic> data2 = jsonDecode(response2.body);
          for (var item in data2) {
            print("item");
            print(item["total_pinjaman"]);
            listtotalpinjaman.add(item["total_pinjaman"]);
            final url3 =
                Uri.parse('http://127.0.0.1:8000/market/${item["market_id"]}');
            final response3 = await http.get(url3);
            if (response3.statusCode == 200) {
              print("masuk response3");
              final data3 = json.decode(response3.body);
              print("${data3["ajuan_id"]}");
              final url4 =
                  Uri.parse('http://127.0.0.1:8000/ajuan/${data3["ajuan_id"]}');
              final response4 = await http.get(url4);
              if (response4.statusCode == 200) {
                print("masuk response4");
                final data4 = jsonDecode(response4.body);
                bungaajuan.add(data4["bunga"]);
                print("${data4["borrower_id"]}");
                final url5 = Uri.parse(
                    'http://127.0.0.1:8000/borrowerr/${data4["borrower_id"]}');
                final response5 = await http.get(url5);
                if (response5.statusCode == 200) {
                  print("masuk response5");
                  final data5 = jsonDecode(response5.body);
                  String namaa = data5['umkm'][0]['nama'];
                  print("mask sini");
                  print(namaa);
                  listnamaumkm.add(namaa);
                  String kategorii = data5['umkm'][0]['kategori'];
                  listkategoriumkm.add(kategorii);
                }
              } else {
                print("terbantai");
              }
            } else {
              print("terbantai");
            }
          }
        } else {
          print("gagal fetch pendana");
        }
      }
      notifyListeners();
    } else {
      // Handle error case if needed
      throw Exception('Failed to fetch saku data');
    }
    for (int i = 0; i < listnamaumkm.length; i++) {
      double totalkeuntungan = (listtotalpinjaman[i] * bungaajuan[i]) / 100;
      keuntungan += totalkeuntungan;
      pendanaanaktif += listtotalpinjaman[i];
      print("ke ${i} ${keuntungan}");
      print("terkwekw");
      print(listkategoriumkm[i]);
    }
  }
}

class LenderPage extends StatefulWidget {
  const LenderPage({Key? key}) : super(key: key);
  @override
  LenderPageState createState() {
    return LenderPageState();
  }
}

class LenderPageState extends State<LenderPage> {
  List<Widget> pages = [
    HomePage(),
    ActivityPage(),
    MarketplacePage(),
    WalletPage(),
    AccountPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  int idx = 0; //index yang aktif
  // pokonya tambahain buat semua provider yang harus fetchdata
  void onItemTap(int index) {
    var lenderPageProvider =
        Provider.of<LenderPageProvider>(context, listen: false);
    var cairLenderProvider =
        Provider.of<CairLenderProvider>(context, listen: false);
    var marketPlaceProvider =
        Provider.of<MarketPlaceProvider>(context, listen: false);
    var sakuLenderProvider =
        Provider.of<SakuLenderProvider>(context, listen: false);
    var lenderAccountProvider =
        Provider.of<LenderAccountProvider>(context, listen: false);
    var pendanaanProvider =
        Provider.of<PendanaanProvider>(context, listen: false);
    var marketplaceProvider =
        Provider.of<MarketPlaceProvider>(context, listen: false);
    var isiLenderProvider =
        Provider.of<IsiLenderProvider>(context, listen: false);
    setState(() {
      lenderPageProvider.setDataFetched(false);
      cairLenderProvider.setDataFetched(false);
      marketPlaceProvider.setDataFetched(false);
      sakuLenderProvider.setDataFetched(false);
      lenderAccountProvider.setDataFetched(false);
      isiLenderProvider.setDataFetched(false);
      marketplaceProvider.setDataFetched(false);
      pendanaanProvider.setDataFetched(false);
      idx = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                  selectedIcon: Icon(Icons.festival),
                  icon: Icon(Icons.festival),
                  label: 'Marketplace',
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
    );
  }
}

class ButtonNotification extends StatelessWidget {
  const ButtonNotification({Key? key, required this.jumlah}) : super(key: key);
  final int jumlah;
  @override
  Widget build(BuildContext context) {
    final lenderPageProvider = Provider.of<LenderPageProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    // return IconButton(
    //   icon: Icon(Icons.circle_notifications, color: Colors.black, size: 30),
    //   onPressed: () {
    //     lenderPageProvider.setDataFetched(false);
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
        lenderPageProvider.setDataFetched(false);
        notificationProvider.setDataFetched(false);
        lenderPageProvider.setNotifikasi();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage()),
        );
      },
    );
  }
}

class NotificationPage extends StatelessWidget {
  // const NotificationPage({Key? key}) : super(key: key);

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
                .fetchDataLender(),
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

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: Center(
        child: Text('Halaman Detail'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lenderPageProvider = Provider.of<LenderPageProvider>(context);
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
                  text: '${lenderPageProvider.nama}',
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
            ButtonNotification(jumlah: lenderPageProvider.jumlahnotifikasi),
          ],
        ),
        body: FutureBuilder(
            future: Provider.of<LenderPageProvider>(context, listen: false)
                .fetchData(),
            builder: (context, snapshot) {
              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(
                          "images/background-opacity.png",
                        ),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      // decoration: const BoxDecoration(
                      //   image: DecorationImage(
                      //     image: AssetImage(
                      //       "images/background-opacity.png",
                      //     ),
                      //     fit: BoxFit.fitHeight,
                      //   ),
                      // ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(32, 106, 93, 1),
                                    width: 1),
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
                                    'Rp ${lenderPageProvider.saku}',
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 177, 71, 1),
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      lenderPageProvider.setDataFetched(false);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return PencairanDanaLender();
                                      }));
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
                          if (lenderPageProvider.status == "belum") ...[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: Text(
                                  "Anda belum memiliki mitra yang didanai",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13)),
                            ),
                            SizedBox(height: 20),
                          ] else if (lenderPageProvider.status == "sudah") ...[
                            Column(
                              children: [
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 3, left: 22),
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromRGBO(32, 106, 93, 1),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'KEUNTUNGAN\nRp. ${lenderPageProvider.keuntungan}',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'TOTAL PENDANAAN AKTIF\nRp. ${lenderPageProvider.pendanaanaktif}',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 3, left: 22),
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
                                for (int i = 0;
                                    i <
                                        lenderPageProvider
                                            .listkategoriumkm.length;
                                    i++)
                                  Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: InkWell(
                                        // onTap: () {
                                        //   lenderPageProvider
                                        //       .setDataFetched(false);
                                        //   Navigator.of(context)
                                        //       .pushNamed("/detailsMarket");
                                        // },
                                        child: Container(
                                          width: double.infinity,
                                          padding:
                                              EdgeInsets.fromLTRB(16, 5, 16, 7),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    32, 106, 93, 1),
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(children: [
                                            Icon(
                                              Icons.festival_outlined,
                                              color: Color.fromRGBO(
                                                  32, 106, 93, 1),
                                              size: 60,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: Text(
                                                    "${lenderPageProvider.listnamaumkm[i]}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: Text(
                                                    "${lenderPageProvider.listkategoriumkm[i]}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        fontSize: 11),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20,
                                                          top: 5,
                                                          bottom: 5),
                                                  child: Text(
                                                    "Total Pinjaman: Rp. ${lenderPageProvider.listtotalpinjaman[i]}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]),
                                        ),
                                      )),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: Text(
                                  "Anda telah mencapai akhir daftar mitra Anda",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13)),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}
