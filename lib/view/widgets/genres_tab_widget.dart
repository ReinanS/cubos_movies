import 'dart:developer';

import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/model/movie_model.dart';
import 'package:cubos_movies/view/screens/movie_search_screen.dart';
import 'package:cubos_movies/view/widgets/genre_movies.dart';
import 'package:cubos_movies/view/widgets/search_bar_container_widget.dart';
import 'package:cubos_movies/view/widgets/search_bar_widget.dart';
import 'package:cubos_movies/view/widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';

class GenresTabWidget extends StatefulWidget {
  final List<MovieGenre> genres;

  GenresTabWidget({
    required this.genres,
  });

  @override
  _GenresTabWidgetState createState() => _GenresTabWidgetState();
}

class _GenresTabWidgetState extends State<GenresTabWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String query = '';
  late List<MovieModel> movies;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<MovieGenre> _tabGenres = [
      widget.genres.firstWhere((g) => g.name.toLowerCase() == 'ação'),
      widget.genres.firstWhere((g) => g.name.toLowerCase() == 'aventura'),
      widget.genres.firstWhere((g) => g.name.toLowerCase() == 'fantasia'),
      widget.genres.firstWhere((g) => g.name.toLowerCase() == 'comédia'),
    ];

    final List<String> _tabItens = [
      _tabGenres[0].name,
      _tabGenres[1].name,
      _tabGenres[2].name,
      _tabGenres[3].name,
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MovieSearchScreen(genres: widget.genres)));
            },
            child: SearchBarContainerWidget(
              hintText: 'Pesquise filmes',
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            child: TabBarWidget(
              controller: _tabController,
              itens: _tabItens,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: _tabGenres
                  .map((genre) => GenreMovies(
                        genreId: genre.id,
                        genres: widget.genres,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
