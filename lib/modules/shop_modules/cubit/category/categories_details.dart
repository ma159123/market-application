import 'package:first_app/layout/shopCubitt/cubit.dart';
import 'package:first_app/layout/shopCubitt/states.dart';
import 'package:first_app/models/categories_details_model.dart';
import 'package:first_app/modules/shop_modules/cubit/products/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class ShopCategoriesDetails extends StatelessWidget {
  const ShopCategoriesDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Products',
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Conditional.single(
          fallbackBuilder: (BuildContext context) =>
              const Center(child: CircularProgressIndicator()),
          context: context,
          widgetBuilder: (BuildContext context) => ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 10,
                indent: 10,
                endIndent: 10,
                color: Colors.black,
                thickness: 1,
              ),
              itemCount: ShopCubit.get(context)
                  .categoriesDetailsModel!
                  .data!
                  .data!
                  .length,
              itemBuilder: (BuildContext context, int index) => builtItem(
                  ShopCubit.get(context)
                      .categoriesDetailsModel!
                      .data!
                      .data![index],
                  index,
                  context),
            ),
          conditionBuilder: (BuildContext context) =>
              state is! ShopGetCategoriesDetailsLoadingState,
        ),
      ),
      listener: (context, state) {},
    );
  }

  Widget builtItem(CategoryData model, index, context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: (){
            ShopCubit.get(context).getProduct(model.id!);
           print(model.id);
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProductDetails()));
          },
          child: Container(
            height: 120,
            color: Colors.white,
            child: Row(
              children: [
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    FadeInImage(
                      image: NetworkImage('${model.image}'),
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover, placeholder: AssetImage('assets/images/default.png'),
                    ),
                    if (model.discount != 0)
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          color: Colors.orangeAccent[200],
                          child: Text(
                            '-${model.discount!}%',
                            style: const TextStyle(fontSize: 18),
                          ))
                  ],
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name!,
                        style: const TextStyle(
                          fontSize: 20.0,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            '${model.price}',
                            style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                                color: Colors.blue),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          if (model.discount != 0)
                            Text(
                              '${model.oldPrice}',
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          const Spacer(),
                          IconButton(
                            color: ShopCubit.get(context).favorite[model.id]!
                                ? Colors.orangeAccent
                                : Colors.grey,
                            onPressed: () {
                              ShopCubit.get(context).changeFavorite(model.id!);
                            },
                            icon:ShopCubit.get(context).favorite[model.id!]! ?Icon(Icons.favorite):Icon(Icons.favorite_border_outlined),
                            padding: EdgeInsets.zero,
                          )
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
