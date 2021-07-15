import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technocloud_task/models/post_model.dart';
import 'package:technocloud_task/modules/cubit/cubit/states.dart';

class ProjectCubit extends Cubit<BlocStates> {
  ProjectCubit() : super(LoginInitialState());

  static ProjectCubit get(context) => BlocProvider.of(context);

  //login logic
  void userLogin({
    @required String email,
    @required String password,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      sharedPreferences.setString('id', value.user.uid);
      emit(LoginSuccessState());
    }).catchError((error) {
      emit(LoginErrorState(error: error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ShopChangePasswordVisibilityState());
  }

  //upload Post logic
  File postImage;
  var picker = ImagePicker();

  Future<void> getPostImage() async {
    final pickFile = await picker.getImage(source: ImageSource.gallery);
    if (pickFile != null) {
      postImage = File(pickFile.path);
      emit(PostImageSuccessState());
    } else {
      print('no image');
      emit(PostImageErrorState());
    }
  }

  void uploadPostImage({
    @required String name,
    @required String uId,
    @required String dataTime,
    @required String text,
  }) async {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage.path).pathSegments.last}')
        .putFile(postImage)
        .then((valeu) {
      valeu.ref.getDownloadURL().then((valuee) {
        createPost(
            name: name, postImagee: valuee, dataTime: dataTime, text: text);
      });
      print(valeu);
    }).catchError((error) {
      emit(PostImageErrorState());
    });
    emit(PostLoadingState());
  }

  void createPost({
    @required String name,
    @required String postImagee,
    @required String dataTime,
    @required String text,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString('id');
    PostModel postModel = PostModel(
        name: name,
        uId: id,
        postImage: postImagee ?? '',
        dataTime: dataTime,
        text: text);
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      emit(PostSuccessState());
    }).catchError((error) {
      emit(PostErrorState());
    });
  }

  //Get Post logic
  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int> comments = [];
  List<String> Id = [];

  void getPostData() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dataTime')
        .snapshots()
        .listen((event) {
      posts = [];
      event.docs.forEach((element) {
        Id.add(element.id);
        posts.add(PostModel.fromjson(element.data()));
        emit(GetPostSuccessState());
      });
    });
  }

  List<int> likes2 = [];
  void getLikes(String postId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String uId = sharedPreferences.getString('id');
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('like')
        .doc(uId)
        .snapshots()
        .listen((event) {
      likes.add(event.data().length);
      print(event.data().length);
    });
  }

  //Add Like and Remove
  void addLike(
    String postId,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String uId = sharedPreferences.getString('id');
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('like')
        .doc(uId)
        .set({'like': true}).then((value) {
      emit(AddLikeSuccessState());
    }).catchError((error) {
      emit(AddLikeErrorState(error: error.toString()));
    });
  }

  void removeLike(
    String postId,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String uId = sharedPreferences.getString('id');
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('like')
        .doc(uId)
        .delete()
        .then((value) {
      emit(AddLikeSuccessState());
    }).catchError((error) {
      emit(AddLikeErrorState(error: error.toString()));
    });
  }

  //Add Comment
  void addComment(String postId, String comment) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String uId = sharedPreferences.getString('id');
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comment')
        .doc(uId)
        .set({'comment': comment}).then((value) {
      emit(CommentLikeSuccessState());
    }).catchError((error) {
      emit(CommentLikeErrorState(error: error.toString()));
    });
  }
}
