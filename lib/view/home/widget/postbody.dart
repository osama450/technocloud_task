import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technocloud_task/models/post_model.dart';
import 'package:technocloud_task/modules/cubit/cubit/cubit.dart';
import 'package:technocloud_task/shared/styles/size_config/size_config.dart';
import 'package:technocloud_task/shared/styles/theme/app_colors.dart';
import 'package:technocloud_task/shared/widgets/app_text.dart';

class PostBody extends StatefulWidget {
  PostModel postModel;
  final Size size;
  int index;
  PostBody({this.postModel, this.size, this.index});

  @override
  _PostBodyState createState() => _PostBodyState();
}

class _PostBodyState extends State<PostBody> {
  String uId;
  var comments = TextEditingController();
  getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    uId = sharedPreferences.getString('id');
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        width: widget.size.width * 1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 5),
                  blurRadius: 7,
                  color: Colors.grey.withOpacity(0.3))
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/IMG_8241.JPG'),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(15),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: widget.postModel.name,
                        color: Colors.black,
                        fontSize: 3.5,
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(5),
                      ),
                      AppText(
                        text: widget.postModel.dataTime,
                        color: Colors.grey,
                        fontSize: 3.2,
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: getProportionateScreenHeight(5),
              ),
              Divider(),
              SizedBox(
                height: getProportionateScreenHeight(5),
              ),
              Container(
                width: widget.size.width * 0.950,
                child: AppText(
                  text: '${widget.postModel.text}',
                  color: Colors.black,
                  fontSize: 3.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              widget.postModel.postImage != ''
                  ? Padding(
                      padding: const EdgeInsets.only(top: 13, bottom: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          width: widget.size.width * 1,
                          child: Image.network('${widget.postModel.postImage}'),
                        ),
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(ProjectCubit.get(context).Id[widget.index])
                              .collection('like')
                              .doc(uId)
                              .snapshots(),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        if (snapshot.data.data() == null) {
                                          ProjectCubit.get(context).addLike(
                                              ProjectCubit.get(context)
                                                  .Id[widget.index]);
                                        } else {
                                          ProjectCubit.get(context).removeLike(
                                              ProjectCubit.get(context)
                                                  .Id[widget.index]);
                                        }
                                      },
                                      child: Icon(
                                        snapshot.data.data() == null
                                            ? Icons.favorite_border
                                            : Icons.favorite,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(5),
                                  ),
                                  AppText(
                                    text: snapshot.data.data() == null
                                        ? '0'
                                        : '1',
                                    fontSize: 3.6,
                                    color: AppColors.primary,
                                  )
                                ],
                              );
                            } else {
                              return SizedBox();
                            }
                          }),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.comment,
                          color: AppColors.primary,
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(5),
                        ),
                        AppText(
                          text: '120 comment',
                          color: Colors.black,
                          fontSize: 3.2,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: getProportionateScreenHeight(5),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage('assets/images/IMG_8241.JPG'),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(10),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: comments,
                      keyboardType: TextInputType.emailAddress,
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'You Should type anything';
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 14),
                        hintText: 'write comment ...',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(5),
                  ),
                  TextButton(
                      onPressed: () {
                        ProjectCubit.get(context).addComment(
                          ProjectCubit.get(context).Id[widget.index],
                          comments.text,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.comment,
                            color: AppColors.primary,
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(5),
                          ),
                          AppText(
                            text: 'Add',
                            color: Colors.black,
                            fontSize: 3.2,
                          ),
                        ],
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
