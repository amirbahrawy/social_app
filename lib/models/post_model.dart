class PostModel {
  late final String uId;
  late final String userName;
  late final String dateTime;
  late final String image;
  late final String postText;
  String? postImage;
  final String? postId;
  final int? likesNumber;

  PostModel(
      {required this.uId,
      required this.userName,
      required this.postText,
      required this.dateTime,
      required this.image,
      this.likesNumber,
      this.postId,
      this.postImage});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        uId: json['uId'],
        userName: json['userName'],
        dateTime: json['dateTime'],
        postText: json['postText'],
        image: json['image'],
        postImage: json['postImage'],
        postId: json['postId'],
        likesNumber: json['likesNumber'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'userName': userName,
      'dateTime': dateTime,
      'postText': postText,
      'image': image,
      'postImage': postImage,
    };
  }
}
