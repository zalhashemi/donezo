import 'package:flutter/material.dart';
import 'package:donezo/theme.dart';

class TextBox extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final Color? color;
  final double? height;
  final double? width;
  final int? minLines;
  final int? maxLines;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final Color? fillColor;
  final Color? labelColor;
  final Color? borderColor;
  final Widget? suffixIcon; // Added suffixIcon support

  const TextBox({
    super.key,
    required this.labelText,
    this.obscureText = false,
    required this.controller,
    this.color,
    this.height,
    this.width,
    this.minLines,
    this.maxLines,
    this.textInputAction = TextInputAction.done,
    this.focusNode,
    this.nextFocusNode,
    this.fillColor,
    this.labelColor,
    this.borderColor,
    this.suffixIcon, // Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    final BorderSide borderSide = borderColor != null
        ? BorderSide(color: borderColor!, width: 1.0)
        : BorderSide.none;

    return Center(
      child: Container(
        height: height ?? 48,
        width: width ?? 330,
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          focusNode: focusNode,
          maxLines: obscureText ? 1 : maxLines,
          minLines: obscureText ? 1 : minLines,
          textInputAction: textInputAction,
          onFieldSubmitted: (value) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            isDense: true,
            label: Text(
              labelText,
              style: const TextStyle(
                fontFamily: 'Baloo2',
                fontWeight: FontWeight.w400,
              ),
            ),
            labelStyle: TextStyle(
              color: labelColor ?? Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: fillColor ?? Theme.of(context).ourWhite,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: borderSide,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: borderSide,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: borderSide,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            suffixIcon: suffixIcon, // Added suffix icon support
          ),
        ),
      ),
    );
  }
}
