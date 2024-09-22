import 'package:flutter/material.dart';
import 'package:my_wallet/app/models/trail.dart';

class TrailView extends StatelessWidget {
  late Trail trail;

  TrailView({super.key});

  @override
  Widget build(BuildContext context) {
    this.trail = ModalRoute.of(context)!.settings.arguments as Trail;

    return Container();
  }
}
