import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_data_model.dart';
import 'package:social_app/modules/chats/chats.dart';
import 'package:social_app/modules/feeds/feeds.dart';
import 'package:social_app/modules/settings/settings.dart';
import 'package:social_app/modules/users/users.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:image_picker/image_picker.dart';
import '../../modules/new_post/new_post.dart';
import '../components/constants.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  UserDataModel? userModel;

  void getUserData() {
    emit(AppGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      emit(AppGetUserSuccessState());
      debugPrint('user data ${value.data().toString()}');
      if (value.data() != null) {
        userModel = UserDataModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      debugPrint(error.toString());
      emit(AppGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    const FeedsScreen(),
    const ChatsScreen(),
    NewPostScreen(),
    const UsersScreen(),
    const SettingsScreen()
  ];

  List<String> titles = const [
    'News Feed',
    'Chats',
    'Add Post',
    'Users',
    'Settings'
  ];

  void changeBottomNav(int index) {
    if (index == 2) {
      emit(AppNewPostState());
    } else {
      currentIndex = index;
      emit(AppChangeBottomNavState());
      if (index == 1) {
        getAllUsers();
      }
    }
  }

  final ImagePicker _picker = ImagePicker();

  File? profileImage;

  Future<void> getProfileImage() async {
    var profileFile = await _picker.pickImage(source: ImageSource.gallery);
    if (profileFile != null) {
      profileImage = File(profileFile.path);
      emit(AppProfileImagePickedSuccessState());
      uploadProfileImage();
    } else {
      emit(AppProfileImagePickedErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    var coverFile = await _picker.pickImage(source: ImageSource.gallery);
    if (coverFile != null) {
      coverImage = File(coverFile.path);
      emit(AppCoverImagePickedSuccessState());
      uploadCoverImage();
    } else {
      emit(AppCoverImagePickedErrorState());
    }
  }

  String profileImageUrl = '';

  Future<void> uploadProfileImage() async {
    emit(AppUploadProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        debugPrint(value);
        profileImageUrl = value;
        emit(AppUploadProfileImageSuccessState());
      }).catchError((error) {
        emit(AppUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(AppUploadProfileImageErrorState());
    });
  }

  String coverImageUrl = '';

  Future<void> uploadCoverImage() async {
    emit(AppUploadCoverImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        debugPrint(value);
        coverImageUrl = value;
        emit(AppUploadCoverImageSuccessState());
      }).catchError((error) {
        emit(AppUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(AppUploadCoverImageErrorState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
  }) async {
    emit(AppUpdateUserLoadingState());
    if (profileImageUrl == '') {
      profileImageUrl = userModel!.image;
    }
    if (coverImageUrl == '') {
      coverImageUrl = userModel!.cover;
    }
    debugPrint('hwa da $profileImageUrl');
    debugPrint('cover is  $coverImageUrl');
    UserDataModel model = UserDataModel(
        uId: userModel!.uId,
        userName: name,
        bio: bio,
        phone: phone,
        email: userModel!.email,
        image: profileImageUrl,
        cover: coverImageUrl);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toJson())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(AppUpdateUserErrorState(error));
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    var postFile = await _picker.pickImage(source: ImageSource.gallery);
    if (postFile != null) {
      postImage = File(postFile.path);
      emit(AppPostImagePickedSuccessState());
    } else {
      emit(AppPostImagePickedErrorState());
    }
  }

  void uploadImagePost({
    required String dateTime,
    required String text,
  }) {
    emit(AppCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(text: text, dateTime: dateTime, postImage: value);
      }).catchError((error) {
        emit(AppCreatePostErrorState());
      });
    }).catchError((error) {
      emit(AppCreatePostErrorState());
    });
  }

  void createPost({
    required String text,
    required String dateTime,
    String? postImage,
  }) {
    emit(AppCreatePostLoadingState());
    PostModel model = PostModel(
        uId: userModel!.uId,
        userName: userModel!.userName,
        image: userModel!.image,
        dateTime: dateTime,
        postText: text,
        postImage: postImage);
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toJson())
        .then((value) {
      emit(AppCreatePostSuccessState());
    }).catchError((error) {
      emit(AppCreatePostErrorState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(AppRemovePostImageState());
  }

  List<PostModel> posts = [];
  Future<void> postsLoop(var value) async{
    for (var element in value.docs) {
      await element.reference.collection('likes').get().then((value) {
        Map<String, dynamic> data = {
          'postId': element.id,
          'likesNumber': value.docs.length
        };
        data.addAll(element.data());
        posts.add(PostModel.fromJson(data));
      }).catchError((error) {});
    }
  }
  Future<void> getPosts() async{
    emit(AppGetPostsLoadingState());
     FirebaseFirestore.instance.collection('posts').get().then((value) async {
        await postsLoop(value);
       emit(AppGetPostsSuccessState());
       print('de posts ${posts[0].postText}');

    }). catchError((error) {
      debugPrint('da error ${error.toString()}');
      emit(AppGetPostsErrorState(error.toString()));
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({'like': true}).then((value) {
      emit(AppLikePostSuccessState());
    }).catchError((error) {
      emit(AppLikePostErrorState(error.toString()));
    });
  }

  List<UserDataModel> users = [];

  void getAllUsers() {
    if (users.isEmpty) {
      emit(AppGetAllUsersLoadingState());
      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.id != userModel!.uId) {
            users.add(UserDataModel.fromJson(element.data()));
          }
        }
        emit(AppGetAllUsersSuccessState());
      }).catchError((error) {
        debugPrint(error.toString());
        emit(AppGetAllUsersErrorState(error.toString()));
      });
    }
  }

  void sendMessage(
      {required String receiverId,
      required String dateTime,
      required String msg}) {
    MessageModel model = MessageModel(
        senderId: userModel!.uId,
        receiverId: receiverId,
        text: msg,
        dateTime: dateTime);
    // set my chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toJson())
        .then((value) {
      emit(AppSendMessagesSuccessState());
    }).catchError((error) {
      emit(AppSendMessagesErrorState());
    });
    // set chat to receiver
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toJson())
        .then((value) {
      emit(AppSendMessagesSuccessState());
    }).catchError((error) {
      emit(AppSendMessagesErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({required String receiverId}) {
    emit(AppGetMessagesLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages').orderBy('dateTime')
        .snapshots()
        .listen((event) {
          messages=[];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(AppGetMessagesSuccessState());
    });
  }
}
