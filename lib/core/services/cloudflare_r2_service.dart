import 'dart:io';
import 'package:dio/dio.dart';

class CloudflareR2Service {
  final Dio _dio = Dio();

  // Replace with your actual bucket URL and credentials
  final String bucketUrl = "https://YOUR_BUCKET_ID.r2.cloudflarestorage.com";
  final String accessKey = "YOUR_ACCESS_KEY"; // Replace with your actual access key
  final String secretKey = "YOUR_SECRET_KEY"; // Replace with your actual secret key

  Future<String?> uploadPDF(File file, String fileName) async {
    try {
      String fileUrl = "$bucketUrl/$fileName";

      // Open the file for reading
      var fileStream = file.openRead();
      var contentLength = await file.length();

      Response response = await _dio.put(
        fileUrl,
        data: fileStream,
        options: Options(
          headers: {
            "Authorization": "AWS $accessKey:$secretKey",
            "Content-Type": "application/pdf",
            "Content-Length": contentLength.toString(), // Set the content length
          },
        ),
      );

      if (response.statusCode == 200) {
        return fileUrl; // Return the file URL if upload is successful
      } else {
        print("Upload failed: ${response.statusCode} - ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }
}
