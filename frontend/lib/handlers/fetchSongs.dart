import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

class FetchSongs {

  final Dio _dio = Dio();

  Future<List<dynamic>> fetchSongsFromQuery(String query) async {
    String url = "http://192.168.1.8:8080/songs?query=$query";
    try {
      var response = await _dio.get(url);
      if (response.statusCode == 200) {
        dynamic decodedJson = response.data.cast<String, dynamic>();
        return decodedJson["data"];
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
