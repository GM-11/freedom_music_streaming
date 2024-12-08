import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class Auth {

  Future signUp(String name, String email, String password) async {
    String url =
        "http://192.168.1.8:8080/user?name=$name&email=$email&password=$password";
    var response = await http.post(Uri.parse(url));
    log(response.body);

    try {
      dynamic decodedJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return decodedJson;
      } else {
        return {"error": decodedJson["error"]};
      }
    } catch (e) {
      log(e.toString());
      return {"error": "An error occurred"};
    }
  }

  Future signIn(String email) async {
    String url = "http://192.168.1.8:8080/user?email=$email";

    var response = await http.get(Uri.parse(url));
    log(response.body);

    try {
      dynamic decodedJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return decodedJson;
      } else {
        return {"error": decodedJson["error"]};
      }
    } catch (e) {
      log(e.toString());
      return {"error": "An error occurred"};
    }
  }
}
