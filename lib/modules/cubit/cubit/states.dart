abstract class BlocStates {}

// for login
class LoginInitialState extends BlocStates {}

class LoginLoadingState extends BlocStates {}

class LoginSuccessState extends BlocStates {}

class LoginErrorState extends BlocStates {
  final String error;

  LoginErrorState({this.error});
}

class ShopChangePasswordVisibilityState extends BlocStates {}

//for uploadPost
class PostImageSuccessState extends BlocStates {}

class PostImageErrorState extends BlocStates {}

class PostLoadingState extends BlocStates {}

class PostSuccessState extends BlocStates {}

class PostErrorState extends BlocStates {
  final String error;

  PostErrorState({this.error});
}

//for GetPost
class GetPostSuccessState extends BlocStates {}

class GetPostLoadingState extends BlocStates {}

class GetPostErrorState extends BlocStates {
  final String error;

  GetPostErrorState({this.error});
}

//for Like Post
class AddLikeSuccessState extends BlocStates {}

class AddLikeLoadingState extends BlocStates {}

class AddLikeErrorState extends BlocStates {
  final String error;

  AddLikeErrorState({this.error});
}

//for Comment Post
class CommentLikeSuccessState extends BlocStates {}

class CommentLikeLoadingState extends BlocStates {}

class CommentLikeErrorState extends BlocStates {
  final String error;

  CommentLikeErrorState({this.error});
}
