import 'package:flutter/material.dart';

class MyWalletFormInput extends StatelessWidget {
  final TextInputType? textInputType;
  final String label;
  final String? Function(String?)? validator;
  final bool showText;
  final bool isRequired;

  const MyWalletFormInput({
    super.key,
    this.textInputType = TextInputType.text,
    this.showText = true,
    this.isRequired = true,
    required this.label,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator ??
          (isRequired
              ? (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatorio';
                  }
                  return null;
                }
              : null),
      cursorColor: Theme.of(context).primaryColor,
      keyboardType: textInputType,
      obscureText: !showText,
      decoration: InputDecoration(
        label: Text(label),
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(8),
        border: InputBorder.none,
      ),
    );
  }
}
