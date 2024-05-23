import 'package:flutter/material.dart';
import 'package:my_wallet/routes.dart';

import 'profile_status.dart';

class MyWalletAppBar extends StatelessWidget {
  const MyWalletAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfileStatus(),
            InkWell(
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.APP_SETTINGS,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
