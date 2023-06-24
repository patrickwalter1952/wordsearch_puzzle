
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';


class Utils {
  static showSnackBarMessage(BuildContext context, String message, bool isError) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.blue,
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  ///
  /// Password must contain one digit from 1 to 9,
  /// one lowercase letter, one uppercase letter,
  /// one special character (~`@#\$%^&*()-_+=), no space,
  /// and it must be at least 8 characters long.
  ///
  static bool isPasswordValid(String? password) {
    const String pwdRegEx = "(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[~@#%^&_+])";
    // final int minPwLength = 6;
    if (password == null || password.isEmpty || password.contains(' ')) {
      return false;
    }
    RegExp regex = RegExp(pwdRegEx);
    return regex.hasMatch(password);
    // return password.length < minPwLength;
  }

  ///
  /// Build and Show Dialog
  ///
  static Future<dynamic> buildShowDialog(
      BuildContext context,
      String title,
      String showText,
      bool isError) {

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        backgroundColor: isError ? Colors.red.shade200 : Colors.blueGrey,
        content: Text(
          showText,
        ),

        actions: [
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            onPressed: () => Navigator.pop(context, 'OK'),
          ),
        ],
      ),
    );
  }

  ///
  /// Build and Show Phone Text Field Dialog
  ///
  static Future<dynamic> buildShowPhoneTextFieldDialog(
      BuildContext context,
      String title,
      String errorTitle,
      Function validator,
      TextEditingController textFieldController) async {

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(

        title: Text(title),

        content: TextField(
          controller: textFieldController,
        ),

        actions: <Widget> [
          TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              onPressed: () {
                //textFieldController has the value
                if (validator()) {
                  Navigator.pop(context, 'OK');
                  return;
                }
                buildShowDialog(
                    context,
                    errorTitle,
                    "The value ${textFieldController.text} is invalid",
                    true);

              }
          ),
          TextButton(
            child: const Text(
              'CANCEL',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            onPressed: () {
              Navigator.pop(context, 'CANCEL');
            },
          ),
        ],
      ),
    );
  }


  ///
  /// Build and Show Confirmation Dialog
  ///
  static Future<dynamic> buildShowConfirmationDialog(
      BuildContext context,String title, String message) async {

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(

        title: Text(title),

        content: Text(message),

        actions: <Widget> [
          TextButton(
              child: const Text(
                'YES',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              onPressed: () {
                Navigator.pop(context, 'YES');
              }
          ),
          TextButton(
            child: const Text(
              'NO',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            onPressed: () {
              Navigator.pop(context, 'NO');
            },
          ),
        ],
      ),
    );
  }

}