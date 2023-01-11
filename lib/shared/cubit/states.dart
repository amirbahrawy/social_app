abstract class AppStates {}

// intial state
class AppInitialState extends AppStates {}

// get user data
class AppGetUserSuccessState extends AppStates {}

class AppGetUserLoadingState extends AppStates {}

class AppGetUserErrorState extends AppStates {
  final String error;

  AppGetUserErrorState(this.error);
}
// get posts
class AppGetPostsSuccessState extends AppStates {}

class AppGetPostsLoadingState extends AppStates {}

class AppGetPostsErrorState extends AppStates {
  final String error;

  AppGetPostsErrorState(this.error);
}

// get users of chat
class AppGetAllUsersSuccessState extends AppStates {}

class AppGetAllUsersLoadingState extends AppStates {}

class AppGetAllUsersErrorState extends AppStates {
  final String error;

  AppGetAllUsersErrorState(this.error);
}

// chat states
class AppGetMessagesSuccessState extends AppStates {}

class AppGetMessagesLoadingState extends AppStates {}

class AppGetMessagesErrorState extends AppStates {
  final String error;

  AppGetMessagesErrorState(this.error);
}

class AppSendMessagesSuccessState extends AppStates {}

class AppSendMessagesErrorState extends AppStates {}

// post like
class AppLikePostSuccessState extends AppStates {}

class AppLikePostErrorState extends AppStates {
  final String error;

  AppLikePostErrorState(this.error);
}

// bottom nav
class AppChangeBottomNavState extends AppStates {}

// new post screen state
class AppNewPostState extends AppStates {}

// edit profile
class AppProfileImagePickedSuccessState extends AppStates {}

class AppProfileImagePickedErrorState extends AppStates {}

class AppCoverImagePickedSuccessState extends AppStates {}

class AppCoverImagePickedErrorState extends AppStates {}

class AppUploadProfileImageSuccessState extends AppStates {}

class AppUploadProfileImageLoadingState extends AppStates {}

class AppUploadProfileImageErrorState extends AppStates {}

class AppUploadCoverImageSuccessState extends AppStates {}

class AppUploadCoverImageLoadingState extends AppStates {}

class AppUploadCoverImageErrorState extends AppStates {}

class AppUpdateUserErrorState extends AppStates {
  final String error;

  AppUpdateUserErrorState(this.error);
}

class AppUpdateUserLoadingState extends AppStates {
  AppUpdateUserLoadingState();
}

// create post
class AppPostImagePickedErrorState extends AppStates {}

class AppPostImagePickedSuccessState extends AppStates {}

class AppCreatePostSuccessState extends AppStates {}

class AppCreatePostLoadingState extends AppStates {}

class AppCreatePostErrorState extends AppStates {}

class AppRemovePostImageState extends AppStates {}
