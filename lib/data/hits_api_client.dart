import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:flutter/cupertino.dart';
// import 'dart:ui';
import 'package:http/http.dart' as http;

import 'model/hits.dart';

class HitsApiClient {
  final _baseUrl =
      'https://pixabay.com/api/?key=14951209-61b2f6019e4d1a85e007275aa';
  final http.Client httpClient;

  HitsApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<List<Hits>> fetchHits(String type) async {
    //int perPage, int pageNumer, _, String type
    final url = '$_baseUrl&order=$type&editors_choice=true&orientation=horizontal';
    print(url);
    // '&pageNumber=$pageNumber'+
    // '&per_page=$perPage&editors_choice=true&category=$_' +
    // '&orientation=vertical&min_width=${window.physicalSize.width}' +
    // '&min_height=${window.physicalSize.height}';
    final response = await this.httpClient.get(url);

    if (response.statusCode != 200) {
      throw new Exception('error getting hits');
    }
    List jsonData = json.decode(response.body)['hits'];
    return jsonData.map((e) => Hits.fromJson(e)).toList();
  }
}
