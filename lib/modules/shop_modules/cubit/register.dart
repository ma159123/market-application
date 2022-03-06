import 'package:first_app/modules/shop_modules/cubit/login/cubit/screens/login.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login/cubit/cubit.dart';
import 'login/cubit/states.dart';

class ShopRegister extends StatefulWidget {
  ShopRegister({Key? key}) : super(key: key);

  @override
  State<ShopRegister> createState() => _ShopRegisterState();
}

class _ShopRegisterState extends State<ShopRegister> {
  var nameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passController = TextEditingController();

bool isSecure=true;

  @override
  Widget build(BuildContext context) {
    var cubit = ShopLoginCubit.get(context);
    return BlocConsumer<ShopLoginCubit, ShopLoginStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Register',
                    style: TextStyle(fontSize: 30.0),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: nameController,
                    onFieldSubmitted: (value) {
                      print(value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.account_circle_outlined),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: emailController,
                    onFieldSubmitted: (value) {
                      print(value);
                    },
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
                        icon: isSecure
                            ? const Icon(Icons.visibility_off_sharp)
                            : const Icon(Icons.remove_red_eye_outlined),
                        onPressed: () {
                         setState(() {
                           isSecure= !isSecure;
                         });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: isSecure,
                  ),
                  //   keyboardType: TextInputType.visiblePassword,
                  //   obscureText: true,
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  defaultButton(
                      function: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShopLogin()));
                        cubit.userRegister(
                            password: passController.text,
                            email: emailController.text,
                            name: nameController.text,
                            phone: phoneController.text);
                        cubit.verifyEmail(email: emailController.text);
                      },
                      text: 'Register'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have account?'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopLogin()));
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
