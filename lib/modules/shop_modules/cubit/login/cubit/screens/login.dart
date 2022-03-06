import 'package:first_app/layout/shop_layout.dart';
import 'package:first_app/modules/shop_modules/cubit/register.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:first_app/shared/constants/constants.dart';
import 'package:first_app/shared/network/local/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit.dart';
import '../states.dart';

class ShopLogin extends StatefulWidget {
  ShopLogin({Key? key}) : super(key: key);

  @override
  State<ShopLogin> createState() => _ShopLoginState();
}

class _ShopLoginState extends State<ShopLogin> {
  var emailController = TextEditingController();

  var passController = TextEditingController();
var isSecure=true;
  @override
  Widget build(BuildContext context) {
    var cubit = ShopLoginCubit.get(context);
    return BlocConsumer<ShopLoginCubit, ShopLoginStates>(
      listener: (context, state) {
        if (state is ShopLoginSuccessState) {
          if (state.shopLoginModel.status!) {
            defaultToast(
                text: state.shopLoginModel.message!, color: Colors.green);
            CacheHelper.saveData(
                    key: 'token', value: state.shopLoginModel.data.token)!
                .then((value) {
              token = state.shopLoginModel.data.token!;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopLayout()),
                  (route) => false);
            });
          }
        } else if(state is ShopLoginErrorState) {
          defaultToast(
              text:
                  'لم نتمكن من تسجيل الدخول برجاء التأكد من البيانات المدخلة');
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 30.0),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: emailController,
                    onFieldSubmitted: (value) {},
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                         setState(() {
                           isSecure=!isSecure;
                         });
                        },
                        icon: isSecure
                            ? const Icon(Icons.visibility_off_sharp)
                            : const Icon(Icons.remove_red_eye_outlined),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: isSecure,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  defaultButton(
                      function: () {
                        cubit.userLogin(
                          password: passController.text,
                          email: emailController.text,
                        );
                      },
                      text: 'Login'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopRegister()));
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }
}
