import 'package:cubos_movies/model/movie_genre.dart';
import 'package:cubos_movies/model/movie.dart';
import 'package:cubos_movies/view/widgets/genre_movies.dart';
import 'package:cubos_movies/view/widgets/search_bar_widget.dart';
import 'package:cubos_movies/view/widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';

class GenresTabWidget extends StatefulWidget {
  final List<Movie> movies;
  final List<MovieGenre> genres;

  GenresTabWidget({
    required this.movies,
    required this.genres,
  });

  @override
  _GenresTabWidgetState createState() => _GenresTabWidgetState();
}

class _GenresTabWidgetState extends State<GenresTabWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String query = '';
  late List<Movie> movies;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
    movies = widget.movies;
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            child: Container(
              child: SearchBarWidget(
                hintText: 'Pesquise filmes',
                onChanged: searchMovie,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: TabBarWidget(
                controller: _tabController,
                itens: _tabItens,
              ),
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

  void searchMovie(String query) {
    final movies = widget.movies
        .where(
          (m) => m.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    setState(() {
      this.query = query;
      this.movies = movies;
    });
  }
}
