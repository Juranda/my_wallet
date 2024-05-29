import 'package:flutter/material.dart';

class MyWalletButton extends StatelessWidget {
  final Image image;
  final String label;
  final void Function() onPressed;

  const MyWalletButton({
    super.key,
    required this.image,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 34, 87, 36),
        elevation: 5,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(50),
          ),
        ),
      ),
      child: SizedBox(
        height: 120,
        child: Row(
          children: [
            SizedBox(
              width: 270,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  overflow: TextOverflow.visible,
                  label,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 70,
              height: 70,
              child: Image(
                image: image.image,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
