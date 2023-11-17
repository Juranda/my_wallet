import 'package:flutter/material.dart';
import 'package:my_wallet/styles.dart';

class TrailCard extends StatelessWidget {
  const TrailCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(20),
        height: 400,
        width: 350,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Styles.lightTextColor,
            width: 4,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                'Ensino Fundamental',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Nivel:\n- Tópico 1\n- Tópico 2\n- Tópico 3',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 30,
                      ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
