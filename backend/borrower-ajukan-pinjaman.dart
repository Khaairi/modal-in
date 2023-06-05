import 'package:flutter/material.dart';
import 'borrower-success-pengajuan.dart';

//buat Form Ajukan sama pop up Kalkulator (belum finish pop up nya)
class AjukanPinjamanPage extends StatelessWidget {
  const AjukanPinjamanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromARGB(255, 254, 254, 254),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  'Form Pengajuan',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 1),
                child: Text(
                  ' Pinjaman',
                  style: TextStyle(
                      color: Color.fromRGBO(32, 106, 93, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(40),
              children: [
                FormColumn(
                  label: '',
                  text: 'Besar Biaya',
                ),
                SizedBox(height: 10),
                FormColumn(
                  label: '*dalam minggu',
                  text: 'Tenor Pendanaan',
                ),
                SizedBox(height: 10),
                FormColumn(
                  label: '',
                  text: 'Minimal Biaya',
                ),
                SizedBox(height: 10),
                DropdownFormField(
                  label: '',
                  // text: 'Opsi Pengembalian',
                  options: ['Option 1', 'Option 2', 'Option 3'],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 55, left: 130),
                  // left: 0,
                  // right: 200,
                  child: Text(
                    'Kalkulator Peminjaman',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 55, left: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 214, 220, 215),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.only(right: 2),
                        icon: Icon(Icons.calculate_rounded,
                            size: 30,
                            color: const Color.fromARGB(255, 7, 7, 7)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(255, 193, 237, 195),
                                title: Row(
                                  children: [
                                    Text('Kalkulator Pinjaman'),
                                    SizedBox(width: 5),
                                    // Text(
                                    //   '(Addition)',
                                    //   style: TextStyle(
                                    //       fontSize: 14, color: Colors.grey),
                                    // ),
                                    // Container(
                                    //   margin: EdgeInsets.only(top: 30),
                                    //   child: Text(
                                    //     'Kalkulator Peminjaman',
                                    //     style: TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.normal,
                                    //       color: Colors.black,
                                    //     ),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   margin: EdgeInsets.only(top: 70, left: 4),
                                    //   child: Text(
                                    //     'Teks Baru',
                                    //     style: TextStyle(
                                    //       fontSize: 14,
                                    //       fontWeight: FontWeight.normal,
                                    //       color: Colors.black,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                          labelText: 'Number 1'),
                                      keyboardType: TextInputType.number,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          labelText: 'Number 2'),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Calculate'),
                                    onPressed: () {
                                      // Perform calculation
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 150),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return BorrowerSuccessPengajuan();
                }));
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25), // Mengatur sudut melengkung
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all(Color.fromRGBO(32, 106, 93, 1)),
                minimumSize: MaterialStateProperty.all(Size(320, 50)),
                padding: MaterialStateProperty.all(EdgeInsets.all(10)),
              ),
              child: Text('AJUKAN PINJAMAN',
                  style: TextStyle(fontSize: 17, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}

class DropdownFormField extends StatefulWidget {
  final String label;
  final List<String> options;

  const DropdownFormField({
    required this.label,
    required this.options,
    Key? key,
  }) : super(key: key);

  @override
  _DropdownFormFieldState createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends State<DropdownFormField> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedOption,
          onChanged: (newValue) {
            setState(() {
              selectedOption = newValue;
            });
          },
          decoration: InputDecoration(
            hintText: selectedOption ?? 'Opsi Pengembalian',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 0, 0, 0),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 130, 128, 128),
                width: 1.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
          ),
          items: widget.options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class FormColumn extends StatelessWidget {
  final String label;
  final String text;

  const FormColumn({
    Key? key,
    required this.label,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromARGB(255, 54, 51, 51),
          ),
        ),
        TextFormField(
          initialValue: text,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ],
    );
  }
}
