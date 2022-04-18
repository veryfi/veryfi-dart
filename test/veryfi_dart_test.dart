//Veryfi imports
import 'package:veryfi_dart/src/constants/constants.dart';
import 'package:veryfi_dart/src/exception/veryfi_exception.dart';
import 'package:veryfi_dart/src/model/add_line_item.dart';
import 'package:veryfi_dart/src/model/update_line_item.dart';
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
import 'package:http/http.dart' as http;

//Test imports
import 'package:test/test.dart';

@GenerateMocks([http.Client])
void main() {
  const int documentId = 63480993;
  const int lineItemId = 190399931;
  const String clientId = 'clientId';
  const String clientSecret = 'clientSecret';
  const String username = 'username';
  const String apiKey = 'apiKey';
  const mockResponses = Constants
      .mockHttpForTesting; //Disable in Constants.dart if you want to test with your credentials
  VeryfiDart veryfiDart = VeryfiDart(clientId, clientSecret, username, apiKey);

  group("Document -> ", () {
    test('Test GET Documents', () async {
      if (mockResponses) {
        final String rawResponse =
            await File('test/resources/getDocuments.json').readAsString();
        final http.Response response = http.Response(rawResponse, 200);
        final mockClient = MockClient();
        veryfiDart.injectMockHttpClient(mockClient);
        when(mockClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) => Future(() => response));
      }
      await veryfiDart.getDocuments().then(
        (response) {
          assert(response.length >= 2);
        },
      ).catchError((error) {
        assert(false);
      });
    });

    test('Test GET Document by id', () async {
      if (mockResponses) {
        final String rawResponse =
            await File('test/resources/getDocument.json').readAsString();
        final http.Response response = http.Response(rawResponse, 200);
        final mockClient = MockClient();
        veryfiDart.injectMockHttpClient(mockClient);
        when(mockClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) => Future(() => response));
      }
      await veryfiDart.getDocumentById(documentId.toString()).then(
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
      if (mockResponses) {
        final String rawProcessResponse =
            await File('test/resources/processDocument.json').readAsString();
        final http.Response processResponse =
            http.Response(rawProcessResponse, 200);
        final mockClient = MockClient();
        veryfiDart.injectMockHttpClient(mockClient);
        when(mockClient.post(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer((_) => Future(() => processResponse));
      }
      await veryfiDart
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
          final http.Response deleteResponse =
              http.Response(rawDeleteResponse, 200);
          final mockClient = MockClient();
          veryfiDart.injectMockHttpClient(mockClient);
          when(mockClient.delete(any, headers: anyNamed('headers')))
              .thenAnswer((_) => Future(() => deleteResponse));
        }
        await veryfiDart.deleteDocument(documentIdToDelete).then(
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

      if (mockResponses) {
        final String rawResponse =
            await File('test/resources/updateDocument.json').readAsString();
        final http.Response response = http.Response(rawResponse, 200);
        final mockClient = MockClient();
        veryfiDart.injectMockHttpClient(mockClient);
        when(mockClient.put(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer((_) => Future(() => response));
      }

      await veryfiDart.updateDocument(documentId.toString(), body).then(
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
      if (mockResponses) {
        final String rawResponse =
            await File('test/resources/processDocument.json').readAsString();
        final http.Response response = http.Response(rawResponse, 200);
        final mockClient = MockClient();
        veryfiDart.injectMockHttpClient(mockClient);
        when(mockClient.post(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer((_) => Future(() => response));
      }

      await veryfiDart
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

      if (mockResponses) {
        final String rawResponse =
            await File('test/resources/processDocument.json').readAsString();
        final http.Response response = http.Response(rawResponse, 200);
        final mockClient = MockClient();
        veryfiDart.injectMockHttpClient(mockClient);
        when(mockClient.post(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer((_) => Future(() => response));
      }

      await veryfiDart.processDocument(fileName, fileData).then(
        (response) {
          expect(response['vendor']['name'].toString().toLowerCase(),
              'in-n-out burger');
        },
      ).catchError((error) {
        assert(false);
      });
    });
  });

  group("Line items -> ", () {
    test('Test GET Document lineitems', () async {
      if (mockResponses) {
        final String rawResponse =
            await File('test/resources/getDocumentLineItems.json')
                .readAsString();
        final http.Response response = http.Response(rawResponse, 200);
        final mockClient = MockClient();
        veryfiDart.injectMockHttpClient(mockClient);
        when(mockClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) => Future(() => response));
      }
      await veryfiDart.getDocumentLineItems(documentId.toString()).then(
        (response) {
          assert(response['line_items'] != null);
        },
      ).catchError((error) {
        assert(false);
      });
    });

    test('Test GET Lineitem', () async {
      if (mockResponses) {
        final String rawResponse =
            await File('test/resources/getLineItem.json').readAsString();
        final http.Response response = http.Response(rawResponse, 200);
        final mockClient = MockClient();
        veryfiDart.injectMockHttpClient(mockClient);
        when(mockClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) => Future(() => response));
      }
      await veryfiDart
          .getLineItem(documentId.toString(), lineItemId.toString())
          .then(
        (response) {
          assert(response.length >= 2);
          assert(response['id'] == lineItemId);
        },
      ).catchError((error) {
        assert(false);
      });
    });

    test('Test POST Lineitem', () async {
      final body = AddLineItem(20, 'Test', 44.0);
      body.sku = 'testsku';
      if (mockResponses) {
        final String rawResponse =
            await File('test/resources/addLineItem.json').readAsString();
        final http.Response response = http.Response(rawResponse, 200);
        final mockClient = MockClient();
        veryfiDart.injectMockHttpClient(mockClient);
        when(mockClient.post(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer((_) => Future(() => response));
      }
      await veryfiDart.addLineItem(documentId.toString(), body).then(
        (response) {
          if (mockResponses) {
            assert(response.length >= 2);
          } else {
            expect(response['total'], body.total);
            expect(response['description'], body.description);
          }
        },
      ).catchError((error) {
        assert(false);
      });
    });
    test('Test PUT Lineitem', () async {
      Random random = Random();
      int randomNumber = random.nextInt(999);
      final body = UpdateLineItem();
      body.description = 'Test $randomNumber';

      if (mockResponses) {
        final String rawResponse =
            await File('test/resources/updateLineItem.json').readAsString();
        final http.Response response = http.Response(rawResponse, 200);
        final mockClient = MockClient();
        veryfiDart.injectMockHttpClient(mockClient);
        when(mockClient.put(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer((_) => Future(() => response));
      }
      await veryfiDart
          .updateLineItem(documentId.toString(), lineItemId.toString(), body)
          .then(
        (response) {
          if (mockResponses) {
            assert(response.length >= 2);
          } else {
            expect(response['id'], lineItemId);
            expect(response['description'], body.description);
          }
        },
      ).catchError((error) {
        assert(false);
      });
    });

    test('Test DELETE Document line items', () async {
      var documentIdToDelete = '';
      if (mockResponses) {
        final String rawProcessResponse =
            await File('test/resources/processDocument.json').readAsString();
        final http.Response processResponse =
            http.Response(rawProcessResponse, 200);
        final mockClient = MockClient();
        veryfiDart.injectMockHttpClient(mockClient);
        when(mockClient.post(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer((_) => Future(() => processResponse));
      }
      await veryfiDart
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
              await File('test/resources/deleteDocumentLineItems.json')
                  .readAsString();
          final http.Response deleteResponse =
              http.Response(rawDeleteResponse, 200);
          final mockClient = MockClient();
          veryfiDart.injectMockHttpClient(mockClient);
          when(mockClient.delete(any, headers: anyNamed('headers')))
              .thenAnswer((_) => Future(() => deleteResponse));
        }
        await veryfiDart.deleteDocumentLineItems(documentIdToDelete).then(
          (response) {
            assert(response.length >= 2);
          },
        ).catchError((error) {
          assert(false);
        });
      }
    });

    test('Test DELETE LineItem', () async {
      var lineItemIdToDelete = 0;
      final body = AddLineItem(20, 'Test', 44.4);
      body.sku = 'testsku';
      if (mockResponses) {
        final String rawResponse =
            await File('test/resources/addLineItem.json').readAsString();
        final http.Response response = http.Response(rawResponse, 200);
        final mockClient = MockClient();
        veryfiDart.injectMockHttpClient(mockClient);
        when(mockClient.post(any,
                headers: anyNamed('headers'), body: anyNamed('body')))
            .thenAnswer((_) => Future(() => response));
      }
      await veryfiDart.addLineItem(documentId.toString(), body).then(
        (response) {
          lineItemIdToDelete = response['id'];
        },
      ).catchError((error) {
        assert(false);
      });

      if (lineItemIdToDelete != 0) {
        if (mockResponses) {
          final String rawDeleteResponse =
              await File('test/resources/deleteDocumentLineItems.json')
                  .readAsString();
          final http.Response deleteResponse =
              http.Response(rawDeleteResponse, 200);
          final mockClient = MockClient();
          veryfiDart.injectMockHttpClient(mockClient);
          when(mockClient.delete(any, headers: anyNamed('headers')))
              .thenAnswer((_) => Future(() => deleteResponse));
        }
        await veryfiDart
            .deleteLineitem(
                documentId.toString(), lineItemIdToDelete.toString())
            .then(
          (response) {
            assert(response.length >= 2);
          },
        ).catchError((error) {
          assert(false);
        });
      }
    });
  });

  group("Utils -> ", () {
    test('Test Exception', () async {
      const errorType = APIError.serverError;
      const statusCode = 500;
      const response = '{"error": "error"}';

      final exception = VeryfiException(errorType, statusCode, response);
      expect(exception.errorType, errorType);
      expect(exception.statusCode, statusCode);
      expect(exception.response, response);
    });

    test('Test Bad Credentials', () async {
      final veryfiDart =
          VeryfiDart('clientId', 'clientSecret', 'username', 'apiKey');
      await veryfiDart.getDocuments().then(
        (response) {
          assert(false);
        },
      ).catchError((error) {
        assert(true);
      });
    });

    test('Test Signature', () async {
      final veryfiDart =
          VeryfiDart('clientId', 'clientSecret', 'username', 'apiKey');
      final Map<String, dynamic> params = {};
      final signature = veryfiDart.generateSignature(params);
      assert(signature.isNotEmpty);
    });

    test('Test Add Line Item to Map', () async {
      final model = AddLineItem(20, 'desc', 44);
      final map = model.toMap();
      expect(model.order, map['order']);
      expect(model.description, map['description']);
      expect(model.total, map['total']);
    });

    test('Test Update Line Item to Map', () async {
      final model = UpdateLineItem();
      model.total = 20;
      final map = model.toMap();
      expect(model.total, map['total']);
      expect(null, map['order']);
      expect(null, map['description']);
    });
  });
}
