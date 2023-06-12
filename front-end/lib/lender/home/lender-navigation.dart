import 'package:flutter/material.dart';
import 'lender-home.dart';
import '../marketplace/lender-marketplace.dart';
import '../marketplace/lender-pendanaan-umkm.dart';
import '../wallet/lender-wallet.dart';
import '../wallet/lender-pencarian-dana.dart';
import '../wallet/lender-isi-saldo.dart';
import '../activity/lender-activity.dart';
import '../account/lender-account.dart';
import '../account/lender-notification.dart';
import '../account/lender-delete-account.dart';
import '../account/lender-cs.dart';
import '../success-notice/lender-success-pembayaran.dart';
import '../success-notice/lender-success-pencairan.dart';
import '../success-notice/lender-success-topup.dart';

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
              icon: Icon(Icons.festival_outlined, color: Colors.black),
              label: 'Marketplace',
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
        /* HOME */
        '/lenderPage': (context) => LenderPage(),

        /* MARKETPLACE */
        '/marketplace': (context) => MarketplacePage(),
        '/detailsMarket': (context) => DetailUMKM(),
        '/pendanaanUMKM': (context) => PendanaanUMKM(),

        /* WALLET */
        '/walletPage': (context) => WalletPage(),
        '/topUp': (context) => IsiSaldoLender(),
        '/pencairanDana': (context) => PencairanDanaLender(),

        /* SUCCESS NOTICE */
        '/successPayment': (context) => LenderSuccessPayment(),
        '/successPencairan': (context) => LenderSuccessPencairan(),
        '/successTopup': (context) => LenderSuccessTopup(),

        /* ACCOUNT */
        '/deleteAcc': (context) => DeleteAccountPage(),
        '/helpCs': (context) => HelpPage(),
      },
    );
  }
}
