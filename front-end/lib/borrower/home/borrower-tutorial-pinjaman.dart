import 'package:flutter/material.dart';

//button cara melakukan pinjaman (finish)
class TutorialPinjaman extends StatelessWidget {
  const TutorialPinjaman({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'Bantuan',
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 0, 0, 0)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cara Mengajukan',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Pinjaman',
                        style: TextStyle(
                          color: Color.fromRGBO(32, 106, 93, 1),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' di Modal In',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 15.0)),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Para peminjam, sebelum Anda melakukan pinjaman, mohon pastikan bahwa Anda telah memenuhi semua persyaratan dokumen yang dapat Anda lengkapi di dalam akun Anda. Harap dicatat bahwa peminjaman tidak dapat dilakukan jika dokumen belum terisi dengan lengkap.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 15.0)),
              Row(
                children: [
                  SizedBox(height: 50),
                  _buildNumberWithBackground('1', Colors.green),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Dokumen Persyaratan.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(191, 220, 174, 1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Berikut merupakan dokumen yang diperlukan sebelum melakukan pinjaman:\n'
                  '1. Foto UMKM (Banner)\n'
                  '2. NO. NPWP\n'
                  '3. Rekening Bank\n'
                  '4. Pendapatan per Tahun\n'
                  '5. Dokumen Perizinan UMK',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 15.0)),
              Row(
                children: [
                  SizedBox(height: 50),
                  _buildNumberWithBackground('2', Colors.green),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pengajuan Pinjaman.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(191, 220, 174, 1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Agar Anda dapat mengajukan peminjaman, ikuti langkah-langkah berikut dengan seksama:\n'
                  '1. Pastikan Anda telah mendaftar sebagai peminjam.\n'
                  '2. Pastikan Anda telah melengkapi seluruh data yang diperlukan sebagai peminjam.\n'
                  '3. Buka halaman utama (HOME) dan temukan tombol "Ajukan Pinjaman".\n'
                  '4. Isi formulir peminjaman dengan benar dan teliti.\n'
                  '5. Setelah selesai mengisi formulir, klik tombol "Ajukan Pinjaman".\n'
                  '6. Setelah pengajuan pinjaman Anda diajukan, tampilan halaman utama akan berubah dan menampilkan status "Menunggu Konfirmasi".\n'
                  '7. Jika pengajuan Anda diterima, tampilan halaman utama akan kembali berubah dan menampilkan informasi "Total Penerimaan" beserta tombol "Cairkan Pinjaman".\n'
                  '8. Selamat! Anda kini dapat melakukan pencairan dana pinjaman yang telah disetujui.\n',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 50.0)),
              Center(
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(32, 106, 93, 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.message,
                            color: Colors.white,
                            size: 60,
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Masih Punya\nPertanyaan?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Mulai chat dengan\nkami',
                                style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Tambahkan logika tombol chat di sini
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white, // Warna tombol putih
                          onPrimary: Colors.green, // Warna teks hijau
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text('Mulai Chat'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberWithBackground(String number, Color backgroundColor) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(8),
      child: Text(
        number,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
