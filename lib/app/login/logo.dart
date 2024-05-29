import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 216,
      width: 344,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
        ),
      ),
    );
  }
}
