import 'package:cubos_movies/core/tmdb_api.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String posterPath;
  final Function() onTap;

  const MovieCard({
    required this.posterPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              TmdbApi.requestImage(posterPath),
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
