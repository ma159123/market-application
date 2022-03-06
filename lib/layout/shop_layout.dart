import 'package:first_app/layout/shopCubitt/cubit.dart';
import 'package:first_app/layout/shopCubitt/states.dart';
import 'package:first_app/modules/shop_modules/cubit/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        var cubit=ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.index],
            ),
            actions: [
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ShopSearch()));
              }, icon: const Icon(Icons.search,)),
            ],
          ),
          body: cubit.screens[cubit.index],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.index,
            onTap: (index) {
              cubit.changeBottomNavBar(index);
              cubit.changeAppBarTitle(index);
            },
            items: cubit.items,
          ),
        );
      },
    );
  }
}
