import 'package:flutter/material.dart';
class Compartment extends StatelessWidget {
  final int number ;
  const Compartment({required this.number});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300, // Border color
            width: 2.0,         // Border width
          ),
          borderRadius: BorderRadius.circular(5.0), // Optional: Add rounded corners
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

  }
}
class colorCircle extends StatelessWidget {
  final Color color;
  const colorCircle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 50.0,
      decoration: BoxDecoration(
        color: color, // Use the color parameter directly
        shape: BoxShape.circle,
      ),
    );
  }
}