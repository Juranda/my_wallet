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
      style: TextStyle(
        color: Theme.of(context).colorScheme.background,
      ),
      decoration: InputDecoration(
        label: Text(
          label,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: label,
        contentPadding: const EdgeInsets.only(
          top: 10,
          left: 10,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
      ),
    );
  }
}
