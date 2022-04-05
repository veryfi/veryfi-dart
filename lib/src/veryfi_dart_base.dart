//Veryfi imports
import 'package:veryfi_dart/src/network/network_request_manager.dart';
import 'package:veryfi_dart/src/model/veryfi_credentials.dart';

class VeryfiDart extends NetworkRequestManager {
  /// Init Veryfi SDK.
  ///
  /// Receives a [clientId], [clientSecret], [username], [apiKey]
  /// and [apiVersion] (by default v8) required to initialize the SDK.
  VeryfiDart(
      String clientId, String clientSecret, String username, String apiKey,
      {String apiVersion = 'v8'})
      : super(VeryfiCredentials(clientId, clientSecret, username, apiKey),
            apiVersion);

  /// Get all documents.
  ///
  /// Returns a [Map] with all the documents from the Veryfi inbox.
  Future<Map<String, dynamic>> getDocuments() {
    return request(HTTPMethod.get, 'documents');
  }

  /// Get document by id.
  ///
  /// Returns a [Map] containing the document information with the [documentId].
  Future<Map<String, dynamic>> getDocumentById(String documentId) {
    return request(HTTPMethod.get, 'documents/$documentId');
  }

  /// Delete document.
  ///
  /// Returns a [Map] containing the response of the DELETE request for the [documentId].
  Future<Map<String, dynamic>> deleteDocument(String documentId) {
    return request(HTTPMethod.delete, 'documents/$documentId');
  }

  /// Update document.
  ///
  /// Returns a [Map] containing the updated document information from the
  /// [params] to update to the document with [documentId].
  Future<Map<String, dynamic>> updateDocument(
      String documentId, Map<String, dynamic> params) {
    return request(HTTPMethod.put, 'documents/$documentId', body: params);
  }

  /// Process document from url.
  ///
  /// Returns a [Map] containing the processed document information
  /// from the [fileUrl] or [fileUrls] using the desired or default options.
  Future<Map<String, dynamic>> processDocumentFromURL(
      {String? fileUrl,
      List<String>? fileUrls,
      List<String>? categories,
      bool deleteAfterProcessing = false,
      int boostMode = 0,
      String? externalId,
      int maxPagesToProcess = 1}) {
    final Map<String, dynamic> body = {
      "auto_delete": deleteAfterProcessing,
      "boost_mode": boostMode,
      "categories": categories ?? [],
      "external_id": externalId,
      "file_url": fileUrl,
      "file_urls": fileUrls,
      "max_pages_to_process": maxPagesToProcess
    };
    return request(HTTPMethod.post, 'documents', body: body);
  }

  /// Process document from url.
  ///
  /// Returns a [Map] containing the processed document information
  /// from the [fileData] using the desired or default options.
  Future<Map<String, dynamic>> processDocument(String fileName, String fileData,
      {List<String>? categories,
      bool deleteAfterProcessing = false,
      Map<String, dynamic>? params}) {
    final Map<String, dynamic> body = params ?? {};
    body['categories'] = categories ?? [];
    body['auto_delete'] = deleteAfterProcessing;
    body['file_data'] = fileData;
    body['file_name'] = fileName;

    return request(HTTPMethod.post, 'documents', body: body);
  }

  /// Get document line items
  ///
  /// Returns a [Map] containing the line items from the document
  /// with the specified [documentId].
  Future<Map<String, dynamic>> getDocumentLineItems(String documentId) {
    return request(HTTPMethod.get, 'documents/$documentId/line-items');
  }

  /// Get line item
  ///
  /// Returns a [Map] containing the line item from the document
  /// with the specified [documentId] and [lineItemId].
  Future<Map<String, dynamic>> getLineItem(
      String documentId, String lineItemId) {
    return request(
        HTTPMethod.get, 'documents/$documentId/line-items/$lineItemId');
  }

  /// Add line item
  ///
  /// Returns a [Map] containing the new created line item from
  /// the [params] and added to the document with [documentId].
  Future<Map<String, dynamic>> addLineItem(
      String documentId, Map<String, dynamic> params) {
    return request(HTTPMethod.post, 'documents/$documentId/line-items/',
        body: params);
  }

  /// Update line item
  ///
  /// Returns a [Map] containing the updated line item from
  /// the [params] and associated with [lineItemId] and [documentId].
  Future<Map<String, dynamic>> updateLineItem(
      String documentId, String lineItemId, Map<String, dynamic> params) {
    return request(
        HTTPMethod.put, 'documents/$documentId/line-items/$lineItemId',
        body: params);
  }

  /// Delete document lineitems.
  ///
  /// Returns a [Map] containing the response of the DELETE request for the [documentId].
  Future<Map<String, dynamic>> deleteDocumentLineItems(String documentId) {
    return request(HTTPMethod.delete, 'documents/$documentId/line-items');
  }

  /// Delete lineitem.
  ///
  /// Returns a [Map] containing the response of the DELETE request
  /// for the [documentId] and [lineItemId].
  Future<Map<String, dynamic>> deleteLineitem(
      String documentId, String lineitemId) {
    return request(
        HTTPMethod.delete, 'documents/$documentId/line-items/$lineitemId');
  }
}
