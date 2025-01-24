import 'package:freezed_annotation/freezed_annotation.dart';

part 'signature.freezed.dart';
part 'signature.g.dart';

/// Enum to represent the type of signature.
@JsonEnum(alwaysCreate: true)
enum SignatureType {
  drawn, // Hand-drawn signature.
  uploaded, // Uploaded image of a signature.
  text, // Text-based signature.
}

@freezed
class Signature with _$Signature {
  /// Factory constructor for creating a new `Signature` instance.
  const factory Signature({
    required String id, // Unique identifier for the signature.
    required String userId, // User ID of the signer.
    required String agreementId, // ID of the associated agreement.
    required SignatureType type, // Type of the signature (drawn, uploaded, text).
    required DateTime signedAt, // Timestamp of when the signature was made.
    String? signatureUrl, // URL of the signature image (nullable).
    String? textSignature, // If text-based, stores the text of the signature (nullable).
    required String ipAddress, // IP address of the signer.
    required String deviceInfo, // Device information of the signer.
  }) = _Signature;

  /// Private named constructor required for custom getters.
  const Signature._();

  /// Factory constructor for creating a `Signature` instance from JSON.
  factory Signature.fromJson(Map<String, dynamic> json) => _$SignatureFromJson(json);
}
