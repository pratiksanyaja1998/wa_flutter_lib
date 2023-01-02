
[![pub package](https://img.shields.io/pub/v/wa_flutter_lib.svg)](https://pub.dev/packages/wa_flutter_lib)
[![package publisher](https://img.shields.io/pub/publisher/wa_flutter_lib.svg)](https://pub.dev/packages/wa_flutter_lib/publisher)

Library for common whitelabel app Screens, models, functions, widgets and API services.

This package contains a set of screens like splash screen, login screen, register user screen, otp verification screen,
change password screen, forget password screen, reset password screen. common APIs related to whitelabel app like login user api,
register user API and so on. Also includes some common functions like to show alert dialogs, show confirmation message, show errors in API.

## Whitelabel App modules
- screens
  - Login screen
  - Registration screen
  - Otp verification screen
  - splash screen

- Models 
  - Business model 
  - User model

- Functions

- Widgets
  - Text Button
  - Text Form field
  - Otp field

- Shared Preference

# Login

```dart
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

enum LoginType{
  phone,
  email,
}

```

# Signup

- sign up fields
  - first name of user
  - last name of user
  - email
  - phone number
  - password

# User services

- Whitelabel app User related API services
- Whitelabel app Business related API services 