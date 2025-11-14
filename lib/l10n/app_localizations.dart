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
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @continueJourney.
  ///
  /// In en, this message translates to:
  /// **'Continue your journey with Aoun.'**
  String get continueJourney;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @agreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms & Conditions'**
  String get agreeTerms;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @iAgreeTo.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get iAgreeTo;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information:'**
  String get basicInformation;

  /// No description provided for @foundation.
  ///
  /// In en, this message translates to:
  /// **'Foundation Account'**
  String get foundation;

  /// No description provided for @donor.
  ///
  /// In en, this message translates to:
  /// **'Donor Account'**
  String get donor;

  /// No description provided for @enterFoundationName.
  ///
  /// In en, this message translates to:
  /// **'Enter foundation name'**
  String get enterFoundationName;

  /// No description provided for @typeOfFoundation.
  ///
  /// In en, this message translates to:
  /// **'Type of Foundation'**
  String get typeOfFoundation;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get selectType;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @resetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get resetYourPassword;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email'**
  String get enterYourEmail;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email address'**
  String get resetLinkSent;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhone;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @reenterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reenterPassword;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences:'**
  String get preferences;

  /// No description provided for @requiredDonation.
  ///
  /// In en, this message translates to:
  /// **'Required Donation'**
  String get requiredDonation;

  /// No description provided for @selectRequiredDonation.
  ///
  /// In en, this message translates to:
  /// **'Select required donation'**
  String get selectRequiredDonation;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select your location'**
  String get selectLocation;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpTitle;

  /// No description provided for @joinUs.
  ///
  /// In en, this message translates to:
  /// **'Join Us'**
  String get joinUs;

  /// No description provided for @createAccountNow.
  ///
  /// In en, this message translates to:
  /// **'Create your account now'**
  String get createAccountNow;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signInNow.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInNow;

  /// No description provided for @foundationAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Foundation account registered successfully!'**
  String get foundationAccountSuccess;

  /// No description provided for @donorAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Donor account registered successfully!'**
  String get donorAccountSuccess;

  /// No description provided for @requestAssistance.
  ///
  /// In en, this message translates to:
  /// **'Request Assistance'**
  String get requestAssistance;

  /// No description provided for @photoLibrary.
  ///
  /// In en, this message translates to:
  /// **'Photo Library'**
  String get photoLibrary;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @donated.
  ///
  /// In en, this message translates to:
  /// **'Donated'**
  String get donated;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @tapToUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap above to upload your photo'**
  String get tapToUploadPhoto;

  /// No description provided for @recommendedDonations.
  ///
  /// In en, this message translates to:
  /// **'Recommended Donations'**
  String get recommendedDonations;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @yourDonations.
  ///
  /// In en, this message translates to:
  /// **'Your Donations'**
  String get yourDonations;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @homeIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Help us support patients and those in need, bringing hope to their lives.'**
  String get homeIntroTitle;

  /// No description provided for @homeIntroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'With your support, we can secure surgeries and essential treatments to save their lives and grant them a better future.'**
  String get homeIntroSubtitle;

  /// No description provided for @donateNow.
  ///
  /// In en, this message translates to:
  /// **'Donate Now'**
  String get donateNow;

  /// No description provided for @donateTapped.
  ///
  /// In en, this message translates to:
  /// **'Donate button tapped'**
  String get donateTapped;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navDonationCampaigns.
  ///
  /// In en, this message translates to:
  /// **'Donation Campaigns'**
  String get navDonationCampaigns;

  /// No description provided for @navRequestAssistance.
  ///
  /// In en, this message translates to:
  /// **'Request Assistance'**
  String get navRequestAssistance;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @onboardTitle1.
  ///
  /// In en, this message translates to:
  /// **'Support Each Other'**
  String get onboardTitle1;

  /// No description provided for @onboardDesc1.
  ///
  /// In en, this message translates to:
  /// **'Join hands with Aoun to bring hope and care to people in need. Together, we make compassion a habit.'**
  String get onboardDesc1;

  /// No description provided for @onboardTitle2.
  ///
  /// In en, this message translates to:
  /// **'Easy & Trusted Donations'**
  String get onboardTitle2;

  /// No description provided for @onboardDesc2.
  ///
  /// In en, this message translates to:
  /// **'Contribute to verified causes effortlessly. Every donation you make directly reaches those who need it most.'**
  String get onboardDesc2;

  /// No description provided for @onboardTitle3.
  ///
  /// In en, this message translates to:
  /// **'Make a Difference'**
  String get onboardTitle3;

  /// No description provided for @onboardDesc3.
  ///
  /// In en, this message translates to:
  /// **'Your small act of kindness can create a lasting impact and change lives for the better.'**
  String get onboardDesc3;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @reEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new password'**
  String get reEnterPassword;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @campaignMedicalSupplies.
  ///
  /// In en, this message translates to:
  /// **'Providing medical equipment and supplies'**
  String get campaignMedicalSupplies;

  /// No description provided for @donationClothes.
  ///
  /// In en, this message translates to:
  /// **'Clothes'**
  String get donationClothes;

  /// No description provided for @donationFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get donationFood;

  /// No description provided for @donationMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get donationMoney;

  /// No description provided for @donationBooks.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get donationBooks;

  /// No description provided for @donationMedicalSupplies.
  ///
  /// In en, this message translates to:
  /// **'Medical Supplies'**
  String get donationMedicalSupplies;

  /// No description provided for @foundationCharity.
  ///
  /// In en, this message translates to:
  /// **'Charity'**
  String get foundationCharity;

  /// No description provided for @foundationReligious.
  ///
  /// In en, this message translates to:
  /// **'Religious'**
  String get foundationReligious;

  /// No description provided for @foundationHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get foundationHealth;

  /// No description provided for @foundationEducational.
  ///
  /// In en, this message translates to:
  /// **'Educational'**
  String get foundationEducational;

  /// No description provided for @foundationEnvironmental.
  ///
  /// In en, this message translates to:
  /// **'Environmental'**
  String get foundationEnvironmental;

  /// No description provided for @locationCairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get locationCairo;

  /// No description provided for @locationAlexandria.
  ///
  /// In en, this message translates to:
  /// **'Alexandria'**
  String get locationAlexandria;

  /// No description provided for @locationGiza.
  ///
  /// In en, this message translates to:
  /// **'Giza'**
  String get locationGiza;

  /// No description provided for @locationLuxor.
  ///
  /// In en, this message translates to:
  /// **'Luxor'**
  String get locationLuxor;

  /// No description provided for @locationAswan.
  ///
  /// In en, this message translates to:
  /// **'Aswan'**
  String get locationAswan;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password has been reset successfully'**
  String get passwordResetSuccess;

  /// No description provided for @foundationName.
  ///
  /// In en, this message translates to:
  /// **'Foundation Name'**
  String get foundationName;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get uploadFile;

  /// No description provided for @requiredAmount.
  ///
  /// In en, this message translates to:
  /// **'Required Amount with /\$'**
  String get requiredAmount;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @formSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Assistance Request Submitted'**
  String get formSubmitted;

  /// No description provided for @validationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter {field}'**
  String validationMessage(Object field);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
