
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:halosign/core/services/cloudflare_r2_service.dart';
import 'package:uuid/uuid.dart';
import '../models/signature.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignatureService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PDFUploadNotifier _storageService = PDFUploadNotifier();

  // Get IP address for signature tracking
  Future<String> _getIpAddress() async {
    try {
      final response = await http.get(Uri.parse('https://api.ipify.org'));
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint('Error getting IP address: $e');
    }
    return 'unknown';
  }

  // Get device info for signature tracking
  Future<String> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceData = 'Unknown device';

    try {
      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        deviceData = '${webInfo.browserName.name} on ${webInfo.platform}';
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceData = '${androidInfo.model} (Android ${androidInfo.version.release})';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceData = '${iosInfo.model} (iOS ${iosInfo.systemVersion})';
      }
    } catch (e) {
      debugPrint('Error getting device info: $e');
    }

    return deviceData;
  }

  // Create a new signature
  Future<Signature> createSignature({
    required String userId,
    required String agreementId,
    required SignatureType type,
    Uint8List? signatureImage,
    String? textSignature,
  }) async {
    // Upload signature image if provided
    String? signatureUrl;
    if (signatureImage != null) {
      signatureUrl = await _storageService.uploadSignatureImage(signatureImage);
      if (signatureUrl == null) {
        throw Exception('Failed to upload signature image');
      }
    }

    final signature = Signature(
      id: const Uuid().v4(),
      userId: userId,
      agreementId: agreementId,
      type: type,
      signedAt: DateTime.now(),
      signatureUrl: signatureUrl,
      textSignature: textSignature,
      ipAddress: await _getIpAddress(),
      deviceInfo: await _getDeviceInfo(),
    );

    // Save to Firestore
    await _firestore.collection('signatures').doc(signature.id).set(signature.toJson());

    return signature;
  }

  // Get all signatures for an agreement
  Future<List<Signature>> getSignaturesByAgreement(String agreementId) async {
    final snapshot = await _firestore
        .collection('signatures')
        .where('agreementId', isEqualTo: agreementId)
        .get();

    return snapshot.docs.map((doc) => Signature.fromJson(doc.data())).toList();
  }

  // Get signature by ID
  Future<Signature?> getSignatureById(String signatureId) async {
    final doc = await _firestore.collection('signatures').doc(signatureId).get();
    return doc.exists ? Signature.fromJson(doc.data()!) : null;
  }
}
