import 'package:donezo/theme.dart';
import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final String hintText;
  final List<String> categories;
  final String? value;
  final Function(String?)? onChanged;

  const Dropdown({
    super.key,
    required this.hintText,
    required this.categories,
    this.value,
    this.onChanged,
  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 330,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        hint: Text(
          widget.hintText,
          style: TextStyle(
            fontFamily: 'Baloo 2',
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
        ),
        value: widget.value,
        icon: Icon(
          Icons.arrow_downward_rounded,
          size: 24,
          color: Theme.of(context).lightPurple,
        ),
        dropdownColor: Theme.of(context).colorScheme.surface,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontFamily: 'Baloo 2',
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        borderRadius: BorderRadius.circular(30),
        menuMaxHeight: 200,
        elevation: 2,
        onChanged: widget.onChanged,
        items: widget.categories.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'Baloo 2',
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

