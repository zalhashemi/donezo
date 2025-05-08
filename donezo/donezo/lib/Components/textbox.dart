import 'package:flutter/material.dart';
import 'package:donezo/theme.dart';

// This is a custom text box widget that can be used in the app
// It takes a label text, a controller, and optional parameters for color, height, width, minLines, maxLines, textInputAction, focusNode, nextFocusNode, fillColor, labelColor, borderColor, and suffixIcon
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
  final Widget? suffixIcon;

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
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final BorderSide borderSide = borderColor != null
        ? BorderSide(color: borderColor!, width: 1.0)
        : BorderSide.none;

    return Center(
      child: Container(
        // This is the main container for the text box
        // It has a specific height, width, and decoration

        height: height ?? 48,
        width: width ?? 330,
        child: TextFormField(
          // This is the text form field widget
          // It is used to create a text input field with a label and other properties
          controller: controller,
          obscureText: obscureText,
          focusNode: focusNode,
          maxLines: obscureText ? 1 : maxLines,
          minLines: obscureText ? 1 : minLines,
          textInputAction: textInputAction,
          onFieldSubmitted: (value) {
            // This is called when the user submits the text field
            // It checks if the next focus node is not null and requests focus on it
            // If it is null, it unfocuses the current focus node
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }
}
