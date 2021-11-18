import 'package:cubos_movies/model/apis/api_response.dart';
import 'package:cubos_movies/model/genre.dart';
import 'package:cubos_movies/model/movie.dart';
import 'package:cubos_movies/view/utils/utils.dart';
import 'package:cubos_movies/view/widgets/genres_tab_widget.dart';
import 'package:cubos_movies/view/widgets/search_bar_widget.dart';
import 'package:cubos_movies/view_model/movie_view_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>?> movies;

  final MovieViewModel viewModel = MovieViewModel();
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    viewModel.fetchGenresList();
    viewModel.apiResponse.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ApiResponse apiResponse = viewModel.response;
    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: deviceSize * 0.25,
          child: Column(
            children: [
              AppBar(
                title: Text(
                  'Filmes',
                  style: TextStyle(color: Colors.black),
                ),
                toolbarHeight: 80,
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: SearchBarWidget(
                    labelText: 'Pesquise filmes',
                    controller: controller,
                    icon: Icon(
                      Icons.search,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: _getGenres(apiResponse));
  }

  Widget _getGenres(ApiResponse apiResponse) {
    List<Genre>? genreList = apiResponse.data as List<Genre>?;

    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());

      case Status.COMPLETED:
        return GenresTabWidget(
          genres: genreList!,
        );

      case Status.ERROR:
        return Center(
          child: Text('Please try again Later !!'),
        );

      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search the Genres'),
        );
    }
  }
}
