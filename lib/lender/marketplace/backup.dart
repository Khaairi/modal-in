import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tubes_riil/lender/marketplace/lender-pendanaan-umkm.dart';
import '../home/lender-home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

enum Sizes { extraSmall, small, medium, large, extraLarge }

enum JenisUMKM { kuliner, otomotif, Pendidikan, Fashion, Travel }

class Market {
  final int market_id;
  final int dana_terkumpul;
  final String tenggat_pendanaan;
  final int ajuan_id;
  int sisa;

  Market(
      {required this.market_id,
      required this.dana_terkumpul,
      required this.tenggat_pendanaan,
      required this.ajuan_id,
      required this.sisa}) {
    String tenggaltemp = this.tenggat_pendanaan;
    DateTime tenggat_pendanaan_date = DateTime.parse(tenggaltemp);
    DateTime currentDate = DateTime.now();
    Duration jarakhari = tenggat_pendanaan_date.difference(currentDate);
    sisa = jarakhari.inDays + 1;
  }

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      market_id: json['id'] ?? '',
      dana_terkumpul: json['dana_terkumpul'] ?? '',
      tenggat_pendanaan: json['tenggat_pendanaan'] ?? '',
      ajuan_id: json["ajuan_id"] ?? '',
      sisa: 0,
    );
  }
  @override
  String toString() {
    return '(market_id: $market_id, dana_terkumpul: $dana_terkumpul, tenggat_pendanaan: $tenggat_pendanaan, ajuan_id : $ajuan_id, sisa : $sisa)';
  }
}

class Ajuan {
  final int borrower_id;
  final int besar_biaya;
  final int tenor_pendanaan;
  final int minimal_biaya;
  Ajuan(
      {required this.borrower_id,
      required this.besar_biaya,
      required this.tenor_pendanaan,
      required this.minimal_biaya});
  factory Ajuan.fromJson(Map<String, dynamic> json) {
    return Ajuan(
      borrower_id: json['borrower_id'] ?? '',
      besar_biaya: json['besar_biaya'] ?? '',
      tenor_pendanaan: json["tenor_pendanaan"] ?? '',
      minimal_biaya: json["minimal_biaya"] ?? '',
    );
  }
  @override
  String toString() {
    return '(borrower_id: $borrower_id, besar_biaya: $besar_biaya, tenor_pendanaan : $tenor_pendanaan, minimal_biaya : $minimal_biaya)';
  }
}

class Borrower {
  final String nama;
  Borrower({required this.nama});
  factory Borrower.fromJson(Map<String, dynamic> json) {
    return Borrower(
      nama: json['nama'] ?? '',
    );
  }
  @override
  String toString() {
    return '(nama: $nama)';
  }
}

class Umkm {
  final String nama;
  final String kategori;
  final int penghasilan;
  final String foto_umkm;
  Umkm(
      {required this.nama,
      required this.kategori,
      required this.penghasilan,
      required this.foto_umkm});
  factory Umkm.fromJson(Map<String, dynamic> json) {
    return Umkm(
      nama: json['nama'] ?? '',
      kategori: json['kategori'] ?? '',
      penghasilan: json['penghasilan'] ?? '',
      foto_umkm: json['fotoUmkm'] ?? '',
    );
  }
  @override
  String toString() {
    return '(name: $nama, kategori: $kategori, penghasilan : $penghasilan, foto_umkm : $foto_umkm)';
  }
}

class CombinedData {
  final Market market;
  final Ajuan ajuan;
  final Borrower borrower;
  final Umkm umkm;

  CombinedData({
    required this.market,
    required this.ajuan,
    required this.borrower,
    required this.umkm,
  });

  @override
  String toString() {
    return 'CombinedData(market: $market, ajuan: $ajuan, borrower: $borrower, umkm: $umkm)';
  }
}

class MarketPlaceProvider extends ChangeNotifier {
  List<int> _list_id_ajuan = [];
  List<Market> _listmarkettemp = [];
  List<Ajuan> _listajuantemp = [];

  List<Market> _listmarket = [];

  List<Ajuan> _listajuan = [];

  List<Borrower> _listborrower = [];

  List<Umkm> _listumkm = [];

  List<CombinedData> _combinedDataList = [];

  String _search = '';
  List<CombinedData> get combinedDataList => _combinedDataList;
  String get search => _search;

  List<Umkm> get listumkm => _listumkm;

  bool _isDataFetched = false;
  String? _token = "";

  void setSearch(String value) {
    _search = value;
  }

  void setDataFetched(bool value) {
    _isDataFetched = value;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  List<CombinedData> _filteredDataList = [];
  List<CombinedData> get filteredDataList => _filteredDataList;
  void searchByMarketName() {
    _filteredDataList = _combinedDataList
        .where((data) => data.umkm.nama.contains(_search))
        .toList();
    notifyListeners();
  }

  Future<void> fetchData() async {
    if (_isDataFetched) {
      // Data has already been fetched, no need to fetch again
      return;
    }

    _token = await getToken();
    final url = Uri.parse('http://127.0.0.1:8000/markets/');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      _isDataFetched = true;
      _listmarket = [];

      _listajuan = [];

      _listborrower = [];

      _listumkm = [];

      _combinedDataList = [];

      _filteredDataList = [];
      // print("berhasil market");
      final List<dynamic> responseData = jsonDecode(response.body);
      _listmarkettemp =
          responseData.map<Market>((json) => Market.fromJson(json)).toList();

      for (final data in _listmarkettemp) {
        _listmarket.add(data);
        // print(data.ajuan_id);
        final url2 = Uri.parse('http://127.0.0.1:8000/ajuan/${data.ajuan_id}');
        final response2 = await http.get(url2);

        if (response2.statusCode == 200) {
          // print("berhasil ajuan");
          final data2 = json.decode(response2.body);
          // _listajuan.add(data2);
          // print(data2);
          Map<String, dynamic> jsonMap = data2;
          Ajuan ajuan = Ajuan.fromJson(jsonMap);

          _listajuan.add(ajuan);
          // print("adsadwas ${data2["borrower_id"]}");
          // for (final cobaprint in _listajuan) {
          //   print("coba print gimang ${cobaprint.borrower_id}");
          // }
          final url3 = Uri.parse(
              // 'http://127.0.0.1:8000/borrower/${data2["borrower_id"]}');
              'http://127.0.0.1:8000/borrower/${data2["id"]}');
          final response3 = await http.get(url3);

          if (response3.statusCode == 200) {
            // print("berhasil borrower");
            final data3 = json.decode(response3.body);
            // print("dawda ${data3}");
            Map<String, dynamic> jsonMap = data3;
            Borrower borrower = Borrower.fromJson(jsonMap);
            _listborrower.add(borrower);
            // print("waduh ${data3["nama"]}");
            final umkmDataList = data3['umkm'];
            for (var umkmData in umkmDataList) {
              Umkm umkm = Umkm.fromJson(umkmData);
              _listumkm.add(umkm);
            }
          }
        }
      }
    } else {
      // Handle error case if needed
      throw Exception('Failed to fetch saku data');
    }
    print("gimang123123");
    for (int i = 0; i < _listmarket.length; i++) {
      Market market = _listmarket[i];
      Ajuan ajuan = _listajuan[i];
      Borrower borrower = _listborrower[i];
      Umkm umkm = _listumkm[i];

      CombinedData combinedData = CombinedData(
        market: market,
        ajuan: ajuan,
        borrower: borrower,
        umkm: umkm,
      );

      combinedDataList.add(combinedData);
      print("masuk filter2");

      filteredDataList.add(combinedData);
      print("masuk filter");
    }
    // for (var data in combinedDataList) {
    //   print(data.toString());
    // }
    notifyListeners();
  }
}

class MarketplacePage extends StatelessWidget {
  final searchController = TextEditingController();
  MarketplacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final marketProvider = Provider.of<MarketPlaceProvider>(context);

    Set<JenisUMKM> filters = <JenisUMKM>{};

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Marketplace',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: FutureBuilder(
            future: Provider.of<MarketPlaceProvider>(context, listen: false)
                .fetchData(),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                  child: Column(children: [
                Consumer<MarketPlaceProvider>(
                  builder: (context, marketProvider, _) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) {
                          print("value : ${value}");
                          marketProvider.setSearch(value);
                          if (value.isEmpty) {
                            // Fetch data again when the TextField is empty
                            Provider.of<MarketPlaceProvider>(context,
                                    listen: false)
                                .fetchData();
                            print("setsearch kosong");
                          } else {
                            marketProvider.searchByMarketName();
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Search',
                          labelStyle: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          hintText: 'Cari UMKM',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // TextFormField(
                //   controller: searchController,
                //   onChanged: (value) {
                //     Provider.of<MarketPlaceProvider>(context, listen: false)
                //         .setSearch(value);
                //     if (value.isEmpty) {
                //       // Fetch data again when the TextField is empty
                //       Provider.of<MarketPlaceProvider>(context, listen: false)
                //           .fetchData();
                //     } else {
                //       Provider.of<MarketPlaceProvider>(context, listen: false)
                //           .searchByMarketName();
                //     }
                //   },
                //   decoration: InputDecoration(
                //     labelText: 'Nama',
                //     labelStyle: TextStyle(
                //         fontFamily: 'Arial',
                //         fontSize: 15,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.black),
                //   ),
                // ),
                // Container(
                //   child: Padding(
                //     padding: const EdgeInsets.all(20),
                //     child: TextFormField(
                //       controller: searchController,
                //       onChanged: (value) {
                //         Provider.of<MarketPlaceProvider>(context, listen: false)
                //             .setSearch(value);
                //         if (value.isEmpty) {
                //           // Fetch data again when the TextField is empty
                //           Provider.of<MarketPlaceProvider>(context,
                //                   listen: false)
                //               .fetchData();
                //         } else {
                //           Provider.of<MarketPlaceProvider>(context,
                //                   listen: false)
                //               .searchByMarketName();
                //         }
                //       },
                //       decoration: InputDecoration(
                //         labelText: 'Nomor telepon',
                //         labelStyle: TextStyle(
                //             fontFamily: 'Arial',
                //             fontSize: 15,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.black),
                //       ),
                //       //  TextField(
                //       //   controller: searchController,
                //       //   onChanged: (value) {
                //       //     Provider.of<MarketPlaceProvider>(context, listen: false)
                //       //         .setSearch(value);
                //       //     if (value.isEmpty) {
                //       //       // Fetch data again when the TextField is empty
                //       //       Provider.of<MarketPlaceProvider>(context,
                //       //               listen: false)
                //       //           .fetchData();
                //       //     } else {
                //       //       Provider.of<MarketPlaceProvider>(context,
                //       //               listen: false)
                //       //           .searchByMarketName();
                //       //     }
                //       //   },
                //       // decoration: InputDecoration(
                //       //   labelText: 'Search',
                //       //   labelStyle: TextStyle(
                //       //       fontFamily: 'Arial',
                //       //       fontSize: 15,
                //       //       fontWeight: FontWeight.bold,
                //       //       color: Colors.black),
                //       // ),
                //     ),
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 22, bottom: 5, top: 5),
                      child: Text(
                        'Daftar UMKM',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Consumer<MarketPlaceProvider>(
                    builder: (context, marketProvider, _) {
                  return GridView.count(
                    childAspectRatio: 1,
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children: [
                      for (int i = 0;
                          i < marketProvider.filteredDataList.length;
                          i++)
                        InkWell(
                          onTap: () {
                            marketProvider.setDataFetched(false);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return DetailUMKM(
                                  combinedData:
                                      marketProvider.filteredDataList[i]);
                            }));
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
                                    child: marketProvider.filteredDataList[i]
                                            .umkm.foto_umkm.isNotEmpty
                                        ? Image.network(
                                            // API endpoint to fetch the image
                                            'http://127.0.0.1:8000/getimage/${marketProvider.filteredDataList[i].umkm.foto_umkm}',
                                            height: 100,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          )
                                        : const Text("Image Tidak Tersedia"),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 5),
                                    child: Text(
                                      "${marketProvider.filteredDataList[i].umkm.nama}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "${marketProvider.filteredDataList[i].umkm.kategori}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
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
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Rp ${marketProvider.filteredDataList[i].ajuan.besar_biaya}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                ]),
                          ),
                        )
                    ],
                  );
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Text("Anda telah mencapai akhir daftar UMKM",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 13)),
                  );
                })
              ]));
            }));
  }
}

class DetailUMKM extends StatelessWidget {
  const DetailUMKM({Key? key, required this.combinedData}) : super(key: key);
  final CombinedData combinedData;

  @override
  Widget build(BuildContext context) {
    final marketProvider = Provider.of<MarketPlaceProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 3.5,
                child: combinedData.umkm.foto_umkm.isNotEmpty
                    ? Image.network(
                        // API endpoint to fetch the image
                        'http://127.0.0.1:8000/getimage/${combinedData.umkm.foto_umkm}',
                        height: 100,
                        width: 200,
                        fit: BoxFit.cover,
                      )
                    : const Text("Image Tidak Tersedia"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Text(
                "${combinedData.umkm.nama}",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            Container(
                padding: EdgeInsets.only(bottom: 15, left: 15),
                child: Text(
                  "Dana Terkumpul",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                alignment: Alignment.centerLeft),
            Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                child: LinearPercentIndicator(
                  barRadius: Radius.circular(20),
                  lineHeight: 20,
                  percent: combinedData.market.dana_terkumpul /
                      combinedData.ajuan.besar_biaya,
                  progressColor: Colors.green,
                  backgroundColor: Colors.grey.shade300,
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rp ${combinedData.market.dana_terkumpul}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 177, 71, 1)),
                  ),
                  Text(
                    '${combinedData.market.sisa} hari lagi',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.red),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 25, right: 25),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nama Pemilik',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                  Text(
                    'Total Pinjaman',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${combinedData.borrower.nama}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Text(
                    'Rp ${combinedData.ajuan.besar_biaya}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jenis UMKM',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                  Text(
                    'Tenor Pendanaan',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${combinedData.umkm.kategori}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Text(
                    '${combinedData.ajuan.tenor_pendanaan} Bulan',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pendapatan per Tahun',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                  Text(
                    'Minimal Pendanaan',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rp ${combinedData.umkm.penghasilan}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Text(
                    'Rp ${combinedData.ajuan.minimal_biaya}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        marketProvider.setDataFetched(false);
                        // Navigator.of(context).pushNamed("/pendanaanUMKM");
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return PendanaanUMKM(
                              market_id: combinedData.market.market_id,
                              namaUmkm: combinedData.umkm.nama,
                              minimal_biaya: combinedData.ajuan.minimal_biaya,
                              sisa: combinedData.ajuan.besar_biaya -
                                  combinedData.market.dana_terkumpul);
                        }));
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(32, 106, 93, 1),
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                      ),
                      child: Text('DANAI',
                          style: TextStyle(fontSize: 17, color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
