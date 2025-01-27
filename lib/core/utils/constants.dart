
/// Contains global constants used throughout the application.
class AppConstants {
  static const String appName = "Haloyte eSign";

  // Firebase Collection Names
  static const String usersCollection = "users";
  static const String agreementsCollection = "agreements";
  static const String signaturesCollection = "signatures";

  // Roles
  static const List<String> userRoles = [
    'admin',
    'clientAdmin',
    'clientUser',
    'viewer',
  ];

  // Date-Time Formats
  static const String dateTimeFormat = "yyyy-MM-dd HH:mm:ss";
}
