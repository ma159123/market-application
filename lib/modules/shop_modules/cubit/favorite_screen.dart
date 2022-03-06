import 'package:first_app/layout/shopCubitt/cubit.dart';
import 'package:first_app/layout/shopCubitt/states.dart';
import 'package:first_app/models/get_favorites_model.dart';
import 'package:first_app/modules/shop_modules/cubit/products/product_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class ShopFavorite extends StatelessWidget {
  const ShopFavorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      builder: (context, state) => Conditional.single(
        fallbackBuilder: (BuildContext context) => const Center(child: CircularProgressIndicator()),
        context: context,
        widgetBuilder: (BuildContext context) => ListView.separated(
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 10,
            indent: 10,
            endIndent: 10,
            color: Colors.black,
            thickness:1 ,
          ),
          itemCount:
              ShopCubit.get(context).getFavoritesModel!.data!.data!.length,
          itemBuilder: (BuildContext context, int index) => builtItem(
              ShopCubit.get(context).getFavoritesModel!.data!.data![index],
              context),
        ),
        conditionBuilder: (BuildContext context)=>state
         is! ShopGetFavLoadingState,
      ),
      listener: (context, state) {},
    );
  }

  Widget builtItem(FavoritesData model, context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: (){
            print(model.product!.id);
            ShopCubit.get(context).getProduct(model.product!.id!);
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
                      image: NetworkImage('${model.product!.image}'),
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover, placeholder: AssetImage('assets/images/default.png'),
                    ),
                    if (model.product!.discount != 0)
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          color: Colors.orangeAccent[200],
                          child: Text(
                            '-${model.product!.discount!}%',
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
                        model.product!.name!,
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
                            '${model.product!.price}',
                            style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                                color: Colors.blue),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          if (model.product!.discount != 0)
                            Text(
                              '${model.product!.oldPrice}',
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          const Spacer(),
                          IconButton(
                            color:ShopCubit.get(context)
                                .favorite[model.product!.id]!
                                ? Colors.orangeAccent
                                : Colors.grey,
                            onPressed: () {
                              ShopCubit.get(context)
                                  .changeFavorite(model.product!.id!);
                            },
                            icon: ShopCubit.get(context).favorite[model.product!.id]! ?Icon(Icons.favorite):Icon(Icons.favorite_border_outlined),
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
