import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lender-success-pencairan.dart';

class PencairanDanaLender extends StatelessWidget {
  const PencairanDanaLender({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Pendanaan UMKM",
        theme: ThemeData(primarySwatch: Colors.teal),
        home: Scaffold(
            body: Container(
                // margin: EdgeInsets.symmetric(horizontal: 30),
                // padding: EdgeInsets.only(left: 30, right: 30),
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 30.0,
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Image.asset(
                  'icons/icon-cairkan.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  "Cairkan Dana",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, bottom: 15, top: 35),
              child: Container(
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                      hintText: "Nomor Rekening",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ), // Menyesuaikan ukuran teks
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: Row(
                children: [
                  Text(
                    "Nominal",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
              child: Container(
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    prefixText: 'Rp ',
                  ),
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ), // Menyesuaikan ukuran teks
                ),
              ),
            ),
            Container(
              color: Color.fromRGBO(191, 220, 174, 1),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 40, right: 30),
                    child: Row(
                      children: [
                        Text(
                          "Rekening Sumber",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(32, 106, 93, 1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 20, left: 30, right: 30),
                    child: Container(
                      // color: Color.fromRGBO(191, 220, 174, 1),
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      // margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saku Modal In',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '8632458732423',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Rp 178.256.438,00',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Color.fromRGBO(0, 177, 71, 1)),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return LenderSuccessPencairan();
                  }));
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          25), // Mengatur sudut melengkung
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all(Color.fromRGBO(32, 106, 93, 1)),
                  minimumSize: MaterialStateProperty.all(Size(290, 50)),
                  padding: MaterialStateProperty.all(EdgeInsets.all(17)),
                ),
                child: Text('LANJUTKAN',
                    style: TextStyle(fontSize: 17, color: Colors.white)),
              ),
            ),
          ],
        ))));
  }
}
