import 'package:flutter/material.dart';

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
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        height: height ?? 35,
        width: width ?? 100, // Default width
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontFamily: 'GreyCliffCF-ExtraBold',
              fontWeight: FontWeight.w400,
              fontSize: fontSize ?? 14,
            ),
          ),
        ),
      ),
    );
  }
}
