import 'package:first_app/layout/shopCubitt/cubit.dart';
import 'package:first_app/layout/shopCubitt/states.dart';
import 'package:first_app/shared/network/local/cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import 'login/cubit/screens/login.dart';

class AccountScreen extends StatelessWidget {

  void signOut(context){
    CacheHelper.removeData(key: 'token', )!.then((value) {
      if(value){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ShopLogin()),
                (route) => false);
      }
    });
  }
  var formKey=GlobalKey<FormState>();
  var nameController=TextEditingController();
  var emailController=TextEditingController();
  var phoneController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(

      listener: ( context, state) {
        // if (state is ShopLoginSuccessState) {
        //   if (state.shopLoginModel.status!) {
        //     defaultToast(text: state.shopLoginModel.message!,color: Colors.green);
        //     CacheHelper.saveData(
        //         key: 'token', value: state.shopLoginModel.data.token)!.then((value) {
        //       token=state.shopLoginModel.data.token!;
        //       Navigator.pushAndRemoveUntil(
        //           context,
        //           MaterialPageRoute(builder: (context) => const ShopLayout()),
        //               (route) => false);
        //     });
        //   }
        // }else{
        //   defaultToast(text: 'لم نتمكن من تسجيل الدخول برجاء التأكد من البيانات المدخلة');
        // }
      },
      builder: ( context,  state) {
        ShopCubit cubit=ShopCubit.get(context);
        var model=cubit.shopLoginModel;

        nameController.text=model!.data.name!;
        emailController.text=model.data.email!;
        phoneController.text=model.data.phone!;


        return Conditional.single(
          context: context,
          conditionBuilder: ( context)=>ShopCubit.get(context).shopLoginModel !=null ,
          widgetBuilder: ( context)=>Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if(state is ShopUpdateUserDataLoadingState)
                      const LinearProgressIndicator(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.greenAccent,
                      child: Icon(
                        Icons.person,color: Colors.white,size: 60.0,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.greenAccent,
                          child: Icon(
                            Icons.person,color: Colors.white,size: 30.0,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: nameController,
                              validator: (value){
                                if(value!.isEmpty)
                                {
                                  return 'name must not be empty';
                                }
                                return null;
                              },
                              // decoration: const InputDecoration(
                              //  border: OutlineInputBorder(),
                              //  // labelText: 'Name',
                              //   prefixIcon: Icon(Icons.person),
                              //
                              // ),
                              keyboardType: TextInputType.name,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.orangeAccent,
                          child: Icon(
                            Icons.email,color: Colors.white,size: 25.0,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:  TextFormField(
                              controller: emailController,
                              validator: (value){
                                if(value!.isEmpty)
                                {
                                  return 'Email must not be empty';
                                }
                                return null;
                              },
                              // decoration: const InputDecoration(
                              //   border: OutlineInputBorder(),
                              //   labelText: 'Email',
                              //   prefixIcon: Icon(Icons.email),
                              //
                              // ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.orangeAccent,
                          child: Icon(
                            Icons.phone,color: Colors.white,size: 25.0,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:   TextFormField(
                              controller: phoneController,
                              validator: (value){
                                if(value!.isEmpty)
                                {
                                  return 'Phone must not be empty';
                                }
                                return null;
                              },
                              // decoration: const InputDecoration(
                              //   border: OutlineInputBorder(),
                              //   labelText: 'Phone',
                              //   prefixIcon: Icon(Icons.phone),
                              //
                              // ),
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: (){
                        signOut(context);
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.redAccent,
                            child: Icon(
                              Icons.logout,color: Colors.white,size: 25.0,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  Text('Logout',style: TextStyle(fontSize: 20,),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //defaultButton(function: () {  signOut(context); }, text: 'Logout'),
                    const SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: (){
                        if(formKey.currentState!.validate()){
                          ShopCubit.get(context).updateUserData(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                          );
                        }
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.indigoAccent,
                            child: Icon(
                              Icons.update,color: Colors.white,size: 25.0,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  Text('update',style: TextStyle(fontSize: 20,),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // defaultButton(function: () {
                    //   if(formKey.currentState!.validate()){
                    //     ShopCubit.get(context).updateUserData(
                    //       name: nameController.text,
                    //       email: emailController.text,
                    //       phone: phoneController.text,
                    //     );
                    //   }
                    // }, text: 'update'),
                  ],
                ),
              ),
            ),
          ),
          fallbackBuilder: (BuildContext context)=>const Center(child: CircularProgressIndicator()),
        );


      },

    );
  }
}


