import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_app/layout/shopCubitt/cubit.dart';
import 'package:first_app/layout/shopCubitt/states.dart';
import 'package:first_app/models/shop_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'categories_details.dart';

class ShopCategory extends StatelessWidget {
  const ShopCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          fallback: (BuildContext context) =>const Center(child: CircularProgressIndicator()),
          builder: (BuildContext context) => ListView.separated(separatorBuilder: (BuildContext context, int index) =>const SizedBox(height: 10.0,),
              itemCount: ShopCubit.get(context).categoryModel!.data.data.length,
              itemBuilder: (BuildContext context, int index)=>buildCategoryItem(ShopCubit.get(context).categoryModel!.data.data[index],context)),
          condition: state is !ChangeBottomNavBarState,

        );

      },
    );
  }
  Widget buildCategoryItem(DataModel model,context){
    return Column(
      children: [
        InkWell(
          onTap: (){
            ShopCubit.get(context).getCategoryDetails(model.id);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopCategoriesDetails()));
          },
          child: Row(
            children:  [
              SizedBox(
                width: 100,
                height: 100,
                child: FadeInImage(
                  image: NetworkImage(model.image), placeholder: AssetImage('assets/images/default.png'),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(model.name,
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
