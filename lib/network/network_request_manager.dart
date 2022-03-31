//Veryfi imports
import 'package:veryfi_dart/exception/veryfi_exception.dart';
import 'package:veryfi_dart/constants/constants.dart';
import 'package:veryfi_dart/model/veryfi_credentials.dart';

//Dart imports
import 'dart:convert';

//Third party imports
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

enum HTTPMethod { get, post, put, delete }

enum APIPath { documents }

class NetworkRequestManager {
  final VeryfiCredentials credentials;
  final String apiVersion;
  final baseUrl = 'api.veryfi.com';

  NetworkRequestManager(this.credentials, this.apiVersion);

  /// API request.
  ///
  /// Returns a [Map] with the response of the http request to the API
  /// using the [method] [path] [queryItems] [body] and [queryItem]
  /// to build and perform the request.
  Future<Map<String, dynamic>> request(HTTPMethod method, APIPath path,
      {Map<String, dynamic>? queryItems,
      Map<String, dynamic>? body,
      String? queryItem}) async {
    final headers = getHeaders(body ?? {});
    var encodedPath = "api/" + apiVersion + pathEnumToUrl(path);
    if (queryItem != null && queryItem != "") {
      encodedPath = encodedPath + queryItem + "/";
    }
    final url = Uri.https(baseUrl, encodedPath, queryItems);

    switch (method) {
      case HTTPMethod.get:
        final getResponse = await http.get(url, headers: headers);
        return processResponse(getResponse);
      case HTTPMethod.post:
        final postResponse =
            await http.post(url, headers: headers, body: jsonEncode(body));
        return processResponse(postResponse);
      case HTTPMethod.put:
        final putResponse =
            await http.put(url, headers: headers, body: jsonEncode(body));
        return processResponse(putResponse);
      case HTTPMethod.delete:
        final deleteResponse = await http.delete(url, headers: headers);
        return processResponse(deleteResponse);
    }
  }

  /// Process response.
  ///
  /// Returns a [Map] if the response has a valid status code.
  /// available API paths.
  /// Throws a [VeryfiException] if there is an error.
  Map<String, dynamic> processResponse(Response response) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json;
    } else {
      throw VeryfiException(
          APIError.serverError, response.statusCode, json.toString());
    }
  }

  /// Get API Paths.
  ///
  /// Returns a [String] containing the API path from the enum of
  /// available API paths.
  String pathEnumToUrl(APIPath path) {
    switch (path) {
      case APIPath.documents:
        return '/partner/documents/';
    }
  }

  /// Get headers.
  ///
  /// Returns a [Map] containing the headers needed to authenticate the http
  /// requests to the Veryfi API using the credentials and the [params].
  Map<String, String> getHeaders(Map<String, dynamic> params) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final signature = generateSignature(params, timestamp.toString());
    final headers = {
      'User-Agent': 'Veryfi-Dart/${Constants.packageVersion}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Client-Id': credentials.clientId,
      'Authorization': 'apikey ${credentials.username}:${credentials.apiKey}',
      'X-Veryfi-Request-Timestamp': timestamp.toString(),
      'X-Veryfi-Request-Signature': signature
    };
    return headers;
  }

  /// Generate signature.
  ///
  /// Returns a [String] containing the signature from the [params] and
  /// current [timestamp] used to sign the http requests to the Veryfi API.
  String generateSignature(Map<String, dynamic> params, String timestamp) {
    Map<String, dynamic> rawParams = Map<String, dynamic>.from(params);
    rawParams['timestamp'] = timestamp;
    List<int> messageBytes = utf8.encode(jsonEncode(rawParams));
    List<int> key = base64.decode(credentials.clientSecret);
    Hmac hmac = Hmac(sha256, key);
    Digest digest = hmac.convert(messageBytes);
    return base64.encode(digest.bytes);
  }
}
