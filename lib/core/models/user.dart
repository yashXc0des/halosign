import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Enum to define different user roles in the application.
@JsonEnum(alwaysCreate: true)
enum UserRole {
  admin,
  clientAdmin,
  clientUser,
  viewer,
}

@freezed
class UserModel with _$UserModel {
  /// Factory constructor for creating a new `UserModel` instance.
  const factory UserModel({
    required String id, // Unique identifier for the user.
    required String name, // Full name of the user.
    required String email, // Email address of the user.
    @Default(UserRole.clientUser) UserRole role, // Default role is `clientUser`.
    @Default([]) List<String> permissions, // Default to an empty list of permissions.
  }) = _UserModel;

  /// Private named constructor required for custom getters.
  const UserModel._();

  /// Factory constructor for creating a `UserModel` instance from JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  /// Computed property to retrieve permissions based on the user role.
  /// Combines role-based permissions with any custom permissions.
  List<String> get effectivePermissions {
    final normalizedPermissions = permissions.toSet();
    final basePermissions = roleBasedPermissions(role).toSet();
    return [...basePermissions, ...normalizedPermissions];
  }

  /// Static method to define role-based permissions.
  static List<String> roleBasedPermissions(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return ['create_agreement', 'edit_agreement', 'delete_agreement', 'manage_users'];
      case UserRole.clientAdmin:
        return ['create_agreement', 'edit_own_agreement', 'invite_users'];
      case UserRole.clientUser:
        return ['view_agreements', 'sign_agreement'];
      case UserRole.viewer:
        return ['view_agreements'];
    }
  }
}

extension UserRoleExtension on UserRole {
  /// Provides a human-readable description of the role.
  String get description {
    switch (this) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.clientAdmin:
        return 'Client Administrator';
      case UserRole.clientUser:
        return 'Client User';
      case UserRole.viewer:
        return 'Viewer';
    }
  }
}