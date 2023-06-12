import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  final List<Map<String, String>> faqList = [
    {
      'question': 'Bagaimana cara mengajukan pinjaman?',
      'answer':
          'Anda dapat mengajukan pinjaman dengan mengklik tombol "Ajukan Pinjaman" pada halaman utama aplikasi.'
    },
    {
      'question': 'Berapa lama proses persetujuan pinjaman?',
      'answer':
          'Proses persetujuan pinjaman biasanya memakan waktu 1-2 hari kerja setelah pengajuan diajukan.'
    },
    {
      'question': 'Bagaimana cara melihat status pengajuan pinjaman?',
      'answer':
          'Anda dapat melihat status pengajuan pinjaman dengan masuk ke menu "Pengajuan Saya" pada aplikasi.'
    },
    {
      'question': 'Apa yang harus dilakukan jika pinjaman ditolak?',
      'answer':
          'Jika pinjaman Anda ditolak, Anda dapat menghubungi layanan pelanggan kami untuk mendapatkan informasi lebih lanjut mengenai alasannya.'
    },
    {
      'question': 'Bagaimana cara mengubah jumlah pinjaman yang diajukan?',
      'answer':
          'Anda tidak dapat mengubah jumlah pinjaman yang diajukan setelah pengajuan dikirim. Anda perlu mengajukan pengajuan baru jika ingin mengubah jumlah pinjaman.'
    },
    {
      'question': 'Bagaimana cara melihat jadwal pembayaran pinjaman?',
      'answer':
          'Jadwal pembayaran pinjaman dapat dilihat di menu "Pinjaman Saya" pada aplikasi.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Pusat Bantuan',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FAQ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: faqList.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        faqList[index]['question']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            faqList[index]['answer']!,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                // Aksi ketika "Telepon Kami" ditekan
              },
              child: ListTile(
                leading: Icon(Icons.phone),
                title: Text('Telepon Kami'),
              ),
            ),
            InkWell(
              onTap: () {
                // Aksi ketika "Chat Kami" ditekan
              },
              child: ListTile(
                leading: Icon(Icons.chat),
                title: Text('Chat Kami'),
              ),
            ),
            InkWell(
              onTap: () {
                // Aksi ketika "Email Kami" ditekan
              },
              child: ListTile(
                leading: Icon(Icons.email),
                title: Text('Email Kami'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
