// dependencies:
//  dio: ^5.2.1+1
//  image_picker: ^0.8.4+2
//  http_parser: ^4.0.2

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String namaImage = "";

  final dio = Dio();

  Future<String> uploadFile(List<int> file, String fileName) async {
    print("mulai");
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(file,
          filename: fileName, contentType: MediaType("image", "png")),
    });
    var response =
        //untuk chorme
        await dio.post("http://127.0.0.1:8000/uploadimage", data: formData);

    //untuk android
    //await dio.post("http://10.0.2.2:8000/uploadimage", data: formData);

    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        namaImage = fileName;
      });
    }
    return fileName;
  }

  Future<void> _getImageFromGallery() async {
    print("get image");
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    final bytes = await pickedImage?.readAsBytes();
    if (pickedImage != null) {
      print("mulai upload");
      await uploadFile(bytes as List<int>, pickedImage.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Image Pijcker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            namaImage != ""
                ? Image.network(
                    //chrome
                    'http://127.0.0.1:8000/getimage/$namaImage',

                    //android
                    //'http://10.0.2.2:8000/getimage/$namaImage',
                    height: 200,
                  )
                : const Text(" Image Tidak Tersedia"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImageFromGallery,
              child: const Text('Select Image'),
            ),
          ],
        ),
      ),
    ));
  }
}
