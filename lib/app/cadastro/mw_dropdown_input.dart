import 'package:flutter/material.dart';

class MyWalletDropdownInput extends StatelessWidget {
  final Object value;
  final List<DropdownMenuItem<Object>>? items;
  final void Function(Object?)? onChanged;
  final bool expanded;
  final Object turmaSelecionada = 0;

  const MyWalletDropdownInput({
    super.key,
    required this.items,
    required this.onChanged,
    required this.value,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          isExpanded: true,
          value: 2,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
