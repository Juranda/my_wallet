import 'package:flutter/material.dart';

class TrailLobbyCard extends StatelessWidget {
  final String trailName;
  final String trailDescription;

  const TrailLobbyCard({
    super.key,
    required this.trailName,
    required this.trailDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 150,
        width: 200,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trailName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    trailDescription,
                  )
                ],
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
