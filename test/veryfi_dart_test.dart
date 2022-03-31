//Veryfi imports
import 'package:veryfi_dart/exception/veryfi_exception.dart';
import 'package:veryfi_dart/veryfi_dart.dart';
import 'veryfi_dart_test.mocks.dart';

//Dart imports
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

//Third party imports
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

//Test imports
import 'package:flutter_test/flutter_test.dart';

@GenerateMocks([VeryfiDart])
void main() {
  const int documentId = 63480993;
  const String clientId = 'clientId';
  const String clientSecret = 'clientSecret';
  const String username = 'devapitest';
  const String apiKey = 'apiKey';
  const mockResponses =
      true; //Disable if you want to test with your credentials
  VeryfiDart veryfiDart = VeryfiDart(clientId, clientSecret, username, apiKey);

  test('Test GET Documents', () async {
    final client = mockResponses ? MockVeryfiDart() : veryfiDart;
    if (mockResponses) {
      final String rawResponse =
          await File('test/resources/getDocuments.json').readAsString();
      final Map<String, dynamic> mockResponse = jsonDecode(rawResponse);
      when(client.getDocuments()).thenAnswer((_) => Future(() => mockResponse));
    }
    await client.getDocuments().then(
      (response) {
        assert(response.length >= 2);
      },
    ).catchError((error) {
      assert(false);
    });
  });

  test('Test GET Document by id', () async {
    final client = mockResponses ? MockVeryfiDart() : veryfiDart;
    if (mockResponses) {
      final String rawResponse =
          await File('test/resources/getDocument.json').readAsString();
      final Map<String, dynamic> mockResponse = jsonDecode(rawResponse);
      when(client.getDocumentById(documentId.toString()))
          .thenAnswer((_) => Future(() => mockResponse));
    }
    await client.getDocumentById(documentId.toString()).then(
      (response) {
        if (mockResponses) {
          assert(response.length >= 2);
        } else {
          expect(response['id'], documentId);
        }
      },
    ).catchError((error) {
      assert(false);
    });
  });

  test('Test DELETE Document', () async {
    var documentIdToDelete = '';
    final client = mockResponses ? MockVeryfiDart() : veryfiDart;
    if (mockResponses) {
      final String rawProcessResponse =
          await File('test/resources/processDocument.json').readAsString();
      final Map<String, dynamic> processResponse =
          jsonDecode(rawProcessResponse);
      when(client.processDocumentFromURL(
              fileUrl:
                  'https://veryfi-testing-public.s3.us-west-2.amazonaws.com/receipt.jpg'))
          .thenAnswer((_) => Future(() => processResponse));
    }
    await client
        .processDocumentFromURL(
            fileUrl:
                'https://veryfi-testing-public.s3.us-west-2.amazonaws.com/receipt.jpg')
        .then(
      (response) {
        assert(response['id'] != null);
        assert(response['id'] != '');
        documentIdToDelete = response['id'].toString();
      },
    ).catchError((error) {
      assert(false);
    });

    if (documentIdToDelete != '') {
      if (mockResponses) {
        final String rawDeleteResponse =
            await File('test/resources/deleteDocument.json').readAsString();
        final Map<String, dynamic> deleteResponse =
            jsonDecode(rawDeleteResponse);
        when(client.deleteDocument(documentIdToDelete))
            .thenAnswer((_) => Future(() => deleteResponse));
      }
      await client.deleteDocument(documentIdToDelete).then(
        (response) {
          assert(response.length >= 2);
        },
      ).catchError((error) {
        assert(false);
      });
    }
  });

  test('Test PUT Document', () async {
    Random random = Random();
    int randomNumber = random.nextInt(999);
    final Map<String, dynamic> body = {'notes': 'Test $randomNumber'};
    final client = mockResponses ? MockVeryfiDart() : veryfiDart;

    if (mockResponses) {
      final String rawResponse =
          await File('test/resources/updateDocument.json').readAsString();
      final Map<String, dynamic> mockResponse = jsonDecode(rawResponse);
      when(client.updateDocument(documentId.toString(), body))
          .thenAnswer((_) => Future(() => mockResponse));
    }

    await client.updateDocument(documentId.toString(), body).then(
      (response) {
        if (mockResponses) {
          assert(response.length >= 2);
        } else {
          expect(response['notes'], 'Test $randomNumber');
        }
      },
    ).catchError((error) {
      assert(false);
    });
  });

  test('Test POST Document with URL', () async {
    final client = mockResponses ? MockVeryfiDart() : veryfiDart;

    if (mockResponses) {
      final String rawResponse =
          await File('test/resources/processDocument.json').readAsString();
      final Map<String, dynamic> mockResponse = jsonDecode(rawResponse);
      when(client.processDocumentFromURL(
              fileUrl:
                  'https://veryfi-testing-public.s3.us-west-2.amazonaws.com/receipt.jpg'))
          .thenAnswer((_) => Future(() => mockResponse));
    }

    await client
        .processDocumentFromURL(
            fileUrl:
                'https://veryfi-testing-public.s3.us-west-2.amazonaws.com/receipt.jpg')
        .then(
      (response) {
        expect(response['vendor']['name'].toString().toLowerCase(),
            'in-n-out burger');
      },
    ).catchError((error) {
      assert(false);
    });
  });

  test('Test POST Document with File', () async {
    final File file = File('test/resources/receipt.jpeg');
    const fileName = 'receipt.jpg';
    final Uint8List imageData = file.readAsBytesSync();
    String fileData = base64Encode(imageData);
    final client = mockResponses ? MockVeryfiDart() : veryfiDart;

    if (mockResponses) {
      final String rawResponse =
          await File('test/resources/processDocument.json').readAsString();
      final Map<String, dynamic> mockResponse = jsonDecode(rawResponse);
      when(client.processDocument(fileName, fileData))
          .thenAnswer((_) => Future(() => mockResponse));
    }

    await client.processDocument(fileName, fileData).then(
      (response) {
        expect(response['vendor']['name'].toString().toLowerCase(),
            'in-n-out burger');
      },
    ).catchError((error) {
      assert(false);
    });
  });

  test('Test Exception', () async {
    const errorType = APIError.serverError;
    const statusCode = 500;
    const response = '{"error": "error}';

    final exception = VeryfiException(errorType, statusCode, response);
    expect(exception.errorType, errorType);
    expect(exception.statusCode, statusCode);
    expect(exception.response, response);
  });

  test('Test Bad Credentials', () async {
    final veryfiDart =
        VeryfiDart("clientId", "clientSecret", "username", "apiKey");
    await veryfiDart.getDocuments().then(
      (response) {
        assert(false);
      },
    ).catchError((error) {
      assert(true);
    });
  });
}
