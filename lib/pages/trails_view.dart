import 'package:flutter/material.dart';
import 'package:my_wallet/components/trail_card.dart';

class TrailsView extends StatelessWidget {
  const TrailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
        ),
        Container(
          height: 350,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              TrailCard(),
              TrailCard(),
              TrailCard(),
            ],
          ),
        ),
      ],
    );
  }
}
