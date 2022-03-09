import 'package:cubos_movies/core/app_colors.dart';
import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  InfoBox({
    required this.leadingText,
    required this.text,
  });

  final String leadingText;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            leadingText,
            style: TextStyle(
              color: AppColors.mediumGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Text(
              ' $text',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
