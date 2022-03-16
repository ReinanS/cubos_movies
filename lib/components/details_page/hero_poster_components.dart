import 'package:cubos_movies/models/movie_detail_model.dart';
import 'package:cubos_movies/pages/movie_detail_page.dart';
import 'package:cubos_movies/core/utils/api.utils.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class HeroPosterComponents extends StatelessWidget {
  const HeroPosterComponents({
    Key? key,
    required this.deviceSize,
    required this.widget,
    required this.movie,
  }) : super(key: key);

  final Size deviceSize;
  final MovieDetailScreen widget;
  final MovieDetailModel movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      height: deviceSize.height * 0.7,
      child: Center(
        child: Hero(
          tag: widget.movieId,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: API.requestImage(movie.posterPath!),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
