import 'package:fuelred_mobile/sizeconfig.dart';
import 'package:flutter/material.dart';


const kRegularColor =  Color(0xFFec1c24);
const kSuperColor =Color(0xFFb634b8);
const kDieselColor =Color(0xFF1dbd4a);
const kExoColor =Color(0xFF00a8f3);
const kPrimaryColor = Color(0xFFFC0102);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kTextColorBlack = Colors.black87;
const kTextColorWhite= Color.fromARGB(204, 236, 231, 231);
const kColorMenu= Color.fromARGB(251, 251, 245, 245);
const kGradientHome = LinearGradient(colors: [kPrimaryColor, kBlueColorLogo ]);
const kGradientHomeReverse = LinearGradient(colors: [kBlueColorLogo, kPrimaryColor ]);

const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFF7643), Color(0xFFFC0102)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const kBlueColorLogo =Color(0xFF175fb1);
const inActiveIconColor =  Color(0xFFB6B6B6);
const kColorFondoOscuro = Color.fromARGB(255, 70, 72, 77);
const kContrateFondoOscuro = Color.fromARGB(255, 232, 236, 240);
const kPrimaryText = Color(0xFFFF7643);

const kAnimationDuration = Duration(milliseconds: 200);

final myHeadingStyleBlack = TextStyle(
  fontSize: getProportionateScreenWidth(22),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

final myHeadingStylePrymary = TextStyle(
  fontSize: getProportionateScreenWidth(22),
  fontWeight: FontWeight.bold,
  color: kPrimaryColor,
  height: 1.5,
);

final mySubHeadingStyleWhite = TextStyle(
  fontSize: getProportionateScreenWidth(20),
  fontWeight: FontWeight.bold,
  color: Colors.white,
  height: 1.5,
);

final mySubHeadingStyleBlacb = TextStyle(
  fontSize: getProportionateScreenWidth(18),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

final myEnfasisBlack = TextStyle(
  fontSize: getProportionateScreenWidth(16),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

final headingStyleKprimary = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: kPrimaryColor,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      const EdgeInsets.all(30),
  border: outlineInputBorderColor(),
  focusedBorder: outlineInputBorderColor(),
  enabledBorder: outlineInputBorderColor(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kTextColor),
  );
}

OutlineInputBorder outlineInputBorderColor() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kPrimaryColor),
  );
}