// import 'dart:developer';

// import 'package:cubos_movies/controllers/genre_controller.dart';
// import 'package:cubos_movies/core/constant.dart';
// import 'package:cubos_movies/model/apis/api_response.dart';
// import 'package:cubos_movies/model/movie_genre.dart';
// import 'package:cubos_movies/model/repository/movie_repository.dart';
// import 'package:cubos_movies/view/widgets/genres_tab_widget.dart';
// import 'package:cubos_movies/view_model/genre_view_model.dart';
// import 'package:cubos_movies/widgets/centered_message.dart';
// import 'package:cubos_movies/widgets/centered_progress.dart';
// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final _controller = GenreController();

//   @override
//   void initState() {
//     super.initState();
//     _initialize();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: _buildAppBar(),
//         body: _getGenres());
//   }

//   Future<void> _initialize() async {
//     setState(() {
//       _controller.loading = true;
//     });

//     await _controller.fetchAllGenres();

//     setState(() {
//       _controller.loading = false;
//     });
//   }

//   _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       title: Text(Constant.kAppName, style: TextStyle(color: Colors.black)),
//     );
//   }

//   Widget _getGenres() {
//     if (_controller.loading) {
//       return CenteredProgress();
//     }

//     if (_controller.movieError != null || !_controller.hasGenres) {
//       return CenteredMessage(message: _controller.movieError!.message!);
//     }

//     return Column(
//       children: _controller.genres.map((genre) => Text(genre.name!)).toList(),
//     );

//     // return GenresTabWidget(genres: _controller.genres);
//   }
// }
