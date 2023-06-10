import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_ecommerce/layout/cubit/cubit.dart';
import 'package:shop_ecommerce/layout/shop_layout.dart';
import 'package:shop_ecommerce/modules/login/cubit/cubit.dart';
import 'package:shop_ecommerce/modules/login/cubit/states.dart';
import 'package:shop_ecommerce/modules/register/shop_register_screen.dart';
import 'package:shop_ecommerce/shared/adaptive/adaptivw_indicator.dart';
import 'package:shop_ecommerce/shared/components/componets.dart';
import 'package:shop_ecommerce/shared/components/constants.dart';
import 'package:shop_ecommerce/shared/network/local/cache_helper.dart';

class ShopLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passController = TextEditingController();
    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {

          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status) {
              // print(state.loginModel.message!);
              print(state.loginModel.toJson());
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.token.toString(),
              ).then((value) {
                token = state.loginModel.token.toString();

                navigateAndFinish(
                  context,
                  ShopLayout(),
                );
              });

              showToast(
                text: state.loginModel.message,
                state: ToastStates.SUCCESS,
              );
            } else {
              print(state.loginModel.message);
              showToast(
                text: state.loginModel.message,
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          controller: emailController,
                          keyboardType: TextInputType.name,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your User name';
                            }
                          },
                          label: 'User name ',
                          prefix: Icons.person,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                          controller: passController,
                          keyboardType: TextInputType.visiblePassword,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                username: emailController.text,
                                password: passController.text,
                              );
                            }
                          },
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'password is too short';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                          suffix: ShopLoginCubit.get(context).suffix,
                          isPassword: ShopLoginCubit.get(context).isPassword,
                          suffixPressed: () {
                            ShopLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        (state is! ShopLoginLoadingState)
                            ? defaultButton(
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopLoginCubit.get(context).userLogin(
                                      username: emailController.text,
                                      password: passController.text,
                                    );
                                  }
                                },
                                text: 'login')
                            : Center(
                                child: AdaptiveIndicator(
                                os: getOS(),
                              )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text(
                              'Don\'t have an account?',
                            ),
                            defaultTextButton(
                                function: () {
                                  navigateTo(context, ShopRegisterScreen());
                                },
                                text: 'register'),
                            Spacer()
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
      ),
    );
  }
}
