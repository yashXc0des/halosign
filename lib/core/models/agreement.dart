import 'package:freezed_annotation/freezed_annotation.dart';

part 'agreement.freezed.dart';
part 'agreement.g.dart';

@JsonEnum(alwaysCreate: true)
enum AgreementStatus {
  draft,
  pending,
  signed,
  rejected,
  completed,
}

@freezed
class Agreement with _$Agreement {
  const factory Agreement({
    required String id,
    required String title,
    String? description,
    required String createdBy,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default(AgreementStatus.draft) AgreementStatus status,
    @Default([]) List<String> signatories,
    @Default([]) List<String> signedBy,
    String? pdfUrl,
    String? sendTo,
  }) = _Agreement;

  factory Agreement.fromJson(Map<String, dynamic> json) =>
      _$AgreementFromJson(json);
}

extension AgreementStatusExtension on AgreementStatus {
  String get description {
    switch (this) {
      case AgreementStatus.draft:
        return 'Draft';
      case AgreementStatus.pending:
        return 'Pending';
      case AgreementStatus.signed:
        return 'Signed';
      case AgreementStatus.rejected:
        return 'Rejected';
      case AgreementStatus.completed:
        return 'Completed';
    }
  }
}
