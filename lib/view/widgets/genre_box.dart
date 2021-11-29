import 'package:cubos_movies/view/utils/utils.dart';
import 'package:flutter/material.dart';

class GenreBox extends StatelessWidget {
  GenreBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.mediumGrey, width: 0.1),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: AppColors.mediumGrey,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
