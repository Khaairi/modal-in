import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal),
        title: "Modal In | Login",
        home: Scaffold(
            body: Container(
          decoration: const BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(
                "images/background-opacity.png",
              ),
              fit: BoxFit.fitHeight,
            ),
          ),
          // margin: EdgeInsets.symmetric(horizontal: 30),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                child: Image.asset(
                  'images/logo-full.png',
                  // width: 350,
                  // height: 350,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Center(
                    child: Text(
                  "Modalin mimpimu, capai kesuksesan!",
                  style: TextStyle(fontSize: 20),
                )),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8), // Warna shadow
                      spreadRadius: 2, // Jarak penyebaran shadow
                      blurRadius: 5, // Jarak blur shadow
                      offset: Offset(0, 3), // Posisi offset shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
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
                              style:
                                  TextStyle(fontSize: 17, color: Colors.grey),
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
                                    backgroundColor:
                                        Color.fromRGBO(32, 106, 93, 1),
                                    foregroundColor: Colors.white),
                                child: Text(
                                  'MASUK',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
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
                          Navigator.of(context).pushNamed("/registerLender");
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
                                .pushNamed("/registerBorrower");
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
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                'Peminjam',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '(Borrower)',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              )
            ]),
          ),
        )));
  }
}
