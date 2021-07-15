import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:technocloud_task/modules/cubit/cubit/cubit.dart';
import 'package:technocloud_task/modules/cubit/cubit/states.dart';
import 'package:technocloud_task/shared/styles/theme/app_colors.dart';
import 'package:technocloud_task/shared/widgets/app_text.dart';
import 'package:technocloud_task/view/addpost/addpost_screen.dart';
import 'package:technocloud_task/view/home/widget/postbody.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.post_add),
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: PostScreen(),
                inheritTheme: true,
                ctx: context),
          );
        },
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.broken_image,
                color: AppColors.primary,
              ))
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: AppText(
          text: 'Home',
          fontSize: 4,
          letterSpacing: 2,
          color: Colors.black54,
        ),
      ),
      body: BlocConsumer<ProjectCubit, BlocStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
            condition: ProjectCubit.get(context).posts.length > 0,
            fallback: (context) => Center(child: CircularProgressIndicator()),
            builder: (context) => SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: ProjectCubit.get(context).posts.length,
                        itemBuilder: (_, int i) {
                          return PostBody(
                            postModel: ProjectCubit.get(context).posts[i],
                            size: size,
                            index: i,
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
