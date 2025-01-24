import 'package:freezed_annotation/freezed_annotation.dart';

part 'agreement.freezed.dart';
part 'agreement.g.dart';

/// Enum to define the status of an agreement.
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
  /// Factory constructor for creating a new `Agreement` instance.
  const factory Agreement({
    required String id, // Unique identifier for the agreement.
    required String title, // Title of the agreement.
    String? description, // Description of the agreement (nullable).
    required String createdBy, // User ID of the creator.
    required DateTime createdAt, // Timestamp when the agreement was created.
    DateTime? updatedAt, // Timestamp for the last update (nullable).
    @Default(AgreementStatus.draft) AgreementStatus status, // Status of the agreement.
    @Default([]) List<String> signatories, // List of user IDs required to sign.
    @Default([]) List<String> signedBy, // List of user IDs who have signed.
    String? pdfUrl, // URL of the agreement PDF (nullable).
  }) = _Agreement;

  /// Private named constructor required for custom getters.
  const Agreement._();

  /// Factory constructor for creating an `Agreement` instance from JSON.
  factory Agreement.fromJson(Map<String, dynamic> json) => _$AgreementFromJson(json);

  /// Computed property to check if the agreement is fully signed.
  bool get isFullySigned => signedBy.length == signatories.length && signatories.isNotEmpty;

  /// Computed property to get the pending signatories.
  List<String> get pendingSignatories => signatories.where((id) => !signedBy.contains(id)).toList();
}

extension AgreementStatusExtension on AgreementStatus {
  /// Provides a human-readable description of the status.
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