import 'package:flutter/material.dart';
import 'package:donezo/theme.dart';

// This is a custom team task tile widget that displays a task assigned to a team

class TeamTaskTile extends StatefulWidget {
  final String teamName;
  final String taskName;
  final String taskStartDate;
  final String taskEndDate;
  final String taskPriority;
  final Color priorityColor;

  const TeamTaskTile({
    super.key,
    required this.teamName,
    required this.taskName,
    required this.priorityColor,
    required this.taskStartDate,
    required this.taskEndDate,
    required this.taskPriority,
  });

  @override
  State<TeamTaskTile> createState() => _TeamTaskTileState();
}
//This has been hard coded for now, but will be changed to a dynamic list of tasks later
class _TeamTaskTileState extends State<TeamTaskTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 350,
      decoration: BoxDecoration(
        color: Theme.of(context).lighterGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 13,
            left: 20,
            child: Text(
              widget.teamName, 
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 20,
            child: Row(
              children: [
                Text(
                  widget.taskName, 
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(width: 100),
                Icon(
                  Icons.file_download_done_rounded,
                  color: Colors.green[700],
                  size: 30,
                )
              ],
            ),
          ),
          Positioned(
            top: 70,
            left: 20,
            child: Text(
              'Progress',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Baloo 2',
                color: Colors.grey[600],
                fontWeight: FontWeight.w700
              ),
            ),
          ),
          Positioned(
            top: 90,
            left: 20,
            child: Row(
              children: [
                Container(
                  width: 175,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Theme.of(context).ourGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 175 * 0.3, 
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF66417D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '30%',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Baloo 2',
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w700
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 120,
            left: 20,
            child: Row(
              children: [
                Icon(
                  Icons.date_range_outlined,
                  color: Theme.of(context).lightPurple,
                  size: 20,
                ),
                const SizedBox(width: 2),
                Text(
                  widget.taskStartDate, 
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 15),
                Icon(
                  Icons.flag_outlined,
                  color: Theme.of(context).lightPurple,
                  size: 20,
                ),
                const SizedBox(width: 2),
                Text(
                  widget.taskEndDate, 
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 155,
            left: 20,
            child: Row(
              children: [
                Image.asset(
                  'lib/Images/prof-stack.png',
                  width: 97,
                  height: 30,
                ),
                const SizedBox(width: 140),
                Container(
                  height: 30,
                  width: 70,
                  decoration: BoxDecoration(
                    color: widget.priorityColor, 
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Text(
                      widget.taskPriority, 
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Baloo 2',
                        fontSize: 16
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}