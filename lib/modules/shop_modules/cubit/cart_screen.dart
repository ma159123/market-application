import 'package:first_app/layout/shopCubitt/cubit.dart';
import 'package:first_app/layout/shopCubitt/states.dart';
import 'package:first_app/models/get_cart_model.dart';
import 'package:first_app/modules/shop_modules/cubit/products/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class ShopCart extends StatelessWidget {
  const ShopCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      builder: (context, state) => Scaffold(
        body: Conditional.single(
          conditionBuilder: (BuildContext context) =>
              state is! ShopGetCartDataLoadingState,
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
            itemCount:
                ShopCubit.get(context).getCartModel!.data!.cartItems!.length,
            itemBuilder: (BuildContext context, int index) => builtItem(
                ShopCubit.get(context).getCartModel!.data!.cartItems![index],
                context),
          ),
        ),
      ),
      listener: (context, state) {},
    );
  }

  Widget builtItem(CartItems model, context) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: InkWell(
          onTap: () {
            ShopCubit.get(context).getProduct(model.product!.id);
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProductDetails()));
          },
          child: Container(
            height: 150,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      color: ShopCubit.get(context).favorite[model.product!.id]!
                          ? Colors.orangeAccent
                          : Colors.grey,
                      onPressed: () {
                        ShopCubit.get(context)
                            .changeFavorite(model.product!.id!);
                      },
                      icon: ShopCubit.get(context).favorite[model.product!.id]! ?Icon(Icons.favorite):Icon(Icons.favorite_border_outlined),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    InkWell(
                      onTap: () {
                        ShopCubit.get(context).changeCart(model.product!.id);
                      },
                      child: SizedBox(
                        height: 30.0,
                        child: Row(
                          children: const [
                            Icon(
                              Icons.delete,
                              color: Colors.orangeAccent,
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              'REMOVE',
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.orangeAccent),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 14.0,
                      backgroundColor: Colors.orangeAccent,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          int quantity = model.quantity! - 1;
                          ShopCubit.get(context).updateCart(
                              quantity: quantity, cartId: model.id!);
                        },
                        icon: const Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      '${model.quantity}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    CircleAvatar(
                      radius: 14.0,
                      backgroundColor: Colors.orangeAccent,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          int quantity = model.quantity! + 1;
                          ShopCubit.get(context).updateCart(
                              quantity: quantity, cartId: model.id!);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
