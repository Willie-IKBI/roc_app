/// Centralized string management for the application.
/// This class provides a single source of truth for all user-facing strings,
/// making it easier to implement i18n in the future.
class AppStrings {
  AppStrings._();

  // Authentication
  static const String loginTitle = 'Sign in';
  static const String loginEmailLabel = 'Email';
  static const String loginPasswordLabel = 'Password';
  static const String loginButton = 'Sign in';
  static const String signUpTitle = 'Sign up';
  static const String signUpButton = 'Create account';
  static const String forgotPasswordTitle = 'Forgot password';
  static const String resetPasswordTitle = 'Reset password';
  static const String signOut = 'Sign out';
  static const String profile = 'Profile';

  // Navigation
  static const String dashboard = 'Dashboard';
  static const String claims = 'Claims';
  static const String reports = 'Reports';
  static const String admin = 'Admin';

  // Claims
  static const String captureClaim = 'Capture claim';
  static const String claimCreated = 'Claim created successfully';
  static const String claimCreateFailed = 'Failed to create claim';
  static const String claimNumber = 'Claim number';
  static const String claimStatus = 'Status';
  static const String claimPriority = 'Priority';
  static const String claimItems = 'Claim items';
  static const String addItem = 'Add item';
  static const String viewQueue = 'View queue';

  // Errors
  static const String networkError = 'Network request failed';
  static const String authError = 'Authentication failed';
  static const String permissionDenied = 'You do not have permission to perform this action';
  static const String notFound = 'Requested resource not found';
  static const String validationError = 'Please check your input and try again';
  static const String unexpectedError = 'An unexpected error occurred. Please try again.';
  static const String unexpectedErrorDebug = 'Unexpected error occurred';

  // Common
  static const String loading = 'Loading...';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String close = 'Close';
  static const String search = 'Search';
  static const String reset = 'Reset';
  static const String retry = 'Retry';
  static const String noResults = 'No results found';
  static const String emptyState = 'No data available';

  // Session
  static const String sessionExpired = 'Your session has expired. Please sign in again.';
  static const String signOutFailed = 'Failed to sign out';

  // Theme
  static const String themeToggle = 'Theme';
  static const String themeLight = 'Light';
  static const String themeDark = 'Dark';
  static const String appearanceSettings = 'Appearance';
  static const String appearanceDescription = 'Choose your preferred theme';

  // Contact attempts
  static const String contactAttemptLogged = 'Contact attempt logged';
  static const String contactAttemptFailed = 'Failed to log attempt';

  // Status changes
  static const String statusChanged = 'Status updated successfully';
  static const String statusChangeFailed = 'Failed to update status';
}

