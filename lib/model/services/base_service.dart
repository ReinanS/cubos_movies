abstract class BaseService {
  final String dbBaseUrl = "https://api.themoviedb.org/3";

  Future<dynamic> getResponse(String url);
}
