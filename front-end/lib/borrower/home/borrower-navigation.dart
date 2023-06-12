import 'package:coba_android_studio/borrower/account/borrower-cs.dart';
import 'package:flutter/material.dart';
import '../home/borrower-home.dart';
import '../activity/borrower-activity.dart';
import '../wallet/borrower-wallet.dart';
import '../wallet/borrower-isi-saldo.dart';
import '../wallet/borrower-pembayaran.dart';
import '../wallet/borrower-pencairan-dana.dart';
import '../success-notice/borrower-success-topup.dart';
import '../success-notice/borrower-success-pembayaran.dart';
import '../success-notice/borrower-success-pencairan.dart';
import '../account/borrower-account.dart';
import '../account/borrower-delete-account.dart';
import 'borrower-ajukan-pinjaman.dart';
import 'borrower-tutorial-pinjaman.dart';

class BorrowerPage extends StatefulWidget {
  const BorrowerPage({Key? key}) : super(key: key);
  @override
  BorrowerPageState createState() {
    return BorrowerPageState();
  }
}

class BorrowerPageState extends State<BorrowerPage> {
  List<Widget> pages = [
    HomePage(),
    ActivityPage(),
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
        '/borrowerPage': (context) => BorrowerPage(),
        '/tutorialPinjaman': (context) => TutorialPinjaman(),
        '/formPengajuan': (context) => AjukanPinjamanPage(),

        /* WALLET */
        '/walletPage': (context) => WalletPage(),
        '/topUp': (context) => IsiSaldoBorrower(),
        '/bayar': (context) => PembayaranBorrower(),
        '/pencairanDana': (context) => PencairanDanaBorrower(),

        /* SUCCESS NOTICE */
        '/successTopup': (context) => BorrowerSuccessTopup(),
        '/successPayment': (context) => BorrowerSuccessPayment(),
        '/successPencairan': (context) => BorrowerSuccessPencairan(),

        /* ACCOUNT */
        '/deleteAcc': (context) => DeleteAccountPage(),
        '/helpCs': (context) => HelpPage(),
      },
    );
  }
}
