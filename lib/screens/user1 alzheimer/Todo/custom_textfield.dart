import 'package:flutter/material.dart';

class CustomTextField1 extends StatelessWidget {
  const CustomTextField1({
    super.key,
    required this.hint,
    this.icon,
    this.onTap,
    this.readOnly = false,
    this.controller,
  });

  final String hint;
  final IconData? icon;
  final void Function()? onTap;
  final bool readOnly;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          suffixIcon: icon != null
              ? InkWell(
                  onTap: onTap,
                  child: Icon(icon),
                )
              : null,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }
}
