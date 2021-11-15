import 'dart:convert';

import 'package:cubos_movies/model/apis/app_exception.dart';
import 'package:http/http.dart' as http;

abstract class BaseService {
  final String dbBaseUrl = "https://api.themoviedb.org/3";

  Future<dynamic> getResponse(String url);

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }
}
