import 'package:flutter/material.dart';

class StatelessSection extends StatelessWidget {
  final String sectionTitle;
  final List<Widget>? items;
  final double sectionHeight;

  const StatelessSection({
    super.key,
    this.items,
    required this.sectionTitle,
    required this.sectionHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 10),
          child: Text(
            sectionTitle,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (items != null)
          Container(
            height: sectionHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: items!,
            ),
          )
      ],
    );
  }
}
