import 'package:flutter/material.dart';

class ProfileStatus extends StatelessWidget {
  const ProfileStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Seja bem-vinde !'),
              Text('Turma 701'),
            ],
          ),
        ],
      ),
    );
  }
}
