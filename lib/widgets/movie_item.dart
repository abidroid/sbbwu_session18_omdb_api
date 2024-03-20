

import 'package:flutter/material.dart';

// Re usable widget

class MovieItem extends StatelessWidget {
  final String heading;
  final String value;
  
  const MovieItem({super.key, required this.heading, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber, width: 2),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(children: [
        Text(heading),
        const Divider(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600),),
      ],),
    );
  }
}
