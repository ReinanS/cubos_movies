import 'package:cubos_movies/core/app_colors.dart';
import 'package:flutter/material.dart';

class DescriptionText extends StatelessWidget {
  DescriptionText({
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.mediumGrey,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Text(
            text,
            style: TextStyle(
              color: AppColors.mediumGrey,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
