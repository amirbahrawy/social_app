class UserDataModel {
  UserDataModel(
      {required this.uId,
      required this.userName,
      required this.email,
      required this.phone,
      this.bio,
      this.image =
          'https://img.freepik.com/free-photo/young-handsome-man-listens-music-with-earphones_176420-15616.jpg?w=740&t=st=1670586069~exp=1670586669~hmac=757e4a5b47e2ee0d3cb65b3ada35c62740684e22075cb6600cc7a028bf806b66',
      this.cover =
          'https://img.freepik.com/free-photo/science-fiction-scene_456031-64.jpg?w=826&t=st=1670594935~exp=1670595535~hmac=5f8d492331d0d67ff191eb63bd3e99e0b239773f8c93367e9a21516566dac924',
      this.isEmailVerified = false});

  late final String uId;
  late final String userName;
  late final String email;
  late final String phone;
  late final String image;
  late final String cover;
  late final String? bio;
  late final bool isEmailVerified;

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
        uId: json['uId'],
        userName: json['userName'],
        email: json['email'],
        phone: json['phone'],
        cover: json['cover'],
        image: json['image'],
        bio: json['bio'] ?? 'write your bio...',
        isEmailVerified: json['isEmailVerified']);
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'userName': userName,
      'email': email,
      'phone': phone,
      'image': image,
      'cover': cover,
      'bio': bio,
      'isEmailVerified': isEmailVerified
    };
  }
}
