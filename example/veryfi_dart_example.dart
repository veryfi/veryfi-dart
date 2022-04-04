import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:veryfi_dart/veryfi_dart.dart';

Future<void> main() async {
  await processDocument();
  await updateDocument();
}

Future<void> processDocument() async {
  String fileName = 'filename.jpg';
  File file = File(fileName);
  Uint8List imageData = file.readAsBytesSync();
  String fileData = base64Encode(imageData);
  VeryfiDart client = VeryfiDart(
      'yourClientId', 'yourClientSecret', 'yourUsername', 'yourApiKey');

  await client.processDocument(fileName, fileData).then(
    (response) {
      print('success');
    },
  ).catchError((error) {
    print('error');
  });
}

Future<void> updateDocument() async {
  VeryfiDart client = VeryfiDart(
      'yourClientId', 'yourClientSecret', 'yourUsername', 'yourApiKey');
  final Map<String, dynamic> params = {'notes': 'Test'};
  await client.updateDocument('123', params).then(
    (response) {
      print('success');
    },
  ).catchError((error) {
    print('error');
  });
}
