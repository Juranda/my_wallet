import 'package:flutter/material.dart';

class MyWalletInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool password;

  final void Function() onSubmit;

  const MyWalletInput({
    super.key,
    required this.hintText,
    required this.controller,
    required this.password,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TextField(
        onSubmitted: (_) => onSubmit(),
        controller: controller,
        cursorColor: Theme.of(context).primaryColor,
        obscureText: password,
        enableSuggestions: !password,
        autocorrect: !password,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
