import 'package:flutter/material.dart';

class PieIndicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  const PieIndicator({required this.color, required this.text, required this.isSquare, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 20,
            height: isSquare ? 20 : 30,
            color: color,
          ),
          Text(text, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
} 