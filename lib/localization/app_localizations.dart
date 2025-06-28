import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The title of the chat application.
  ///
  /// In en, this message translates to:
  /// **'Chat App'**
  String get appTitle;

  /// The title displayed on the home page of the application.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// The title displayed on the chat page.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// The title displayed on the map page.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// The title displayed on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// The title displayed on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Button text to send a message in the chat.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Button text to sign out of the application.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Button text to delete user account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Button text to edit user profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Button text to update user profile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// Button text to change password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Title for delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// Warning message for account deletion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone and will permanently delete all your data.'**
  String get deleteAccountWarning;

  /// Prompt asking user to enter password for confirmation.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password to confirm:'**
  String get confirmPasswordPrompt;

  /// Error message when password field is empty.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Error message for incorrect password.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get incorrectPassword;

  /// Error message when recent authentication is required.
  ///
  /// In en, this message translates to:
  /// **'Recent authentication required. Please log in again.'**
  String get recentAuthRequired;

  /// Button text to cancel an action.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Button text to confirm deletion.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Label for name field.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Label for current password field.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// Label for new password field.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Label for confirm password field.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Error message when passwords don't match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Success message when profile is updated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// Success message when password is updated.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdated;

  /// Success message when account is deleted.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeleted;

  /// Text displayed when the application is loading data.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Message displayed when an error occurs in the application.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorOccurred;

  /// Message displayed to the user when they return to the application.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// Description text displayed on the login page.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// Label for the email input field.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label for the password input field.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Button text to log in to the application.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// Text displayed to users who do not have an account, prompting them to sign up.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Button text to sign up for a new account.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Text displayed on the sign-up page to prompt users to create a new account.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// Label for the full name input field on the sign-up page.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Label for the mobile number input field on the sign-up page.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// Text displayed to users who already have an account, prompting them to log in.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Button text to sign in to the application.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Button text to log in to the application.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Error message displayed when the email field is left empty.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Error message displayed when the email format is invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmail;

  /// Error message displayed when the password is shorter than 6 characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Error message displayed when the full name field is left empty.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// Label for the country selection dropdown on the sign-up page.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// Description text displayed on the sign-up page to encourage users to create an account.
  ///
  /// In en, this message translates to:
  /// **'Create an account to start chatting with your friends and family.'**
  String get createAccountDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
