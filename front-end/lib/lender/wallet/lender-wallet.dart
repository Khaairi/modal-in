import 'package:flutter/material.dart';
import '../home/lender-home.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with TickerProviderStateMixin {
  // const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Saku',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          ButtonNotification(),
        ],
      ),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Color.fromRGBO(32, 106, 93, 1), width: 1),
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
                    'Rp. 100.000.000,00',
                    style: TextStyle(
                        color: Color.fromRGBO(0, 177, 71, 1),
                        fontWeight: FontWeight.normal,
                        fontSize: 25),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            'No VA : xxxxxxxx',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.pushNamed(context, "/sec");
                          },
                          child: Icon(
                            Icons.copy,
                            size: 15,
                          ),
                        )
                      ],
                    ),
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
                        Navigator.of(context).pushNamed("/topUp");
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
                        Navigator.of(context).pushNamed("/pencairanDana");
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
            child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
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
          Container(
            width: double.maxFinite,
            height: 330,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Konten Sejarah Top Up
                ListView(
                  padding: EdgeInsets.all(8),
                  children: [
                    TransactionHistoryItem(
                      icon: Icon(Icons.attach_money),
                      senderName: 'John Doe',
                      paymentMethod: 'Transfer Bank',
                      date: 'Senin, 17 Mei 2023',
                      amount: '100,000',
                      isPositive: true,
                    ),
                    SizedBox(height: 8),
                    TransactionHistoryItem(
                      icon: Icon(Icons.attach_money),
                      senderName: 'Jane Smith',
                      paymentMethod: 'OVO',
                      date: 'Selasa, 18 Mei 2023',
                      amount: '250,000',
                      isPositive: true,
                    ),
                    SizedBox(height: 8),
                    TransactionHistoryItem(
                      icon: Icon(Icons.attach_money),
                      senderName: 'Michael Johnson',
                      paymentMethod: 'GoPay',
                      date: 'Rabu, 19 Mei 2023',
                      amount: '500,000',
                      isPositive: true,
                    ),
                    SizedBox(height: 8),
                    TransactionHistoryItem(
                      icon: Icon(Icons.attach_money),
                      senderName: 'Sarah Williams',
                      paymentMethod: 'Dana',
                      date: 'Kamis, 20 Mei 2023',
                      amount: '750,000',
                      isPositive: true,
                    ),
                    SizedBox(height: 8),
                    TransactionHistoryItem(
                      icon: Icon(Icons.attach_money),
                      senderName: 'David Lee',
                      paymentMethod: 'LinkAja',
                      date: 'Jumat, 21 Mei 2023',
                      amount: '1,000,000',
                      isPositive: true,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Text(
                            "Anda telah mencapai akhir mutasi penerimaan",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 13)),
                      ),
                    )
                  ],
                ),
                // Konten Sejarah Pencairan Dana
                ListView(
                  padding: EdgeInsets.all(8),
                  children: [
                    TransactionHistoryItem(
                      icon: Icon(Icons.money_off),
                      senderName: 'Alice Johnson',
                      paymentMethod: 'Transfer Bank',
                      date: 'Senin, 24 Mei 2023',
                      amount: '200,000',
                      isPositive: false,
                    ),
                    SizedBox(height: 8),
                    TransactionHistoryItem(
                      icon: Icon(Icons.money_off),
                      senderName: 'Bob Smith',
                      paymentMethod: 'OVO',
                      date: 'Selasa, 25 Mei 2023',
                      amount: '350,000',
                      isPositive: false,
                    ),
                    SizedBox(height: 8),
                    TransactionHistoryItem(
                      icon: Icon(Icons.money_off),
                      senderName: 'Emily Davis',
                      paymentMethod: 'GoPay',
                      date: 'Rabu, 26 Mei 2023',
                      amount: '600,000',
                      isPositive: false,
                    ),
                    SizedBox(height: 8),
                    TransactionHistoryItem(
                      icon: Icon(Icons.money_off),
                      senderName: 'Jack Wilson',
                      paymentMethod: 'Dana',
                      date: 'Kamis, 27 Mei 2023',
                      amount: '900,000',
                      isPositive: false,
                    ),
                    SizedBox(height: 8),
                    TransactionHistoryItem(
                      icon: Icon(Icons.money_off),
                      senderName: 'Olivia Brown',
                      paymentMethod: 'LinkAja',
                      date: 'Jumat, 28 Mei 2023',
                      amount: '1,200,000',
                      isPositive: false,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Text(
                            "Anda telah mencapai akhir mutasi pembayaran",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 13)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class TransactionHistoryItem extends StatelessWidget {
  final Icon icon;
  final String senderName;
  final String paymentMethod;
  final String date;
  final String amount;
  final bool isPositive;

  const TransactionHistoryItem({
    required this.icon,
    required this.senderName,
    required this.paymentMethod,
    required this.date,
    required this.amount,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    String formattedAmount = (isPositive ? '+ ' : '- ') + 'Rp. ' + amount;

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
          Text(paymentMethod),
        ],
      ),
      subtitle: Text(date),
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
