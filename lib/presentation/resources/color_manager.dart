import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorManager {
  static final ColorManager _instance = ColorManager._internal();

  factory ColorManager() => _instance;

  ColorManager._internal();

  Color _primary = HexColor.fromHex("#FCD901"); // Default color

  // Getter for primary color
  Color get primary => _primary;

  // Setter for primary color
  // void setPrimaryColor(Color color) {
  //   _primary = color;
  // }

  Future<void> setPrimaryColor(Color color) async {
    _primary = color;
    await _saveColorToPrefs(color); // Save to SharedPreferences
  }

  // Save color to SharedPreferences
  Future<void> _saveColorToPrefs(Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('_primaryColorKey',
        color.value.toRadixString(16)); // Store color as a hex string
  }

  // Load color from SharedPreferences
  Future<void> loadPrimaryColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? colorString = await prefs.getString('_primaryColorKey');

    if (colorString != null) {
      _primary = Color(int.parse(colorString,
          radix: 16)); // Convert hex string back to Color
    }
  }

  static Color canvasColor = HexColor.fromHex("#262626");
  static Color darkGrey = HexColor.fromHex("#393D3f");
  static Color themeText = HexColor.fromHex("#ADB5BD");
  static Color darkGrey2 = HexColor.fromHex("#000000");

  static void applyDarkTheme() {
    canvasColor = HexColor.fromHex("#262626"); // Dark canvas color
    darkGrey = HexColor.fromHex("#333333"); // Dark grey
    themeText =
        HexColor.fromHex("#ADB5BD"); // Slightly lighter grey for contrast
    darkGrey2 = HexColor.fromHex("#000000");
  }

  // Method to apply the light theme
  static void applyLightTheme() {
    canvasColor = HexColor.fromHex("#FFFFFF"); // Light canvas color
    darkGrey = HexColor.fromHex("#f6f6f9"); // Medium grey
    themeText = HexColor.fromHex("#000000"); // Light grey
    darkGrey2 = HexColor.fromHex("#E0E0E0");
  }

  static Color primaryOpacity70 = HexColor.fromHex("#F9A825");
  static Color promo1BgColor = HexColor.fromHex("#4D4472").withOpacity(1);

  static Color selectedPackageBorderColor =
      HexColor.fromHex("#E8E2FF").withOpacity(1);

  static Color loginPrivacyColor1 = HexColor.fromHex("#6E777C");
  static Color loginPrivacyColor2 = HexColor.fromHex("#3D4951");
  static Color bottomNavBackground = HexColor.fromHex("#333333");

  //text color

  static Color userCardColor = HexColor.fromHex("#FCD901");

  static Color textColor = HexColor.fromHex("#3D4951");
  static Color formTextColor = HexColor.fromHex("#ADB5BD");

  static Color myProfileTextColor = HexColor.fromHex("#A5D4ED");
  static Color myProfileContainerColor = HexColor.fromHex("E8F4F1");
  static Color logOutButtonBackgroundColor = HexColor.fromHex("#FFF6F6");
  static Color logoutButtonTextColor = HexColor.fromHex("#F85353");

  static Color otpTextColor = HexColor.fromHex("#9EA4A8");
  static Color homeTextColor1 = HexColor.fromHex("#6E777C");
  static Color homeTextColor2 = HexColor.fromHex("#0D1C25");
  static Color homeTextColor3 = HexColor.fromHex("#1BB71B");
  static Color dialogBoxTextColor = HexColor.fromHex("#3D4951");
  static Color customCardWidgetTextColor = HexColor.fromHex("#0D1C25");
  static Color myProfileblueCardTextColor = HexColor.fromHex("#A5D4ED");
  static Color editLanguageTextColor = HexColor.fromHex("#3D4951");
  static Color editLanguageBorderColor = HexColor.fromHex("#E7E8E9");
  static Color senderMessageTanColorinChat = HexColor.fromHex("#1E93D1");
  static Color receiverMessageTabColorinChat = HexColor.fromHex("#78BEE3");
  static Color dateTabColorTextinChat = HexColor.fromHex("#9EA4A8");

  static Color containerColor = HexColor.fromHex("#E8F4FA");
  static Color containerBorder = HexColor.fromHex("#D2E9F6");
  static Color backgroundColor = HexColor.fromHex("#262626");
  static Color innerbackgroundColor = HexColor.fromHex("#383838");

  //New Colors
  static Color cancelButtonTextColor = HexColor.fromHex("#CFD2D3");
  static Color black = HexColor.fromHex('#000000');
  static Color darkPrimary = HexColor.fromHex("#d17d11");
  static Color grey1 = HexColor.fromHex("#707070");
  static Color grey2 = HexColor.fromHex("#797979");
  static Color white = HexColor.fromHex("#FFFFFF");
  static Color tabColor = HexColor.fromHex("#1E93D1");
  static Color tabBarColor = HexColor.fromHex("#D2E9F6");
  static Color elevatedButtonColor = HexColor.fromHex("#1E93D1");
  static Color logOutButtonColor = HexColor.fromHex("#F85353");
  static Color textFieldColor = HexColor.fromHex("#E8F4FA");
  static Color textFieldBorderColor = HexColor.fromHex("#1E93D1");
  static Color tabBarBorder = HexColor.fromHex('#D2E9F6');
  static Color quizOptionsBackgroundColor = HexColor.fromHex('#E8F4FA');

  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xff0ed0cf), Color(0xff01d0b3)],
    stops: [0.25, 0.75],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString =
          "FF$hexColorString"; //Appending characters for opacity of 100% at start of HexCode
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}

































// import 'package:flutter/material.dart';

// class ColorManager extends ChangeNotifier {
//    Color _primary = HexColor.fromHex("#FCD901");
//   Color _canvasColor = HexColor.fromHex("#262626");
  
//   // Getter for primary color
//   Color get primary => _primary;

//   // Setter for primary color
//   set primary(Color newColor) {
//     _primary = newColor;
//     notifyListeners(); // Notify listeners about the change
//   }




//   // static Color primary = HexColor.fromHex("#FCD901");
//   static Color canvasColor = HexColor.fromHex("#262626");
//   static Color darkGrey = HexColor.fromHex("#393D3f");
//   static Color grey = HexColor.fromHex("#ADB5BD");
//   static Color primaryOpacity70 = HexColor.fromHex("#F9A825");
//   static Color promo1BgColor = HexColor.fromHex("#4D4472").withOpacity(1);

//   static Color selectedPackageBorderColor =
//       HexColor.fromHex("#E8E2FF").withOpacity(1);

//   static Color loginPrivacyColor1 = HexColor.fromHex("#6E777C");
//   static Color loginPrivacyColor2 = HexColor.fromHex("#3D4951");
//   static Color bottomNavBackground = HexColor.fromHex("#333333");

//   //text color
//   static Color textColor = HexColor.fromHex("#3D4951");
//   static Color myProfileTextColor = HexColor.fromHex("#A5D4ED");
//   static Color myProfileContainerColor = HexColor.fromHex("E8F4F1");
//   static Color logOutButtonBackgroundColor = HexColor.fromHex("#FFF6F6");
//   static Color logoutButtonTextColor = HexColor.fromHex("#F85353");

//   static Color otpTextColor = HexColor.fromHex("#9EA4A8");
//   static Color homeTextColor1 = HexColor.fromHex("#6E777C");
//   static Color homeTextColor2 = HexColor.fromHex("#0D1C25");
//   static Color homeTextColor3 = HexColor.fromHex("#1BB71B");
//   static Color dialogBoxTextColor = HexColor.fromHex("#3D4951");
//   static Color customCardWidgetTextColor = HexColor.fromHex("#0D1C25");
//   static Color myProfileblueCardTextColor = HexColor.fromHex("#A5D4ED");
//   static Color editLanguageTextColor = HexColor.fromHex("#3D4951");
//   static Color editLanguageBorderColor = HexColor.fromHex("#E7E8E9");
//   static Color senderMessageTanColorinChat = HexColor.fromHex("#1E93D1");
//   static Color receiverMessageTabColorinChat = HexColor.fromHex("#78BEE3");
//   static Color dateTabColorTextinChat = HexColor.fromHex("#9EA4A8");

//   static Color containerColor = HexColor.fromHex("#E8F4FA");
//   static Color containerBorder = HexColor.fromHex("#D2E9F6");

  

//   //New Colors
//   static Color cancelButtonTextColor = HexColor.fromHex("#CFD2D3");
//   static Color black = HexColor.fromHex('#000000');
//   static Color darkPrimary = HexColor.fromHex("#d17d11");
//   static Color grey1 = HexColor.fromHex("#707070");
//   static Color grey2 = HexColor.fromHex("#797979");
//   static Color white = HexColor.fromHex("#FFFFFF");
//   static Color tabColor = HexColor.fromHex("#1E93D1");
//   static Color tabBarColor = HexColor.fromHex("#D2E9F6");
//   static Color elevatedButtonColor = HexColor.fromHex("#1E93D1");
//   static Color logOutButtonColor = HexColor.fromHex("#F85353");
//   static Color textFieldColor = HexColor.fromHex("#E8F4FA");
//   static Color textFieldBorderColor = HexColor.fromHex("#1E93D1");
//   static Color tabBarBorder = HexColor.fromHex('#D2E9F6');
//   static Color quizOptionsBackgroundColor = HexColor.fromHex('#E8F4FA');

//   static const Gradient primaryGradient = LinearGradient(
//     colors: [Color(0xff0ed0cf), Color(0xff01d0b3)],
//     stops: [0.25, 0.75],
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//   );
// }

// extension HexColor on Color {
//   static Color fromHex(String hexColorString) {
//     hexColorString = hexColorString.replaceAll('#', '');
//     if (hexColorString.length == 6) {
//       hexColorString = "FF$hexColorString"; //Appending characters for opacity of 100% at start of HexCode
//     }
//     return Color(int.parse(hexColorString, radix: 16));
//   }
// }

























