import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);
  //String selectedOption;
  @override
  Widget build(BuildContext context) {
    // String selectedOption;
    return Scaffold(
      // backgroundColor: Color.fromRGBO(191, 220, 174, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 0, top: 0),
                width: 400,
                height: 130,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(32, 106, 93, 1),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        // backgroundImage: AssetImage(
                        //     'assets/profile_image.jpg'), // Ganti dengan path gambar profil Anda
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 36),
                        Text(
                          'Nama Profile',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Rp.500.000',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              ExpansionTile(
                tilePadding: EdgeInsets.only(left: 40, right: 40),
                title: Container(
                  child: Text(
                    'Informasi Akun',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  padding: EdgeInsets.only(bottom: 10),
                  //SizedBox(height: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: const Color.fromARGB(255, 216, 215, 215),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(191, 220, 174, 1),
                      border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          width: 10.0),
                      borderRadius: BorderRadius.circular(20.0),
                      //  image: const EdgeInsets.only(left: 30),
                    ),
                    child: Column(
                      //   margin: EdgeInsets.only(),
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nama',
                            labelStyle: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nomor telepon',
                            labelStyle: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(32, 106, 93, 1)),
                                minimumSize:
                                    MaterialStateProperty.all(Size(150, 40)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(10)),
                              ),
                              child: Text(
                                'UBAH',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //
                  // SizedBox(height: 20),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 7,
                color: Color.fromRGBO(191, 220, 174, 1),
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.only(left: 40, right: 40),
                title: Container(
                  child: Text(
                    'Akun Bank',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: const Color.fromARGB(255, 216, 215, 215),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 10, right: 40),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Akun Bank',
                              labelStyle: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            items: <String>[
                              'opsi 1',
                              'opsi 2',
                              'opsi 3',
                              'opsi 4',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 40),
                          child: DropdownButtonFormField<String>(
                            //value: selectedOption,
                            decoration: InputDecoration(
                              labelText: 'Rekening',
                              labelStyle: TextStyle(
                                  fontFamily: 'Arial',
                                  // fontSize: String != null ? 14 : 14,
                                  fontSize:
                                      14, //kalo String dari valuenya udah ada nanti label bisa diubah size nya kaya yg dikomenin diatas
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            items: <String>[
                              'opsi 1',
                              'opsi 2',
                              'opsi 3',
                              'opsi 4',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {},
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  // SizedBox(height: 20),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 7,
                color: Color.fromRGBO(191, 220, 174, 1),
              ),
              Container(
                width: 400,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/helpCs');
                  },

                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(
                        255, 255, 255, 255), // Ubah warna latar belakang tombol
                    onPrimary:
                        Color.fromARGB(255, 0, 0, 0), // Ubah warna teks tombol
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    // Ubah ukuran teks tombol
                    padding: EdgeInsets.only(
                        left: 40, right: 40), // Ubah padding horizontal tombol

                    shadowColor: Colors.transparent,
                  ),
                  //
                  // icon: Icon(Icons.arrow_forward),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // margin: EdgeInsets.only(left: 40, right: 40),
                    children: [
                      Text('Customer Service'),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40, right: 77, top: 1, bottom: 8),
                height: 1,
                color: Color.fromARGB(255, 216, 215, 215),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 7,
                color: Color.fromRGBO(191, 220, 174, 1),
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.only(left: 40, right: 40),
                title: Container(
                  child: Text(
                    'Pengaturan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: const Color.fromARGB(255, 216, 215, 215),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                color: Color.fromRGBO(191, 220, 174, 1),
                padding:
                    EdgeInsets.only(left: 90, right: 90, top: 70, bottom: 90),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(32, 106, 93, 1)),
                        minimumSize: MaterialStateProperty.all(Size(290, 40)),
                        padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                      ),
                      child: Text('KELUAR'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/deleteAcc");
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(217, 6, 6, 1)),
                        minimumSize: MaterialStateProperty.all(Size(280, 40)),
                        padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                      ),
                      child: Text('HAPUS AKUN '),
                    ),
                  ],
                ),
              ),

              // SizedBox(height: 30),
              //  ),
            ],
          ),
        ),
      ),
    );
  }
}
