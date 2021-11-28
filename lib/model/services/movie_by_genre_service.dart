import 'dart:io';

import 'package:cubos_movies/model/apis/app_exception.dart';
import 'package:cubos_movies/model/services/base_service.dart';
import 'package:cubos_movies/view/utils/constansts.dart';
import 'package:http/http.dart' as http;

class MovieByGenreService extends BaseService {
  Future<dynamic> getAllMovies(int page, int genre) async {
    dynamic responseJson;

    final params = {
      "api_key": TmdbConstants.apiKey,
      "language": "pt-BR",
      "page": page.toString(),
      "with_genres": genre.toString(),
    };

    final String queryString = Uri(queryParameters: params).query;
    final String urlString = dbBaseUrl + "/movie/popular" + '?' + queryString;

    try {
      final response = await http.get(Uri.parse(urlString));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      print(e);
    }

    return responseJson;
  }

  @override
  Future getResponse(String url) {
    throw UnimplementedError();
  }
}
