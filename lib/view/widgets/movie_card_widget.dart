import 'dart:developer';

import 'package:cubos_movies/view/utils/constansts.dart';
import 'package:cubos_movies/model/movie_model.dart';
import 'package:cubos_movies/view/screens/movie_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieCardWidget extends StatefulWidget {
  final MovieModel movie;
  final String movieGenres;

  MovieCardWidget({
    required this.movie,
    required this.movieGenres,
  });

  @override
  _MovieCardWidgetState createState() => _MovieCardWidgetState();
}

class _MovieCardWidgetState extends State<MovieCardWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildMovieCard();
  }

  Widget _buildMovieCard() {
    Size deviceSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        // detalhar movie
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieDetailScreen(
                      movieId: widget.movie.id!,
                    )));

        log(widget.movie.id.toString());
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          child: Stack(
            children: [
              Hero(
                tag: widget.movie.id!,
                child: Container(
                  height: deviceSize.height * 0.7,
                  width: deviceSize.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: widget.movie.posterPath != null
                          ? TmdbConstants.imageBase + widget.movie.posterPath!
                          : 'https://motivatevalmorgan.com/wp-content/uploads/2016/06/default-movie-768x1129.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: deviceSize.width * 0.8,
                  // height: deviceSize.height * 0.2,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.01), Colors.black],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          widget.movie.title!.toUpperCase(),
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        widget.movieGenres,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
