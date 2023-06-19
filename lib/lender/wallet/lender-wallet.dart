import 'package:flutter/material.dart';
import '../home/lender-home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'lender-isi-saldo.dart';
import 'lender-pencairan-dana.dart';
import 'package:intl/intl.dart';

class Riwayat {
  final int nominal;
  final String status;
  final String waktu;
  Riwayat({required this.nominal, required this.status, required this.waktu});

  factory Riwayat.fromJson(Map<String, dynamic> json) {
    return Riwayat(
      nominal: json['nominal'] ?? '',
      status: json['status'] ?? '',
      waktu: json['created_at'] ?? '',
    );
  }
}

class SakuLenderProvider extends ChangeNotifier {
  int _saku = 0;
  bool _isDataFetched = false;
  String? _token = "";
  // var listriwayat = [];
  List<Riwayat> _listRiwayat = [];
  List<Riwayat> _listTopup = [];
  List<Riwayat> _listCair = [];

  int get saku => _saku;
  List<Riwayat> get listRiwayat => _listRiwayat;
  List<Riwayat> get listTopup => _listTopup;
  List<Riwayat> get listCair => _listCair;

  void setDataFetched(bool value) {
    _isDataFetched = value;
  }

  // void setData(List<dynamic> data)
  // {

  // }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchData() async {
    if (_isDataFetched) {
      // Data has already been fetched, no need to fetch again
      return;
    }
    setDataFetched(true);
    _token = await getToken();
    final url = Uri.parse('http://127.0.0.1:8000/lender/me/');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      // Parse the response and extract the saku data
      _listCair = [];
      _listTopup = [];
      final data = json.decode(response.body);
      final sakuData = data['saku'];
      _isDataFetched = true;
      print("fetch lender");
      // Update the _saku variable and notify listeners
      _saku = sakuData;

      final url2 = Uri.parse('http://127.0.0.1:8000/lender/riwayat/');
      final response2 =
          await http.get(url2, headers: {'Authorization': 'Bearer $_token'});

      if (response2.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response2.body);
        _listRiwayat = responseData
            .map<Riwayat>((json) => Riwayat.fromJson(json))
            .toList();
        for (final data in listRiwayat) {
          if (data.status == 'topup') {
            _listTopup.add(data);
          } else {
            _listCair.add(data);
          }
          print("nominal : ${data.nominal}");
        }
      } else {
        print("ada error");
      }

      notifyListeners();
    } else {
      // Handle error case if needed
      throw Exception('Failed to fetch saku data');
    }
  }
}

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with TickerProviderStateMixin {
  // const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sakuProvider = Provider.of<SakuLenderProvider>(context);
    List<Riwayat> dataListTopup = sakuProvider.listTopup;
    List<Riwayat> dataListCair = sakuProvider.listCair;

    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Saku',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: FutureBuilder(
            future: Provider.of<SakuLenderProvider>(context, listen: false)
                .fetchData(),
            builder: (context, snapshot) {
              return Center(
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(
                            "images/background-opacity.png",
                          ),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      child: Column(children: [
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
                                Text(
                                  'Saldo',
                                  style: TextStyle(
                                      color: Color.fromRGBO(32, 106, 93, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Rp.  ${sakuProvider.saku}',
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 177, 71, 1),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      sakuProvider.setDataFetched(false);
                                      // print("halohalo $id");
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return IsiSaldoLender();
                                      }));
                                    },
                                    child: Image.asset(
                                      'icons/icon-isi-saldo.png',
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      'Isi Saldo',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      sakuProvider.setDataFetched(false);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return PencairanDanaLender();
                                      }));
                                    },
                                    child: Image.asset(
                                      'icons/icon-cairkan.png',
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      'Cairkan Dana',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: -2,
                                blurRadius: 6,
                                offset: Offset(0,
                                    -7), // Atur offset bayangan sesuai kebutuhan
                              ),
                            ],
                          ),
                          child: TabBar(
                              unselectedLabelColor: Colors.teal,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.greenAccent,
                                    Color.fromRGBO(191, 220, 174, 1)
                                  ]),
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color.fromRGBO(191, 220, 174, 1)),
                              controller: _tabController,
                              labelColor: Colors.black,
                              // unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.teal,
                              tabs: [
                                Tab(
                                  text: "Top Up",
                                ),
                                Tab(
                                  text: "Pencairan Dana",
                                )
                              ]),
                        ),
                      ]),
                    ),
                    Container(
                      width: double.maxFinite,
                      height: 330,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          if (dataListTopup.length == 0) ...[
                            ListView(
                              children: [
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: Text(
                                      "Anda tidak memiliki riwayat isi saldo."),
                                ))
                              ],
                            ),
                          ] else ...[
                            ListView.builder(
                              itemCount: dataListTopup.length,
                              itemBuilder: (context, index) {
                                final myData = dataListTopup[index];
                                return TransactionHistoryItem(
                                  icon: Icon(Icons.attach_money),
                                  date: '${myData.waktu}',
                                  amount: '${myData.nominal}',
                                  isPositive: true,
                                );
                              },
                            ),
                          ],
                          // Konten Sejarah Top Up

                          // Konten Sejarah Pencairan Dana
                          if (dataListCair.length == 0) ...[
                            ListView(
                              children: [
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: Text(
                                      "Anda tidak memiliki riwayat pencairan dana."),
                                ))
                              ],
                            ),
                          ] else ...[
                            ListView.builder(
                              itemCount: dataListCair.length,
                              itemBuilder: (context, index) {
                                final myData = dataListCair[index];
                                return TransactionHistoryItem(
                                  icon: Icon(Icons.money_off),
                                  date: '${myData.waktu}',
                                  amount: '${myData.nominal}',
                                  isPositive: false,
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    )
                  ],
                ),
              );
            }));
  }
}

class TransactionHistoryItem extends StatelessWidget {
  final Icon icon;
  // final String senderName;
  // final String paymentMethod;
  final String date;
  final String amount;
  final bool isPositive;

  const TransactionHistoryItem({
    required this.icon,
    // required this.senderName,
    // required this.paymentMethod,
    required this.date,
    required this.amount,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    String formattedAmount = (isPositive ? '+ ' : '- ') + 'Rp. ' + amount;
    final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
    final parsedDate = DateTime.parse(date);
    final formattedTime = DateFormat.Hm().format(parsedDate);

    return ListTile(
      leading: icon,
      // title: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     // Text(
      //     //   senderName,
      //     //   style: TextStyle(fontWeight: FontWeight.bold),
      //     // ),
      //     SizedBox(height: 4),
      //     // Text(paymentMethod),
      //   ],
      // ),
      title: Text(formattedDate),
      subtitle: Text(formattedTime),
      trailing: Text(
        formattedAmount,
        style: TextStyle(
          color: isPositive ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
