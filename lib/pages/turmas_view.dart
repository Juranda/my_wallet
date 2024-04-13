import 'package:flutter/material.dart';

class TurmasView extends StatelessWidget {
  const TurmasView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.08,
            child: Center(
              child: Text(
                "Turma",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
