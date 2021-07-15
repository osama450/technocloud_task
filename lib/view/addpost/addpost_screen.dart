import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technocloud_task/modules/cubit/cubit/cubit.dart';
import 'package:technocloud_task/modules/cubit/cubit/states.dart';
import 'package:technocloud_task/shared/styles/size_config/size_config.dart';
import 'package:technocloud_task/shared/styles/theme/app_colors.dart';
import 'package:technocloud_task/shared/widgets/snackbar.dart';
import 'package:technocloud_task/shared/widgets/widgets.dart';

class PostScreen extends StatelessWidget {
  void _doSomething(BuildContext context) async {
    Timer(Duration(seconds: 4), () {
      Navigator.pop(context);
    });
  }

  var text = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectCubit(),
      child: BlocConsumer<ProjectCubit, BlocStates>(
        listener: (context, state) {
          if (state is PostSuccessState) {
            CustomSnackBar().notErrorShowSnackBar('Post Successfully');
            _doSomething(context);
            ProjectCubit.get(context).getPostData();
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Form(
              key: formKey,
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(5),
                          ),
                          AppText(
                            text: 'Crete Post',
                            color: AppColors.primary,
                            fontSize: 4,
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              var now = DateTime.now();
                              if (formKey.currentState.validate()) {
                                if (ProjectCubit.get(context).postImage ==
                                    null) {
                                  ProjectCubit.get(context).createPost(
                                      name: 'Osama mohamed',
                                      postImagee: '',
                                      dataTime: now.toString(),
                                      text: text.text);
                                } else {
                                  ProjectCubit.get(context).uploadPostImage(
                                      name: 'Osama mohamed',
                                      dataTime: now.toString(),
                                      text: text.text);
                                }
                              }
                            },
                            child: AppText(
                              text: 'Post',
                              color: Colors.blue,
                              fontSize: 3.6,
                            ),
                          )
                        ],
                      ),
                      Divider(),
                      if (state is PostLoadingState) LinearProgressIndicator(),
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            child: Icon(Icons.perm_identity_rounded),
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(10),
                          ),
                          AppText(
                            text: 'Osama mohamed',
                            color: AppColors.primary,
                            fontSize: 3.5,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextFormField(
                            controller: text,
                            keyboardType: TextInputType.emailAddress,
                            // ignore: missing_return
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'You Should type anything';
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'What is on your mind ...?',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                ProjectCubit.get(context).getPostImage();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.photo,
                                    color: AppColors.primary,
                                    size: getSizeText(4),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(5),
                                  ),
                                  AppText(
                                    text: 'add photo',
                                    color: AppColors.primary,
                                    fontSize: 3.4,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.photo,
                                    color: AppColors.primary,
                                    size: getSizeText(4),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(5),
                                  ),
                                  AppText(
                                    text: '# tags',
                                    color: AppColors.primary,
                                    fontSize: 3.4,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
