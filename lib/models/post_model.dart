class PostModel {
  String name;
  String uId;
  String postImage;
  String dataTime;
  String text;
  int like;
  PostModel(
      {this.name,
      this.uId,
      this.postImage,
      this.dataTime,
      this.text,
      this.like});

  PostModel.fromjson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    postImage = json['postImage'];
    dataTime = json['dataTime'];
    text = json['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'postImage': postImage,
      'dataTime': dataTime,
      'text': text
    };
  }
}
