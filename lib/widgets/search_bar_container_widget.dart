import 'package:cubos_movies/core/app_colors.dart';
import 'package:flutter/material.dart';

class SearchBarContainerWidget extends StatelessWidget {
  final String hintText;

  SearchBarContainerWidget({
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(100),
      ),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 18),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15),
            child: Icon(
              Icons.search,
              color: AppColors.grey,
            ),
          ),
          Text(
            hintText,
            style: TextStyle(color: AppColors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
