import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import '../../config.dart'; // For extracting file names
//flutter run --dart-define=API_KEY=your_api_key
class PDFUploadNotifier {
  final String bucketName = 'esign'; // Your Cloudflare R2 bucket name
  String get r2BucketUrl => 'https://$bucketName.$accountId.r2.cloudflarestorage.com';
  final String region = ''; // Cloudflare uses an empty region for signature calculations
  final String service = 's3';

  Future<String?> uploadPDF(File file) async {
    try {
      //manual encoding
      String encodeFileName(String fileName) {
        return fileName
            .replaceAll(' ', '%20') // Encode spaces
            .replaceAll('(', '%28') // Encode (
            .replaceAll(')', '%29') // Encode )
            .replaceAll(',', '%2C') // Encode ,
            .replaceAll(';', '%3B'); // Encode ;
      }

      final fileName = encodeFileName(basename(file.path));

      //final fileName = Uri.encodeFull(basename(file.path)); // Encode spaces in file names
      final filePath = 'agreements/$fileName'; // Store in "agreements" folder
      final uploadUrl = '$r2BucketUrl/$filePath';
      final fileBytes = await file.readAsBytes();
      final contentSha256 = sha256.convert(fileBytes).toString();

      final now = DateTime.now().toUtc();
      final dateStamp = DateFormat('yyyyMMdd').format(now);
      final amzDate = DateFormat('yyyyMMdd\'T\'HHmmss\'Z\'').format(now);
      final scope = '$dateStamp/$region/$service/aws4_request';

      final canonicalRequest = [
        'PUT',
        '/$filePath',
        '',
        'host:${Uri.parse(r2BucketUrl).host}',
        'x-amz-content-sha256:$contentSha256',
        'x-amz-date:$amzDate',
        '',
        'host;x-amz-content-sha256;x-amz-date',
        contentSha256,
      ].join('\n');

      final stringToSign = [
        'AWS4-HMAC-SHA256',
        amzDate,
        scope,
        sha256.convert(utf8.encode(canonicalRequest)).toString(),
      ].join('\n');

      final signingKey = _getSignatureKey(secretKey, dateStamp, region, service);
      final signature = Hmac(sha256, signingKey).convert(utf8.encode(stringToSign)).toString();

      final authorizationHeader = [
        'AWS4-HMAC-SHA256 Credential=$accessKey/$scope',
        'SignedHeaders=host;x-amz-content-sha256;x-amz-date',
        'Signature=$signature',
      ].join(', ');

      // Upload request
      final response = await http.put(
        Uri.parse(uploadUrl),
        body: fileBytes,
        headers: {
          'Authorization': authorizationHeader,
          'x-amz-date': amzDate,
          'x-amz-content-sha256': contentSha256,
          'Content-Type': 'application/pdf',
        },
      );

      if (response.statusCode == 200) {
        return '$urlPrefix/$filePath'; // Return the full URL of the uploaded file
      } else {
        throw Exception('Failed to upload PDF: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error uploading PDF: $e');
    }
  }

  Future<String?> uploadSignatureImage(Uint8List imageBytes) async {
    try {
      final String fileName = 'signatures/${DateTime.now().millisecondsSinceEpoch}_${const Uuid().v4()}.png';

      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('YOUR_SIGNATURE_UPLOAD_ENDPOINT'),
      );

      // Add file to request
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes.toList(), // <- this is key
          filename: fileName,
        ),
      );


      // Add necessary headers
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        // Add authentication headers if needed
      });

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);

        // Return the URL of the uploaded file
        return jsonResponse['url'] as String;
      }
      return null;
    } catch (e) {
      debugPrint('Error uploading signature image: $e');
      return null;
    }
  }


  List<int> _getSignatureKey(String key, String dateStamp, String region, String service) {
    final kDate = Hmac(sha256, utf8.encode('AWS4$key')).convert(utf8.encode(dateStamp)).bytes;
    final kRegion = Hmac(sha256, kDate).convert(utf8.encode(region)).bytes;
    final kService = Hmac(sha256, kRegion).convert(utf8.encode(service)).bytes;
    final kSigning = Hmac(sha256, kService).convert(utf8.encode('aws4_request')).bytes;
    return kSigning;
  }
}
