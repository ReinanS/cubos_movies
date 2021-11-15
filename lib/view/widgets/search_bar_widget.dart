import 'package:cubos_movies/view/utils/utils.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Widget icon;

  SearchBarWidget({
    required this.controller,
    required this.labelText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      style: TextStyle(color: AppColors.grey, fontSize: 16),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon,
        labelStyle: TextStyle(color: AppColors.grey, fontSize: 16),
        contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 18),
        fillColor: AppColors.lightGrey,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
