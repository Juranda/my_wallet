import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyWalletFormInput extends StatelessWidget {
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String label;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool showText;
  final bool isRequired;

  const MyWalletFormInput({
    super.key,
    this.textInputType,
    this.inputFormatters,
    this.showText = true,
    this.isRequired = true,
    required this.label,
    this.validator,
    this.controller,
    this.onFieldSubmitted,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
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
      controller: controller,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        label: Text(label),
        isDense: true,
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary,
        contentPadding: const EdgeInsets.all(8),
        border: InputBorder.none,
      ),
    );
  }
}
