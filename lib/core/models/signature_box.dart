import 'package:freezed_annotation/freezed_annotation.dart';

part 'signature_box.freezed.dart';
part 'signature_box.g.dart';

@freezed
class SignatureBox with _$SignatureBox {
  const factory SignatureBox({
    required String id,
    required String agreementId,
    required String assignedToUserId,
    required double pageNumber,
    required double x,       // X coordinate on the page (normalized 0-1)
    required double y,       // Y coordinate on the page (normalized 0-1)
    required double width,   // Width of box (normalized 0-1)
    required double height,  // Height of box (normalized 0-1)
    String? signatureId,     // Will be populated when signed
  }) = _SignatureBox;

  const SignatureBox._();

  factory SignatureBox.fromJson(Map<String, dynamic> json) => _$SignatureBoxFromJson(json);
}
