import 'package:http/http.dart' as http;
import 'package:untitled/entity.dart';

abstract class Repository {
  Future<bool> isUserAvailable(String email, String password);
}

class RepositoryImpl implements Repository {
  @override
  Future<bool> isUserAvailable(String email, String password) async {
    var client = http.Client();
    var response = await client.post(Uri.https('reqres.in', '/api/login'),
        body: {"email": email, "password": password});
    switch (response.statusCode) {
      case 200:
        return userFromJson(response.body).token.isNotEmpty;
        break;
      case 404:
        throw Exception("Please check your internet connection");
        break;
      default:
        throw Exception("Something went wrong");
        break;
    }
  }
}
