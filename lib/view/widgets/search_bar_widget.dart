import 'package:cubos_movies/view/utils/utils.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  SearchBarWidget({
    required this.hintText,
    required this.onChanged,
  });

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      keyboardType: TextInputType.text,
      style: TextStyle(color: AppColors.grey, fontSize: 16),
      decoration: InputDecoration(
        labelText: widget.hintText,
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.grey,
        ),
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
