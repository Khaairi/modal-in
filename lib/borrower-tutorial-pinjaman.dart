import 'package:flutter/material.dart';

//button cara melakukan pinjaman (finish)
class TutorialPinjaman extends StatelessWidget {
  const TutorialPinjaman({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromARGB(255, 254, 254, 254),
        title: Text(
          'Bantuan',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'Cara Mengajukan',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // decoration: BoxDecoration(border: Border.all()),
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'Pinjaman',
                      style: TextStyle(
                          color: Color.fromRGBO(32, 106, 93, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 0),
                    child: Text(
                      ' di Modal In',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // decoration: BoxDecoration(border: Border.all()),
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'Borrowers, sebelum meminjam pastikan kalian',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // decoration: BoxDecoration(border: Border.all()),
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'sudah bla bla bla loerm impsinm dan kawan',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 18, top: 25),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(32, 106, 93, 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 25),
                    child: Text(
                      'Pertama kalian harus bla bla bla bla bla ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 85, top: 10),
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 186, 228, 170),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 18, top: 25),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(32, 106, 93, 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        '2',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 25),
                    child: Text(
                      'Kedua kalian harus bla bla bla bla bla ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 85, top: 10),
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 186, 228, 170),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 0, top: 55),
                    width: 350,
                    height: 130,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(32, 106, 93, 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Icon(
                            Icons.message_outlined,
                            color: Colors.white,
                            size: 55,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Masih punya',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              Text(
                                'Pertanyaan ?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              Text(
                                'Mulai chat dengan',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17),
                              ),
                              Text(
                                'Orang kami',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17),
                              ),
                            ],

                            //'Masih punya',
                            // style: TextStyle(
                            //     color: Colors.white,
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 15),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.pushNamed(context, '/sec');
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      25), // Mengatur sudut melengkung
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 255, 255, 255)),
                              minimumSize:
                                  MaterialStateProperty.all(Size(110, 40)),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(10)),
                            ),
                            child: Text('Mulai Chat',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 56, 134, 44))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
