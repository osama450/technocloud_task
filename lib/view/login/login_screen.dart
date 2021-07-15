import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technocloud_task/modules/cubit/cubit/cubit.dart';
import 'package:technocloud_task/modules/cubit/cubit/states.dart';
import 'package:technocloud_task/shared/components/components.dart';
import 'package:technocloud_task/shared/styles/theme/app_colors.dart';
import 'package:technocloud_task/view/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => ProjectCubit(),
      child: BlocConsumer<ProjectCubit, BlocStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            showToast(text: state.error, state: ToastStates.ERROR);
          }
          if (state is LoginSuccessState) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => HomeScreen()));
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          'Login now to browse our hot offers',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          // ignore: missing_return
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Email must not be empty';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email_outlined),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            border: OutlineInputBorder(
                              // on error only
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        TextFormField(
                          obscureText: ProjectCubit.get(context).isPassword,
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          // ignore: missing_return
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Password must not be empty';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            border: OutlineInputBorder(
                              // on error only
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                ProjectCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              child: Icon(
                                ProjectCubit.get(context).suffix,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            if (formKey.currentState.validate()) {
                              ProjectCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                        ),
                        SizedBox(height: height * 0.03),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (BuildContext context) {
                            return InkWell(
                              onTap: () {
                                if (formKey.currentState.validate()) {
                                  ProjectCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              child: Container(
                                height: 50,
                                color: AppColors.primary,
                                width: double.infinity,
                                child: Center(
                                    child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                )),
                              ),
                            );
                          },
                          fallback: (BuildContext context) => Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              backgroundColor:
                                  AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ],
                    ),
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
