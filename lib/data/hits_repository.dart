import 'package:flutter/cupertino.dart';
import 'package:photo_bloc/data/hits_api_client.dart';
import 'model/hits.dart';

class HitsRepository {
  final HitsApiClient hitsApiClient;

  HitsRepository({@required this.hitsApiClient})
      : assert(hitsApiClient != null);

  Future<List<Hits>> fetchHits(String type) async {
    return await hitsApiClient.fetchHits(type);
  }
}
