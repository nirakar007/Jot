import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  TextEditingController? controller;
  bool ? obscureText;
  String? hintText;
  Widget? suffixIcon;
  Widget? prefixIcon;
   CommonTextField({super.key,
     this.prefixIcon,
     required this.controller,this.obscureText = false,this.hintText,this.suffixIcon});

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText!,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 0.5),
        ),
      ),
    );
  }
}
