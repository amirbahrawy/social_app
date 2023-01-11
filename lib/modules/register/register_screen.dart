import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/home_layout.dart';
import 'package:social_app/modules/register/cubit/cubit.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
          builder: (context, state) {
            var cubit = SocialRegisterCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Register',
                ),
              ),
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
                            height: 40.0,
                          ),
                          const Text(
                            'Register now and discover app',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'username must not be empty';
                              }

                              return null;
                            },
                            controller: usernameController,
                            keyboardType: TextInputType.name,
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
                                'username',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
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
                            height: 20.0,
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
                                icon: Icon(
                                  cubit.suffix,
                                ),
                              ),
                            ),
                            obscureText: cubit.isPassword,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'phone is too short';
                              }

                              return null;
                            },
                            controller: phoneController,
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
                                'phone',
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            height: 42.0,
                            width: double.infinity,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(
                                35.0,
                              ),
                            ),
                            child: MaterialButton(
                              height: 42.0,
                              onPressed: () {
                                cubit.userRegister(
                                    name: usernameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text);
                              },
                              child: state is SocialRegisterLoadingState
                                  ? const CupertinoActivityIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'Register',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
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
          listener: (ctx, state) {
            if(state is SocialCreateUserErrorState){
              showToast(state.error, Colors.red);
            }
            if(state is SocialRegisterSuccessState){
              navigateAndFinish(context, const HomeLayout());
            }
          }),
    );
  }
}
