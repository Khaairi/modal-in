import 'package:flutter/material.dart';
import 'borrower-activity.dart';
import 'borrower-wallet.dart';
import 'borrower-ajukan-pinjaman.dart';
import 'borrower-tutorial-pinjaman.dart';

class BorrowerPage extends StatefulWidget {
  const BorrowerPage({Key? key, required this.id}) : super(key: key);
  final int id;
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
      WalletPage(id: widget.id), // Pass the id value to WalletPage
      AccountPage(),
    ];
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
                  text: 'Peminjam',
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
            ButtonNotification(),
          ],
        ),
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
        '/sec': (context) => AjukanPinjamanPage(),
        '/third': (context) => TutorialPinjaman(),
        // '/success': (context) => HalamanUtama(),
      },
    );
  }
}

class ButtonNotification extends StatelessWidget {
  const ButtonNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.circle_notifications, color: Colors.black, size: 30),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage()),
        );
      },
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Notification Page',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Text(
          'Halaman Notifikasi',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
          //  SizedBox(height: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 3),
                // decoration: BoxDecoration(border: Border.all()),
                //  padding: EdgeInsets.all(10),
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
                          Navigator.pushNamed(context, '/sec');
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  25), // Mengatur sudut melengkung
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(32, 106, 93, 1)),
                          minimumSize: MaterialStateProperty.all(Size(290, 50)),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(17)),
                        ),
                        child: Text('AJUKAN PINJAMAN',
                            style:
                                TextStyle(fontSize: 17, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 3, left: 15),
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
                          Navigator.pushNamed(context, '/third');
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  25), // Mengatur sudut melengkung
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(32, 106, 93, 1),
                          ),
                          minimumSize: MaterialStateProperty.all(Size(290, 50)),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(17)),
                        ),
                        child: Text('CARA MELAKUKAN PINJAMAN',
                            style:
                                TextStyle(fontSize: 17, color: Colors.white)),
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 150),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 9,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Container(
                      width: 240,
                      height: 240,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 71, 38, 38)
                                .withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(5, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}/9',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 80),
        ],
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Center(
        child: Text('Halaman Account'),
      ),
    );
  }
}
