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
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height != null
            ? MediaQuery.of(context).size.height * (height! / 915)
            : MediaQuery.of(context).size.height * (48 / 915),
        width: width != null
            ? MediaQuery.of(context).size.width * (width! / 412)
            : MediaQuery.of(context).size.width * (330 / 412),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          maxLines: maxLines,
          focusNode: focusNode,
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
            // floatingLabelStyle: TextStyle(
            //   color: Theme.of(context).ourYellow,
            //   fontSize: 16,
            //   fontWeight: FontWeight.w400,
            // ),
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Theme.of(context).ourWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            //floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
        ),
      ),
    );
  }
}
