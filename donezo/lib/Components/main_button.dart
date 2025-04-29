import 'package:flutter/material.dart';

// This is a custom button widget that can be used in the app
// It takes a text, an onPressed function, and optional parameters for color, text color, width, height, and font size
// It is used to create a button with a specific style and functionality
class MainButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;

  const MainButton({
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // This is a gesture detector that detects taps on the button
      // When the button is tapped, it calls the onPressed function
      onTap: onPressed,
      child: Container(
        // This is the main container for the button
        // It has a specific height, width, and decoration
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        // The height of the button is set to 35 by default, but can be overridden by the user
        // The width of the button is set to 100 by default, but can be overridden by the user
        height: height ?? 35,
        width: width ?? 100, 
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontFamily: 'Baloo',
              fontWeight: FontWeight.w400,
              fontSize: fontSize ?? 16,
            ),
          ),
        ),
      ),
    );
  }
}
