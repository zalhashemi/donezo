import 'package:donezo/Components/dropdown.dart';
import 'package:donezo/theme.dart';
import 'package:flutter/material.dart';

class ProgressTile extends StatefulWidget {
  const ProgressTile({super.key});

  @override
  State<ProgressTile> createState() => _ProgressTileState();
}

class _ProgressTileState extends State<ProgressTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: 350,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF461E55), Color(0xFF906DB0)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15),
            child: Text(
              'Today\'s Progress',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 40),
            child: Text('4/6 Tasks Completed',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                )),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 60),
            child: Text('You\'re almost done. Keep going!',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Baloo 2',
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                )),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 90),
            child: Container(
              width: 270,
              height: 10,
              decoration: BoxDecoration(
                color: Theme.of(context).ourGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 270 * 0.7,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
