import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/home_layout.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/modules/register/register_screen.dart';

import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import 'cubit/cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit,SocialLoginStates>(
          builder: (context, state) {
            var cubit = SocialLoginCubit.get(context);
            return Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/social-media.png',
                              width: MediaQuery.of(context).size.width / 3,
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          const Text(
                            'Login to communicate',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'email address must not be empty';
                              }

                              return null;
                            },
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              isDense: false,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  25.0,
                                ),
                              ),
                              label: const Text(
                                'email address',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'password is too short';
                              }

                              return null;
                            },
                            controller: passwordController,
                            decoration: InputDecoration(
                              isDense: false,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  25.0,
                                ),
                              ),
                              label: const Text(
                                'password',
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  cubit.changePasswordVisibility();
                                },
                                icon: Icon(cubit.suffix),
                              ),
                            ),
                            obscureText: cubit.isPassword,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            height: 42.0,
                            width: double.infinity,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(
                                25.0,
                              ),
                            ),
                            child: MaterialButton(
                              height: 42.0,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              child: state is SocialLoginLoadingState
                                  ? const CupertinoActivityIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an account?',
                              ),
                              TextButton(
                                onPressed: () {
                                  navigateTo(
                                    context,
                                    RegisterScreen(),
                                  );
                                },
                                child: const Text(
                                  'Register',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          listener: (context, state) {
            if (state is SocialLoginErrorState) {
              showToast(state.error, Colors.red);
            }
            if(state is SocialLoginSuccessState)
            {
              CacheHelper.putData(
                key: 'uId',
                value: state.uId,
              ).then((value)
              {
                navigateAndFinish(
                  context,
                  const HomeLayout(),
                );
              });
            }
          }),
    );
  }
}
