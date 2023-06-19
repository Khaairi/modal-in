import 'package:flutter/material.dart';
import '../home/borrower-home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Activity {
  final int biaya;
  final String status;
  final String keterangan;
  final String created_at;
  Activity(
      {required this.biaya,
      required this.status,
      required this.keterangan,
      required this.created_at});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      biaya: json['biaya'] ?? '',
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      keterangan: json['keterangan'] ?? '',
    );
  }
}

class BorrowerActivityProvider extends ChangeNotifier {
  bool _isDataFetched = false;
  String? _token = "";
  String _status = "";
  String _keterangan = '';
  int _biaya = 0;
  String _created_at = '';
  List<Activity> _listacitivity = [];
  List<Activity> _activitypenerimaan = [];
  List<Activity> _activitypembayaran = [];

  List<Activity> get listacitivity => _listacitivity;
  List<Activity> get activitypenerimaan => _activitypenerimaan;
  List<Activity> get activitypembayaran => _activitypembayaran;
  String get status => _status;
  String get keterangan => _keterangan;
  int get biaya => _biaya;
  String get created_at => _created_at;

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
    setDataFetched(true);

    _listacitivity = [];
    _activitypembayaran = [];
    _activitypembayaran = [];
    _token = await getToken();
    final url = Uri.parse('http://127.0.0.1:8000/borrower/activity/');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      // Parse the response and extract the saku data
      final List<dynamic> responseData = jsonDecode(response.body);
      _listacitivity = responseData
          .map<Activity>((json) => Activity.fromJson(json))
          .toList();
      for (final data in listacitivity) {
        print(data.status);
        if (data.status == 'penerimaan') {
          _activitypenerimaan.add(data);
        } else {
          _activitypembayaran.add(data);
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

class ActivityPage extends StatelessWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<BorrowerActivityProvider>(context);
    List<Activity> dataPembayaran = activityProvider.activitypembayaran;
    List<Activity> dataPenerimaan = activityProvider.activitypenerimaan;
    int currentIndex = 1;
    List<Tab> myTab = [
      Tab(
        child: Text(
          "Penerimaan",
          style: TextStyle(color: Colors.black),
        ),
      ),
      Tab(
        child: Text(
          "Pembayaran",
          style: TextStyle(color: Colors.black),
        ),
      ),
    ];

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aktivitas',
        home: DefaultTabController(
          length: myTab.length,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text(
                'Aktivitas',
                style: TextStyle(color: Colors.black),
              ),
              bottom: TabBar(
                tabs: myTab,
                indicatorPadding: const EdgeInsets.all(8),
                unselectedLabelColor: Colors.teal,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.greenAccent,
                      Color.fromRGBO(191, 220, 174, 1)
                    ]),
                    borderRadius: BorderRadius.circular(50),
                    color: Color.fromRGBO(191, 220, 174, 1)),
                labelColor: Colors.black,
              ),
            ),
            body: FutureBuilder(
                future: Provider.of<BorrowerActivityProvider>(context,
                        listen: false)
                    .fetchData(),
                builder: (context, snapshot) {
                  return TabBarView(
                    children: [
                      // Konten tab penerimaan
                      ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: dataPenerimaan
                            .length, // Jumlah data yang ingin ditampilkan
                        itemBuilder: (BuildContext context, int index) {
                          final myData = dataPenerimaan[index];
                          return TransactionHistoryItem(
                            icon: Icon(Icons.attach_money),
                            senderName: '${myData.keterangan}',
                            date: '${myData.created_at}',
                            amount: '${myData.biaya}',
                            isPositive: true,
                          );
                        },
                      ),
                      // Konten tab pembayaran
                      ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: dataPembayaran
                            .length, // Jumlah data yang ingin ditampilkan
                        itemBuilder: (BuildContext context, int index) {
                          final myData = dataPembayaran[index];
                          return TransactionHistoryItem(
                            icon: Icon(Icons.attach_money),
                            senderName: '${myData.keterangan}',
                            date: '${myData.created_at}',
                            amount: '${myData.biaya}',
                            isPositive: false,
                          );
                        },
                      ),
                    ],
                  );
                }),
          ),
        ));
  }
}

class TransactionHistoryItem extends StatelessWidget {
  final Icon icon;
  final String senderName;
  final String date;
  final String amount;
  final bool isPositive;

  const TransactionHistoryItem({
    required this.icon,
    required this.senderName,
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
    final subtitleText = formattedDate + ' ' + formattedTime;

    return ListTile(
      leading: icon,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            senderName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
        ],
      ),
      subtitle: Text(subtitleText),
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
