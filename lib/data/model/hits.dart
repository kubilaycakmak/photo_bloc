import 'package:equatable/equatable.dart';

class Hits extends Equatable{
  Hits(
      {this.id,
      this.type,
      this.tags,
      this.previewURL,
      this.webUrl,
      this.largeUrl,
      this.iwidth,
      this.iheight,
      this.size,
      this.view,
      this.download,
      this.fav,
      this.likes,
      this.comments,
      this.user});

  final String largeUrl, user, webUrl, type, tags, previewURL;
  final int likes, id, download, view, size, iwidth, iheight, comments, fav;

  factory Hits.fromJson(Map<dynamic, dynamic> value) {
    return Hits(
        id: value['id'],
        type: value['type'],
        tags: value['tags'],
        previewURL: value['previewURL'],
        webUrl: value['webformatURL'],
        largeUrl: value['largeImageURL'],
        iwidth: value['imageWidth'],
        iheight: value['imageHeight'],
        size: value['imageSize'],
        view: value['views'],
        download: value['downloads'],
        fav: value['favorites'],
        likes: value['likes'],
        comments: value['comments'],
        user: value['user']);
  }

  @override
  List<Object> get props => [
    id,
    type,
    tags,
    previewURL,
    webUrl,
    largeUrl,
    iwidth,
    iheight,
    size,
    view,
    download,
    fav,
    likes,
    comments,
    user
  ];
}
