![Veryfi Logo](https://cdn.veryfi.com/logos/veryfi-logo-wide-github.png)

![Dart 2.16](https://img.shields.io/badge/Dart-2.16-orange.svg?style=flat)
[![code coverage](.github/metrics/coverage_badge.svg)](.github/metrics/coverage_badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

Dart module for communicating with the Veryfi OCR API

## Installation
Install from https://pub.dev.

## Getting Started

### Obtaining Client ID and user keys
If you don't have an account with Veryfi, please go ahead and register here: [https://hub.veryfi.com/signup/api/](https://hub.veryfi.com/signup/api/)

### Veryfi Dart Client Library
The **veryfi** library can be used to communicate with Veryfi API. All available functionality is described here: https://veryfi.github.io/veryfi-dart/

Below is the sample Dart code using **veryfi** to OCR and extract data from a document:

#### Import package:
```dart
import 'package:veryfi_dart/veryfi_dart.dart';
```

#### Process a document from file
```dart
Future<void> processDocument() async {
    String fileName = 'receipt.jpg';
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
```

#### Update a document
```dart
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
```

## Release
1. Create new branch for your code
2. Change version in `constants.dart` and `pubspec.yaml` with the same version.
3. Commit changes and push to Github
4. Create PR pointing to master branch and add a Veryfi member as a reviewer
5. Tag your commit with the new version
6. The new version will be accesible through Pub Dev.

## Need help?
If you run into any issue or need help installing or using the library, please contact support@veryfi.com.

If you found a bug in this library or would like new features added, then open an issue or pull requests against this repo!

To learn more about Veryfi visit https://www.veryfi.com/
