import 'package:flutter/material.dart';
import 'borrower-register.dart';
import 'lender-register.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HalamanUtama(),
    );
  }
}

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.teal),
        title: "Modal In | Login",
        home: Scaffold(
            body: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
                child: Text(
              "Modal In",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            )),
            Center(
                child: Text(
              "Lorem ipsum dolor sit amet.",
              style: TextStyle(fontSize: 25),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Center(
                  child: Text(
                "Silahkan login menggunakan akun Modal In anda",
                style: TextStyle(fontSize: 17),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    // Add your text click logic here
                  },
                  child: Text(
                    'Lupa password?',
                    style: TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                )),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your button press logic here
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          minimumSize: Size(100, 50),
                          backgroundColor: Color.fromRGBO(32, 106, 93, 1),
                          foregroundColor: Colors.white),
                      child: Text(
                        'MASUK',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(
                  child: Text(
                "Belum memiliki akun?",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return RegisterLender();
                        }));
                        // Add your button 1 press logic here
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minimumSize: Size(50, 90),
                          backgroundColor: Color.fromRGBO(32, 106, 93, 1),
                          foregroundColor: Colors.white),
                      child: Column(
                        children: [
                          Text(
                            'Daftar Sebagai',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Pendana',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '(Lender)',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w700),
                          ),
                        ],
                      )),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return RegisterBorrower();
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            minimumSize: Size(50, 90),
                            backgroundColor: Color.fromRGBO(32, 106, 93, 1),
                            foregroundColor: Colors.white),
                        child: Column(
                          children: [
                            Text(
                              'Daftar Sebagai',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Peminjam',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '(Borrower)',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w700),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            )
          ]),
        )));
  }
}
