import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_app/layout/shopCubitt/cubit.dart';
import 'package:first_app/layout/shopCubitt/states.dart';
import 'package:first_app/models/produt_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) => state is ShopGetProductDetailsLoadingState
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Details',
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: ConditionalBuilder(
                builder: (BuildContext context) => buildProductItem(
                    ShopCubit.get(context).getProductDetails!, context),
                condition: state is! ShopGetProductDetailsLoadingState,
                fallback: (BuildContext context) =>
                    const Center(child: CircularProgressIndicator()),
              ),
            ),
    );
  }

  Widget buildProductItem(GetProductDetailsModel model, context) => Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider(
                        items: model.data!.images!
                            .map((e) => FadeInImage(
                                  image: NetworkImage(e),
                                  //fit: BoxFit.cover,
                                  width: double.infinity,
                                  placeholder: const AssetImage(
                                      'assets/images/default.png'),
                                ))
                            .toList(),
                        options: CarouselOptions(
                          height: 200,
                          initialPage: 0,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration: const Duration(seconds: 1),
                          scrollDirection: Axis.horizontal,
                        )),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      model.data!.name!,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Text(
                          'EGP ${model.data!.price!}',
                          style: const TextStyle(
                              fontSize: 23.0, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                          color: ShopCubit.get(context).favorite[model.data!.id]!
                                  ? Colors.orangeAccent
                                  : Colors.grey,
                          onPressed: () {
                            ShopCubit.get(context).changeFavorite(model.data!.id!);
                          },
                          icon: ShopCubit.get(context).favorite[model.data!.id]!
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_border_outlined),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    if (model.data!.discount! > 0)
                      Row(
                        children: [
                          Text(
                            'EGP ${model.data!.oldPrice!}',
                            style: const TextStyle(
                                fontSize: 18.0,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Container(
                              color: Colors.orangeAccent[200],
                              child: Text(
                                '-${model.data!.discount!}%',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              )),
                        ],
                      ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Text(
                      'Description',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(model.data!.description!,
                        style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  ShopCubit.get(context).changeCart(model.data!.id!);
                  ShopCubit.get(context).inCart =
                      !ShopCubit.get(context).inCart;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ShopCubit.get(context).inCart
                        ? Colors.green
                        : Colors.orange,
                    borderRadius: BorderRadius.circular(5.0)),
                height: 45.0,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20.0,
                    ),
                    Icon(
                      ShopCubit.get(context).inCart
                          ? Icons.shopping_cart_outlined
                          : Icons.add_shopping_cart,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 100.0,
                    ),
                    Text(
                      ShopCubit.get(context).inCart ? 'IN CART' : 'ADD TO CART',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
