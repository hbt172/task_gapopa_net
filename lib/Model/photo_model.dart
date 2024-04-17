class PhotoModel {
  int? id;
  String? webformatURL;
  String? largeImageURL;
  int? views;
  int? likes;

  PhotoModel({
    this.id,
    this.webformatURL,
    this.largeImageURL,
    this.views,
    this.likes,
  });

  PhotoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    webformatURL = json['webformatURL'];
    largeImageURL = json['largeImageURL'];
    views = json['views'];
    likes = json['likes'];
  }
}
