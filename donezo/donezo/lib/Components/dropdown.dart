import 'package:donezo/theme.dart';
import 'package:flutter/material.dart';
//this is a custom dropdown widget that can be used in the app
//it takes a hint text, a list of categories, a value and an onChanged function as parameters

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
    //this is the main build method of the dropdown widget
    //it returns a container with a dropdown button inside it

    return Container(
      height: 50,
      width: 330,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonFormField<String>(
        //this is the dropdown button form field
        //this is used to create a dropdown button with a form field inside it
      
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding:
             EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
        //this is the onChanged function that is called when the value of the dropdown button changes
        //it takes a function as a parameter that takes a string as a parameter and returns void
        items: widget.categories.map<DropdownMenuItem<String>>((String value) {
          //this is the items property of the dropdown button form field
          //it takes a list of dropdown menu items as a parameter

          return DropdownMenuItem<String>(
            //this is the dropdown menu item
            //it takes a string as a parameter and returns a dropdown menu item
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

