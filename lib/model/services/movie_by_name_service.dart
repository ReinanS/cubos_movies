import 'dart:developer';
import 'dart:io';

import 'package:cubos_movies/view/utils/constansts.dart';
import 'package:cubos_movies/model/apis/app_exception.dart';
import 'package:cubos_movies/model/services/base_service.dart';
import 'package:http/http.dart' as http;

class MovieByNameService extends BaseService {
  Future<dynamic> getMovies(String query, int page) async {
    dynamic responseJson;

    final params = {
      "api_key": TmdbConstants.apiKey,
      "language": "pt-BR",
      "query": query,
      "page": page.toString(),
    };

    final String queryString = Uri(queryParameters: params).query;
    final String urlString = dbBaseUrl + "/search/movie" + '?' + queryString;

    try {
      log(urlString);

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
  Future<dynamic> getResponse(String url) {
    throw UnimplementedError();
  }
}
