import 'package:flutter/material.dart';
import '../home/lender-home.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          appBar:
              // PreferredSize(
              // preferredSize: Size(100, 50),
              // child:
              AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Aktivitas',
              style: TextStyle(color: Colors.black),
            ),
            bottom: TabBar(
              indicatorColor: Color.fromRGBO(32, 106, 93, 1),
              indicatorWeight: 3,
              indicatorPadding: const EdgeInsets.all(8),
              tabs: myTab,
            ),
            actions: <Widget>[
              ButtonNotification(),
            ],
          ),

          // ),
          body: TabBarView(
            children: [
              // Konten tab penerimaan
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
                      child: Text("Anda telah mencapai akhir mutasi penerimaan",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 13)),
                    ),
                  )
                ],
              ),
              // Konten tab pembayaran
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
                      child: Text("Anda telah mencapai akhir mutasi pembayaran",
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
        ),
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
